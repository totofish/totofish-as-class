/**
 * @author totofish
 * @date 2010/4/26 - 2010/7/27
 * @email eaneanean@hotmail.com
 */

/******************************************

用法說明：
MC.init = function(){
	MC.smooth(0.2,0.2,0,0);
	MC.Clearsmooth();
	MC.smooth();
	MC.onClick = function(){
		trace(home_btn);
	}
	MC.onOver = MC.onOut = MC.onDown = MC.onUp = EventHandler;
	trace(MC.selected);
	trace(MC.isActive);
	MC.Disable();
	MC.Enable();
	MC.core.selected = !MC.core.selected;
	MC.setEvent({onClick:EventHandler,
				 onDown:EventHandler,
				 onOver:EventHandler,
				 onOut:EventHandler,
				 onUp:EventHandler});
}

function EventHandler(e:Event){
	// e.target --- MC
	// e.type   --- 事件
}
function EventHandler(){
	// arguments[0].target --- MC
	// arguments[0].type   --- 事件
}
function EventHandler(...args){
	// args[0].target   --- MC
	// args[0].type     --- 事件
}


特別限制：
假如 hit 物件是 SimpleButton
那init時滑鼠已在按鈕上時偵測是否MouseOver時將會以外框矩形範圍為感應區
如果要精確感應區 hit 物件請用 MovieClip(透明度可以調0) 或是不使用 hit 感應物件

*********************************************/

