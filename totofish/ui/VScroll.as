/**
 * @author totofish
 * @date 2010/5/27-2011/8/17
 * @email eaneanean@hotmail.com
 */

/******************************************
用法說明：
var VS:VScroll = new VScroll({bar:bar_mc,          // 拉把
							  barH:100,            // 拉把移動限制距離
							  content:content_mc,  // 內容
							  areaH:100,           // 內容顯示範圍高度
							  top:top_mc,
							  bottom:bottom_mc});        

VS.reset();
							  
*********************************************/
 
package totofish.ui {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class VScroll{
		
		private var _bar:MovieClip;
		private var _bar_y:Number;
		private var _barY:Number;
		private var _barRange:Number;
		private var _content:DisplayObject;
		private var _contentY:Number;
		private var _areaH:Number;
		private var _top:DisplayObject;
		private var _bottom:DisplayObject;
		private var dragging:Boolean = false;             // 拖拉中
		private var stepMode:String;                      // 進步移動方向
		private var stepTimer:Timer = new Timer(400);     // 進步移動時間
		private var stepY:Number;                         // 進步移動數
		
		/**
		 * 實現簡易直向 scroll bar 效果<br />
		 * <code>
		 * var VS:VScroll = new VScroll({bar:bar_mc,          // 拉把
		 *								 barH:100,            // 拉把移動限制距離
		 *								 content:content_mc,  // 內容
		 *								 areaH:100,           // 內容顯示範圍高度
		 *								 top:top_mc,
		 *								 bottom:bottom_mc});        
		 * 
		 * VS.reset();
		 * </code>
		 * @param	setObj  參數設定 For example: {bar:bar_mc, barH:100, content:content_mc, areaH:100, top:top_mc, bottom:bottom_mc}
		 */
		public function VScroll(setObj:Object) {
			_barY = _bar_y = 0;
			_barRange = 100;
			if (setObj.bar) {
				_bar = setObj.bar;
				_barY = _bar_y = _bar.y;
				_barRange = setObj.barH;
				_bar.buttonMode = true;
			}
			if(setObj.top) _top = setObj.top;
			if(setObj.bottom) _bottom = setObj.bottom;
			
			_content = setObj.content;
			_contentY = _content.y;
			_areaH = setObj.areaH;
			
			reset();
			
			_content.addEventListener(Event.ADDED_TO_STAGE, onAdd, false, 0, true);
			stepTimer.addEventListener(TimerEvent.TIMER, onStepMove, false, 0, true);
		}
		
		private function onAdd(e:Event):void {
			_content.removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			_content.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
			reset();
		}
		
		private function onRemove(e:Event):void {
			_content.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			if (_bar) {
				_bar.stopDrag();
				_bar.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
			}
			_content.stage.removeEventListener(MouseEvent.MOUSE_UP, barHandler);
			dragging = false;
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
		}
		
		private function barHandler(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					_content.addEventListener(Event.ENTER_FRAME, EnterFrame, false, 0, true);
					_content.stage.addEventListener(MouseEvent.MOUSE_UP, barHandler, false, 0, true);
					switch(e.currentTarget) {
						case _bar:
							_bar.startDrag(false, new Rectangle(_bar.x, _barY, 0, _barRange));
							dragging = true;
						break;
						case _top:
							stepTimer.delay = 400;
							stepTimer.start();
							dragging = true;
							stepY = -_barRange / 15;
							move(stepY);
						break;
						case _bottom:
							stepTimer.delay = 400;
							stepTimer.start();
							dragging = true;
							stepY = _barRange/15;
							move(stepY);
					}
					
				break;
				case MouseEvent.MOUSE_UP:
					if(_bar) _bar.stopDrag();
					dragging = false;
					if(stepTimer.running) stepTimer.stop();
					if(_content["stage"]) _content.stage.removeEventListener(MouseEvent.MOUSE_UP, barHandler);
				break;
			}
		}
		
		private function onStepMove(e:TimerEvent):void {
			stepTimer.delay = 60;
			move(stepY);
		}
		private function move(value:Number):void {
			_bar_y += value;
			_bar_y = _bar_y > _barY + _barRange ? _barY + _barRange : _bar_y < _barY ? _barY : _bar_y;
			if(_bar) _bar.y = _bar_y;
		}
		
		private function EnterFrame(e:Event):void {
			if (_bar) _bar_y = _bar.y;
			var MovePoint:Number = (_bar_y - _barY) / _barRange * -(_content.height - _areaH) + _contentY;
			_content.y += (MovePoint - _content.y) * .2;
			
			if(Math.abs(MovePoint - _content.y) < 0.5 && !dragging){
				_content.y = MovePoint;
				_content.removeEventListener(Event.ENTER_FRAME, EnterFrame);
			}
		}
		
		private function wheel(e:MouseEvent):void {
			if (_content.height > _areaH) {
				//_bar.y -= e.delta * _barRange / 3 * .1;
				_bar_y -= e.delta * (_barRange / ((_content.height - _areaH) / 10));
				_bar_y = _bar_y < _barY ? _barY : _bar_y > _barY + _barRange ? _barY + _barRange : _bar_y;
				if(_bar) _bar.y = _bar_y;
			}
			_content.addEventListener(Event.ENTER_FRAME, EnterFrame, false, 0, true);
		}
		
		public function reset():void {
			_bar_y = _barY;
			if(_bar) _bar.y = _bar_y;
			_content.y = _contentY;
			
			if (_content.height <= _areaH) {
				if(_bar) _bar.visible = false;
				if (_top) {
					_top.visible = false;
					_top.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				if (_bottom) {
					_bottom.visible = false;
					_bottom.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				
				_content.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
				if(_bar) _bar.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
			}else {
				if(_bar) _bar.visible = true;
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, wheel,false,0,true);
				if(_bar) _bar.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				if (_top) {
					_top.visible = true;
					_top.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				if (_bottom) {
					_bottom.visible = true;
					_bottom.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
			}
		}
	}
}