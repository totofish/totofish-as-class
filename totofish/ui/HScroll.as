/**
 * @author totofish
 * @date 2010/5/27
 * @email eaneanean@hotmail.com
 */

/******************************************
用法說明：
var HS:HScroll = new HScroll({bar:bar_mc,          // 拉把
							  barW:100,            // 拉把移動限制距離
							  content:content_mc,  // 內容
							  areaW:100,           // 內容顯示範圍寬度
							  left:left_mc,
							  right:right_mc});         

HS.reset();
							  
*********************************************/
 
package totofish.ui {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class HScroll{
		
		private var _bar:MovieClip;
		private var _barX:Number;
		private var _barRange:Number;
		private var _content:DisplayObject;
		private var _contentX:Number;
		private var _areaW:Number;
		private var _left:DisplayObject;
		private var _right:DisplayObject;
		private var dragging:Boolean = false;             // 拖拉中
		private var stepMode:String;                      // 進步移動方向
		private var stepTimer:Timer = new Timer(400);     // 進步移動時間
		private var stepX:Number;                         // 進步移動數
		
		public function HScroll(setObj:Object) {
			_bar = setObj.bar;
			_barX = _bar.x;
			_barRange = setObj.barW;
			_bar.buttonMode = true;
			
			if(setObj.left) _left = setObj.left;
			if(setObj.right) _right = setObj.right;
			
			_content = setObj.content;
			_contentX = _content.x;
			_areaW = setObj.areaW;
			
			reset();
			
			_bar.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
			_bar.addEventListener(Event.ADDED_TO_STAGE, onAdd, false, 0, true);
			
			stepTimer.addEventListener(TimerEvent.TIMER, onStepMove, false, 0, true);
		}
		
		private function onAdd(e:Event):void {
			reset();
		}
		
		private function onRemove(e:Event):void {
			_bar.stopDrag();
			dragging = false;
			_bar.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
			_bar.stage.removeEventListener(MouseEvent.MOUSE_UP, barHandler);
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
		}
		
		private function barHandler(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					_bar.addEventListener(Event.ENTER_FRAME, EnterFrame, false, 0, true);
					_bar.stage.addEventListener(MouseEvent.MOUSE_UP, barHandler, false, 0, true);
					switch(e.currentTarget) {
						case _bar:
							_bar.startDrag(false, new Rectangle(_barX, _bar.y, _barRange, 0));
							dragging = true;
						break;
						case _left:
							stepTimer.delay = 400;
							stepTimer.start();
							dragging = true;
							stepX = -_barRange / 15;
							move(stepX);
						break;
						case _right:
							stepTimer.delay = 400;
							stepTimer.start();
							dragging = true;
							stepX = _barRange/15;
							move(stepX);
					}
					
				break;
				case MouseEvent.MOUSE_UP:
					_bar.stopDrag();
					dragging = false;
					if(stepTimer.running) stepTimer.stop();
					if(_bar["stage"]) _bar.stage.removeEventListener(MouseEvent.MOUSE_UP, barHandler);
				break;
			}
		}
		
		private function onStepMove(e:TimerEvent):void {
			stepTimer.delay = 60;
			move(stepX);
		}
		private function move(value:Number):void {
			_bar.x += value;
			_bar.x = _bar.x > _barX + _barRange ? _barX + _barRange : _bar.x < _barX ? _barX : _bar.x;
		}
		
		private function EnterFrame(e:Event):void {
			var MovePoint:Number = (_bar.x - _barX) / _barRange * -(_content.width - _areaW) + _contentX;
			_content.x += (MovePoint - _content.x) * .2;
			
			if(Math.abs(MovePoint - _content.x) < 0.5 && !dragging){
				_content.x = MovePoint;
				_bar.removeEventListener(Event.ENTER_FRAME, EnterFrame);
			}
		}
		
		private function wheel(e:MouseEvent):void {
			if (_content.width > _areaW) {
				//_bar.x -= e.delta * _barRange / 3 * .1;
				_bar.x -= e.delta * (_barRange / ((_content.width - _areaW)/10));
				if (_bar.x<_barX) {
					_bar.x = _barX;
				} else if (_bar.x > _barX + _barRange) {
					_bar.x = _barX + _barRange;
				}
			}
			_bar.addEventListener(Event.ENTER_FRAME, EnterFrame, false, 0, true);
		}
		
		public function reset():void {
			_bar.x = _barX;
			_content.x = _contentX;
			
			if (_content.width <= _areaW) {
				_bar.visible = false;
				if (_left) {
					_left.visible = false;
					_left.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				if (_right) {
					_right.visible = false;
					_right.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				
				_content.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
				_bar.removeEventListener(MouseEvent.MOUSE_DOWN, barHandler);
			}else {
				_bar.visible = true;
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, wheel,false,0,true);
				_bar.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				if (_left) {
					_left.visible = true;
					_left.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
				if (_right) {
					_right.visible = true;
					_right.addEventListener(MouseEvent.MOUSE_DOWN, barHandler);
				}
			}
		}
	}
}