package totofish.ui {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import totofish.interfaces.IButton;
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	public class ParentButton extends MovieClip implements IButton {
		// Label 狀態標籤名
		public var LABEL_UP:String = "Up";
		public var LABEL_OVER:String = "Over";
		public var LABEL_DOWN:String = "Down";
		public var LABEL_SELECTED:String = "Selected";  // 非主動
		public var LABEL_DISABLE:String = "Disable";    // 非主動
		
		// EVENT 偵聽事件
		public static const CLICK:String = "Click";
		public static const OVER:String = "OVER";
		public static const DOWN:String = "DOWN";
		public static const UP:String = "UP";
		public static const OUT:String = "OUT";
		
		public var SmoothObj:Object = { up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 };       // 狀態平滑時間
		private var Target:MovieClip;                                                                // 目標物
		private var HitBtn:*;                                                                        // 感應範圍
		protected var isSelected:Boolean = false;                                                    // 是否選取狀態
		protected var isActive:Boolean = true;                                                       // 是否可感應狀態
		private var labels:Object;                                                                   // label紀錄
		private var frameTween:TweenMax;
		
		public function ParentButton() {
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			visible = false;
			mouseChildren = false;
			mouseEnabled = false;
			
			Target = parent as MovieClip;
			Target.stop();
			Target.tabEnabled = false;
			
			// 附加功能到目標上
			Target.smooth = smooth;
			Target.Clearsmooth = Clearsmooth;
			Target.Disable = Disable;
			Target.Enable = Enable;
			Target.setEvent = setEvent;
			Target.core = this;
			
			// addEventListener
			Target.addEventListener(ParentButton.OVER, EventHandler, false, 0, true);
			Target.addEventListener(ParentButton.OUT, EventHandler, false, 0, true);
			Target.addEventListener(ParentButton.DOWN, EventHandler, false, 0, true);
			Target.addEventListener(ParentButton.UP, EventHandler, false, 0, true);
			Target.addEventListener(ParentButton.CLICK, EventHandler, false, 0, true);
			Target.addEventListener("init", EventHandler, false, 0, true);
			
			updateLabels();
			
			// 延遲一格1.確保core影格更上層物件載入完畢2.讓外部使用的程式有時間註冊init等事件
			addEventListener(Event.ENTER_FRAME, init, false, 0, true);
		}
		
		private function init(e:Event=null):void {
			if(this.hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, init);
			// 初始化
			HitBtn = Target["hit"];
			if(!HitBtn) HitBtn = Target;
			
			HitBtn is MovieClip ? HitBtn.buttonMode = true : null;

			HitBtn.addEventListener(MouseEvent.ROLL_OVER,MouseHandler,false,0,true);
			HitBtn.addEventListener(MouseEvent.ROLL_OUT,MouseHandler,false,0,true);
			HitBtn.addEventListener(MouseEvent.MOUSE_DOWN, MouseHandler, false, 0, true);
			HitBtn.addEventListener(MouseEvent.MOUSE_UP, MouseHandler, false, 0, true);
			HitBtn.addEventListener(MouseEvent.CLICK,MouseHandler,false,0,true);
			
			Target.selected = selected;
			Target.isActive = isActive;
			
			if (!isActive) {
				Target.gotoAndStop(LABEL_DISABLE);
			}else if (isSelected){
				Target.gotoAndStop(LABEL_SELECTED);
			}else{
				if(HitBtn is SimpleButton){
					if (HitBtn.hitTestState.hitTestPoint(HitBtn.mouseX, HitBtn.mouseY, false)) {
						Target.dispatchEvent(new Event(ParentButton.OVER));
						JumpLabel(LABEL_OVER);
					}
				}else{
					if(stage){
						if (HitBtn.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
							Target.dispatchEvent(new Event(ParentButton.OVER));
							JumpLabel(LABEL_OVER);
						}
					}
				}
			}
			
			// init
			Target.dispatchEvent(new Event("init"));
		}
		
		private function MouseHandler(e:MouseEvent):void {
			if(isActive){
				switch(e.type){
					case MouseEvent.ROLL_OVER:
						Target.dispatchEvent(new Event(ParentButton.OVER));
						JumpLabel(LABEL_OVER);
					break;
					case MouseEvent.ROLL_OUT:
						Target.dispatchEvent(new Event(ParentButton.OUT));
						JumpLabel(LABEL_UP);
					break;
					case MouseEvent.MOUSE_DOWN:
						Target.dispatchEvent(new Event(ParentButton.DOWN));
						JumpLabel(LABEL_DOWN);
					break;
					case MouseEvent.MOUSE_UP:
						Target.dispatchEvent(new Event(ParentButton.UP));
						JumpLabel(LABEL_OVER);
					break;
					case MouseEvent.CLICK:
						Target.dispatchEvent(new Event(ParentButton.CLICK));
				}
			}
		}
		
		private function EventHandler(e:Event):void {
			switch(e.type) {
				case "init":
					call("init","init",e);
				break;
				case ParentButton.OVER:
					call("onOver",OVER,e);
				break;
				case ParentButton.OUT:
					call("onOut",OUT,e);
				break;
				case ParentButton.DOWN:
					call("onDown",DOWN,e);
				break;
				case ParentButton.UP:
					call("onUp",UP,e);
				break;
				case ParentButton.CLICK:
					call("onClick",CLICK,e);
			}
		}
		
		private function call(eventStr:String, type:String, e:Event):void {
			if (Target.hasOwnProperty(eventStr)) Target[eventStr].apply(null, [ e ]);
		}
		
		private function JumpLabel(label:String):void {
			if (isSelected) label = LABEL_SELECTED;
			if (!isActive) label = LABEL_DISABLE;
			var frames:int = getFrameNumber(label)
			
			if (frames > 0) {
				if (frameTween) {
					frameTween.invalidate();
					frameTween.kill();
				}
				var time:Number;
				switch(label) {
					case LABEL_UP:
						time = SmoothObj.up;
					break;
					case LABEL_OVER:
						time = SmoothObj.over;
					break;
					case LABEL_DOWN:
						time = SmoothObj.down;
					break;
					case LABEL_SELECTED:
						time = SmoothObj.selected;
					break;
					case LABEL_DISABLE:
						time = SmoothObj.disable;
				}
				
				if (Target == null) return;
				if (isNaN(time)) {
					time = Math.abs(Target.currentFrame - frames) / (stage == null ? 30 : stage.frameRate);
				}
				frameTween = new TweenMax(Target, time, { frameLabel:label, ease:Linear.easeNone } );
			}
		}
		
		private function getFrameNumber(frame:*):uint {
			var frameNum:uint = uint(frame);
			if (frameNum) { return frameNum; }
			var label:String = String(frame);
			if (label == null) { return 0; }
			frameNum = labels[label];
			return frameNum;
		}
		private function updateLabels():void {
			var lbls:Array = Target.currentLabels;
			labels = {};
			for (var i:uint=0; i<lbls.length; i++) {
				labels[lbls[i].name] = lbls[i].frame;
			}
		}
		/////////////////////////////
		//
		// public setter getter
		//
		/////////////////////////////
		
		public function set selected(b:Boolean):void {
			isSelected = b;
			if (isActive) {
				if (isSelected) {
					JumpLabel(LABEL_SELECTED);
				}else {
					JumpLabel(LABEL_UP);
				}
			}
			Target.selected = b;
		}
		
		public function get selected():Boolean{
			return isSelected;
		}
		
		///////////////////////////////
		//
		// public function
		//
		///////////////////////////////
		
		public function smooth(u:Number=NaN,o:Number=NaN,d:Number=NaN,s:Number=NaN,dis:Number=0):void {
			SmoothObj.up = u;
			SmoothObj.over = o;
			SmoothObj.down = d;
			SmoothObj.selected = s;
			SmoothObj.disable = dis;
		}
		public function Clearsmooth():void {
			SmoothObj.up = NaN;
			SmoothObj.over = NaN;
			SmoothObj.down = NaN;
			SmoothObj.selected = NaN;
			SmoothObj.disable = 0;
		}
		public function Disable():void {
			isActive = false;
			HitBtn.mouseEnabled = false;
			Target.mouseChildren = false;
			Target.mouseEnabled = false;
			HitBtn is MovieClip ? HitBtn.buttonMode = true : null;
			Target.isActive = isActive;
			JumpLabel(LABEL_DISABLE);
		}
		public function Enable():void {
			isActive = true;
			HitBtn.mouseEnabled = true;
			Target.mouseChildren = true;
			Target.mouseEnabled = true;
			HitBtn is MovieClip ? HitBtn.buttonMode = true : null;
			Target.isActive = isActive;
			if (isSelected) JumpLabel(LABEL_SELECTED);
			else JumpLabel(LABEL_UP);
		}
		public function isEnable():Boolean{
			return isActive;
		}
		public function setEvent(EventObj:Object):void {
			for(var i in EventObj){
				Target[i] = EventObj[i];
			}
		}
	}
}