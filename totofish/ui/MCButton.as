/**
 * @author totofish
 * @date 2010/9/16
 * @email eaneanean@hotmail.com
 */

package totofish.ui {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;

/**
 * 用法說明：
 * 
 * import flash.display.DisplayObject;
 * import totofish.ui.MCButton;
 *  // MC -- 某一 MovieClip 物件實體
 * MC.init = function(e:Event){
 *  // 須在 MCButton.setBtn(mc); 前宣告,不然就錯過囉
 * }
 * 
 * MCButton.setBtn(mc);
 * 
 * MCButton.setBtn(mc, {speed:10,                         // 全狀態影格速度預設為 1 , 10便代表一次跳10格的播放速度 0代表直接跳
 * 					 	smooth:{ up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 },   // 各狀態speed時間，如果狀態速度為NaN就取speed速度
 * 						LABEL_UP:"Up",                    // 一般狀態標籤
 * 					 	LABEL_OVER:"Over",                // ROLL_OVER狀態標籤
 * 					 	LABEL_DOWN:"Down",                // MouseDown狀態標籤
 * 					 	LABEL_SELECTED:"Selected",        // Selected狀態標籤
 * 					 	LABEL_DISABLE:"Disable",          // Disable狀態標籤
 * 					 	selected:true,                    // 是否為選取狀態
 * 					 	enable:true,                      // 按鈕是否enable
 * 					 	autoKill:true,                    // 是否當 removeChild 時移除按鈕功能,預設true
 * 						autoRun:true,                     // 是否依照 label 標籤跑影格
 * 					 	setEvent:{onClick:EventHandler}   // 直接設定事件function,用法請參考setEvent方法
 * 					 	});
 * 
 * MC.Smooth({ up:0, over:0, down:0, selected:0, disable:0 });
 * MC.ClearSmooth();
 * MC.core.speed = 2;
 * MC.core.selected = !MC.core.selected;
 * MC.core.autoKill = false;
 * MC.core.autoRun = false;
 * MC.core.isEnable();
 * MC.core.LABEL_UP = "Up";
 * MC.core.LABEL_OVER = "Over";
 * MC.core.LABEL_DOWN = "Down";
 * MC.core.LABEL_SELECTED = "Selected";
 * MC.core.LABEL_DISABLE = "Disable";
 * MC.Select(selected);
 * MC.Enable();
 * MC.Disable();
 * MC.setEvent({onClick:EventHandler,
 * 			 	onDown:EventHandler,
 * 			 	onOver:EventHandler,
 * 			 	onOut:EventHandler,
 * 			 	onUp:EventHandler});
 * 
 * MC.onClick = function(e:Event){};
 * MC.onDown = function(){);
 * MC.onOver = MC.onOut = MC.onUp = EventHandler;
 * 
 * MC.addEventListener(MCButton.OVER, EventHandler);
 * MC.addEventListener(MCButton.OUT, EventHandler);
 * MC.addEventListener(MCButton.DOWN, EventHandler);
 * MC.addEventListener(MCButton.UP, EventHandler);
 * MC.addEventListener(MCButton.CLICK, EventHandler);
 * 
 * function EventHandler(e:Event){
 * 	 // e.target --- MC
 * 	 // e.type   --- 事件
 * }
 * function EventHandler(){
 * 	 // arguments[0].target --- MC
 * 	 // arguments[0].type   --- 事件
 * }
 * function EventHandler(...args){
 * 	 // args[0].target   --- MC
 * 	 // args[0].type     --- 事件
 * }
 * 
 * 
 * 特別限制：
 * 假如 hit 物件是 SimpleButton
 * 那init時滑鼠已在按鈕上時偵測是否MouseOver時將會以外框矩形範圍為感應區
 * 如果要精確感應區 hit 物件請用 MovieClip(透明度可以調0) 或是不使用 hit 感應物件
 */	
	public class MCButton {
		protected static var _instance:MCButton;
		protected var MCHash:Dictionary;
		
		// EVENT 偵聽事件
		public static const CLICK:String = "CLICK";
		public static const OVER:String = "OVER";
		public static const DOWN:String = "DOWN";
		public static const UP:String = "UP";
		public static const OUT:String = "OUT";
		
		public function MCButton() {
			MCHash = new Dictionary();
		}
		
		protected static function getInstance():MCButton {
			if (_instance == null) { _instance = new MCButton(); }
			return _instance;
		}
		
		/////////////////////////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		/////////////////////////////////////////////////////////////////////////////
		
		///////////// SET //////////////////////////////////// target:MovieClip
		/**
		 * Static method for creating a MCButton instance.<br />
		 * 將指定的MovieClip轉換附加自訂按鈕功能<br />
		 * <code>
		 * 	MCButton.setBtn(target, {speed:10,
		 *							smooth:{ up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 },
		 * 							LABEL_UP:"Up",
		 *							LABEL_OVER:"Over",
		 *							LABEL_DOWN:"Down",
		 *							LABEL_SELECTED:"Selected",
		 *							LABEL_DISABLE:"Disable",
		 *							selected:true,
		 *							enable:true,
		 *							autoKill:true,
		 *							setEvent:{onClick:EventHandler}
		 *							});
		 * </code>
		 * @param target 必須是MovieClip,也就是將設為按鈕模式的對象.
		 * @param setObj 包含此按鈕各種屬性設定. For example,{speed:10, smooth:{ up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 }, selected:true, enable:true, autoKill:true, setEvent:{onClick:EventHandler} }
		 */
		public static function setBtn(target:MovieClip, setObj:Object = null):void {
			getInstance().setBtn(target,setObj);
		}
		
		protected function setBtn(target:MovieClip, setObj:Object = null):void {
			setObj == null ? setObj = { } : null;
			setObj.target = target;
			MCHash[target] = new MCButtonData(setObj);
			MCHash[target].addEventListener(MCButtonData.AUTO_KILL, AutoKill);
		}
		
		//////////// kill //////////////////////////////////// target:MovieClip
		/**
		 * Static method for creating a MCButton instance.<br />
		 * 移除指定MovieClip的附加自訂按鈕功能<br />
		 * <code>
		 * 	MCButton.killBtn(target);
		 * </code>
		 * @param target 必須是MovieClip,也是被設為按鈕模式的對象.
		 */
		public static function killBtn(target:MovieClip):void {
			getInstance().killBtn(target);
		}
		
		protected function killBtn(target:MovieClip):void {
			MCHash[target].removeEventListener(MCButtonData.AUTO_KILL, AutoKill);
			MCHash[target] is MCButtonData ? MCHash[target].kill() : null;
			delete MCHash[target];
			
			
		}
		
		//////////// killAll ////////////////////////////////////////////////////////
		/**
		 * Static method for creating a MCButton instance.<br />
		 * 移除所有已附加過的對象的自訂按鈕功能<br />
		 * <code>
		 * 	MCButton.killAll();
		 * </code>
		 */
		public static function killAll():void {
			getInstance().killAll();
		}
		
		protected function killAll():void {
			for (var i:* in MCHash) {
				killBtn(i);
			}
		}
		
		//////////// checkButton /////////////////////////////////// target:MovieClip
		/**
		 * Static method for creating a MCButton instance.<br />
		 * 檢查是否設定過為MCButton<br />
		 * <code>
		 * 	MCButton.checkButton(target);
		 * </code>
		 * @param target 必須是MovieClip,也是被設為按鈕模式的對象.
		 */
		public static function checkButton(target:MovieClip):Boolean {
			return getInstance().checkButton(target);
		}
		
		protected function checkButton(target:MovieClip):Boolean {
			var bo:Boolean = false;
			for (var i:* in MCHash) {
				if (target == i) {
					bo = true;
					break;
				}
			}
			return bo;
		}
		
		/////////////////////////////////////////////////////////////////////////////
		//
		// Private Methods
		//
		/////////////////////////////////////////////////////////////////////////////
		
		private function AutoKill(e:Event):void {
			killBtn(e.target.Target as MovieClip);
		}
	}
	
}





import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import totofish.ui.MCButton;

class MCButtonData extends EventDispatcher {
	public var Target:MovieClip;                         // 目標物
	public static var AUTO_KILL:String = "AUTO_KILL";
	
	// Label 狀態標籤名
	public var LABEL_UP:String = "Up";
	public var LABEL_OVER:String = "Over";
	public var LABEL_DOWN:String = "Down";
	public var LABEL_SELECTED:String = "Selected";    // 非主動
	public var LABEL_DISABLE:String = "Disable";      // 非主動
	
	public var SmoothObj:Object = { up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 };       // 各狀態speed時間
	private var _autoKill:Boolean = true;             // 當 removeChild 時移除按鈕功能
	public var _autoRun:Boolean = true;               // 是否自動依照label跑影格
	public var _speed:uint = 1;                       // 速度倍率 >= 0   0等於直接跳
	public var _selected:Boolean = false;             // 是否選取狀態
	private var isActive:Boolean = true;              // 是否可感應狀態
	private var labels:Object;                        // label紀錄
	private var targetFrame:uint;                     // 目標影隔
	public var HitBtn:*;                              // 感應範圍
	private var FSpeed:uint = _speed;
	
	public function MCButtonData(setObj:Object) {
		Target = setObj.target;
		if(setObj.LABEL_UP is String)       LABEL_UP = setObj.LABEL_UP;
		if(setObj.LABEL_OVER is String)     LABEL_OVER = setObj.LABEL_OVER;
		if(setObj.LABEL_DOWN is String)     LABEL_DOWN = setObj.LABEL_DOWN;
		if(setObj.LABEL_SELECTED is String) LABEL_SELECTED = setObj.LABEL_SELECTED;
		if(setObj.LABEL_DISABLE is String)  LABEL_DISABLE = setObj.LABEL_DISABLE;
		
		if (setObj.speed is uint)            _speed = setObj.speed;
		for (var i:String in setObj.smooth) {
			switch(i) {
				case "up":
					SmoothObj.up = Number(setObj.smooth[i]);
				break;
				case "over":
					SmoothObj.over = Number(setObj.smooth[i]);
				break;
				case "down":
					SmoothObj.down = Number(setObj.smooth[i]);
				break;
				case "selected":
					SmoothObj.selected = Number(setObj.smooth[i]);
				break;
				case "disable":
					SmoothObj.disable = Number(setObj.smooth[i]);
				break;
			}
		}
		if(setObj.selected is Boolean)      _selected = setObj.selected;
		if(setObj.enable is Boolean)        isActive = setObj.enable;
		if(setObj.autoKill is Boolean)      _autoKill = setObj.autoKill;
		if(setObj.autoRun is Boolean)       _autoRun = setObj.autoRun;
		if(setObj.setEvent is Object)       setEvent(setObj.setEvent);
		
		if (_autoKill) Target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		
		if(_autoRun) Target["stop"]();
		Target.tabEnabled = false;
		
		// 附加功能到目標上
		Target["Smooth"] = Smooth;
		Target["ClearSmooth"] = ClearSmooth;
		Target["Disable"] = Disable;
		Target["Enable"] = Enable;
		Target["setEvent"] = setEvent;
		Target["Select"] = Select;
		Target["core"] = this;
		
		// addEventListener
		Target.addEventListener(MCButton.OVER, EventHandler, false, 0, true);
		Target.addEventListener(MCButton.OUT, EventHandler, false, 0, true);
		Target.addEventListener(MCButton.DOWN, EventHandler, false, 0, true);
		Target.addEventListener(MCButton.UP, EventHandler, false, 0, true);
		Target.addEventListener(MCButton.CLICK, EventHandler, false, 0, true);
		Target.addEventListener("init", EventHandler, false, 0, true);
		
		updateLabels();
		
		// 延遲一格1.確保core影格更上層物件載入完畢2.讓外部使用的程式有時間註冊init等事件
		//Target.addEventListener(Event.ENTER_FRAME, init, false, 0, true);
		init();
	}
	
	private function updateLabels():void {
		labels = {};
		var lbls:Array = Target["currentLabels"];
		for (var i:uint=0; i<lbls.length; i++) {
			labels[lbls[i].name] = lbls[i].frame;
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
	
	private function init(e:Event=null):void {
		//if(Target.hasEventListener(Event.ENTER_FRAME)) Target.removeEventListener(Event.ENTER_FRAME, init);
		// 初始化
		HitBtn = Target["hit"];
		if(!HitBtn) HitBtn = Target;
		
		HitBtn is MovieClip ? HitBtn.buttonMode = true : null;

		HitBtn.addEventListener(MouseEvent.ROLL_OVER,MouseHandler,false,0,true);
		HitBtn.addEventListener(MouseEvent.ROLL_OUT,MouseHandler,false,0,true);
		HitBtn.addEventListener(MouseEvent.MOUSE_DOWN, MouseHandler, false, 0, true);
		HitBtn.addEventListener(MouseEvent.MOUSE_UP, MouseHandler, false, 0, true);
		HitBtn.addEventListener(MouseEvent.CLICK,MouseHandler,false,0,true);
		
		Target["selected"] = selected;
		Target["isActive"] = isActive;
		
		if (!isActive) {
			Disable();
			//Target["gotoAndStop"](LABEL_DISABLE);
		}else if (_selected) {
			selected = _selected;
			//Target["gotoAndStop"](LABEL_SELECTED);
		}else{
			if(HitBtn is SimpleButton){
				if (HitBtn.hitTestState.hitTestPoint(HitBtn.mouseX, HitBtn.mouseY, false)) {
					Target.dispatchEvent(new Event(MCButton.OVER));
					JumpLabel(LABEL_OVER);
				}
			}else{
				if(Target.stage){
					if (HitBtn.hitTestPoint(Target.stage.mouseX, Target.stage.mouseY, true)) {
						Target.dispatchEvent(new Event(MCButton.OVER));
						JumpLabel(LABEL_OVER);
					}
				}
			}
		}
		
		
		// init
		Target.dispatchEvent(new Event("init"));
	}
	
	private function onRemove(e:Event):void {
		Target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		dispatchEvent(new Event(MCButtonData.AUTO_KILL));
	}
	
	private function MouseHandler(e:MouseEvent):void {
		if(isActive){
			switch(e.type){
				case MouseEvent.ROLL_OVER:
					Target.dispatchEvent(new Event(MCButton.OVER));
					JumpLabel(LABEL_OVER);
				break;
				case MouseEvent.ROLL_OUT:
					Target.dispatchEvent(new Event(MCButton.OUT));
					JumpLabel(LABEL_UP);
				break;
				case MouseEvent.MOUSE_DOWN:
					Target.dispatchEvent(new Event(MCButton.DOWN));
					JumpLabel(LABEL_DOWN);
				break;
				case MouseEvent.MOUSE_UP:
					Target.dispatchEvent(new Event(MCButton.UP));
					JumpLabel(LABEL_OVER);
				break;
				case MouseEvent.CLICK:
					Target.dispatchEvent(new Event(MCButton.CLICK));
			}
		}
	}
	
	private function EventHandler(e:Event):void {
		switch(e.type) {
			case "init":
				call("init","init",e);
			break;
			case MCButton.OVER:
				call("onOver", e.type, e);
			break;
			case MCButton.OUT:
				call("onOut", e.type, e);
			break;
			case MCButton.DOWN:
				call("onDown", e.type, e);
			break;
			case MCButton.UP:
				call("onUp", e.type, e);
			break;
			case MCButton.CLICK:
				call("onClick", e.type, e);
		}
	}
	
	private function call(eventStr:String, type:String, e:Event):void {
		if (Target.hasOwnProperty(eventStr)) {
			if(Target[eventStr] is Function)Target[eventStr].apply(null, [ e ]);
		}
	}
	
	private function JumpLabel(label:String):void {
		if (_selected) label = LABEL_SELECTED;
		if (!isActive) label = LABEL_DISABLE;
		
		switch(label) {
			case LABEL_UP:
				FSpeed = isNaN(SmoothObj.up) ? _speed : SmoothObj.up;
			break;
			case LABEL_OVER:
				FSpeed = isNaN(SmoothObj.over) ? _speed : SmoothObj.over;
			break;
			case LABEL_DOWN:
				FSpeed = isNaN(SmoothObj.down) ? _speed : SmoothObj.down;
			break;
			case LABEL_SELECTED:
				FSpeed = isNaN(SmoothObj.selected) ? _speed : SmoothObj.selected;
			break;
			case LABEL_DISABLE:
				FSpeed = isNaN(SmoothObj.disable) ? _speed : SmoothObj.disable;
		}
		
		if(_autoRun){
			//FSpeed = int(FSpeed);
			var frames:int = getFrameNumber(label);
			switch(FSpeed) {
				case 0:
					if (frames > 0) Target["gotoAndStop"](label);
				break;
				default:
					if (frames > 0) {
						targetFrame = frames;
						Target.addEventListener(Event.ENTER_FRAME, onFrame);
					}
			}
		}
	}
	
	private function onFrame(e:Event):void {
		var cf:uint = Target["currentFrame"];
		var f:int = Math.abs(cf - targetFrame) <= FSpeed ? targetFrame : cf + (cf > targetFrame ? -1 : 1) * FSpeed;
		Target["gotoAndStop"](f);
		if(f == targetFrame) Target.removeEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	
	/////////////////////////////////////////////////////////////////////////////////
	//
	// public setter getter
	//
	/////////////////////////////////////////////////////////////////////////////////
	
	public function set selected(b:Boolean):void {
		_selected = b;
		if (isActive) {
			if (_selected) {
				JumpLabel(LABEL_SELECTED);
			}else {
				JumpLabel(LABEL_UP);
			}
		}
		Target["selected"] = b;
	}
	
	public function get selected():Boolean{
		return _selected;
	}
	
	public function set autoKill(b:Boolean):void {
		_autoKill = b;
		if (_autoKill) Target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		else Target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
	}
	
	public function get autoKill():Boolean {
		return _autoKill;
	}
	
	public function set autoRun(b:Boolean):void {
		_autoRun = b;
	}
	
	public function get autoRun():Boolean {
		return _autoRun;
	}
	
	public function set speed(b:uint):void {
		_speed = b;
	}
	
	public function get speed():uint {
		return _speed;
	}
	
	/////////////////////////////////////////////////////////////////////////////////
	//
	// public function
	//
	/////////////////////////////////////////////////////////////////////////////////
	
	// { up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 }
	public function Smooth(obj:Object):void {
		for (var i:String in obj) {
			switch(i) {
				case "up":
					SmoothObj.up = Number(obj[i]);
				break;
				case "over":
					SmoothObj.over = Number(obj[i]);
				break;
				case "down":
					SmoothObj.down = Number(obj[i]);
				break;
				case "selected":
					SmoothObj.selected = Number(obj[i]);
				break;
				case "disable":
					SmoothObj.disable = Number(obj[i]);
				break;
			}
		}
	}
	public function ClearSmooth():void {
		SmoothObj.up = NaN;
		SmoothObj.over = NaN;
		SmoothObj.down = NaN;
		SmoothObj.selected = NaN;
		SmoothObj.disable = 0;
	}
		
	public function Select(bo:Boolean):void {
		selected = bo;
	}
	
	public function Disable():void {
		isActive = false;
		HitBtn.mouseEnabled = false;
		Target.mouseChildren = false;
		Target.mouseEnabled = false;
		HitBtn is MovieClip ? HitBtn.buttonMode = false : null;
		Target["isActive"] = isActive;
		JumpLabel(LABEL_DISABLE);
	}
	public function Enable():void {
		isActive = true;
		HitBtn.mouseEnabled = true;
		Target.mouseChildren = true;
		Target.mouseEnabled = true;
		HitBtn is MovieClip ? HitBtn.buttonMode = true : null;
		Target["isActive"] = isActive;
		if (_selected) JumpLabel(LABEL_SELECTED);
		else JumpLabel(LABEL_UP);
	}
	public function isEnable():Boolean{
		return isActive;
	}
	public function setEvent(EventObj:Object):void {
		for(var i:String in EventObj){
			Target[i] = EventObj[i];
		}
	}
	
	public function kill():void {
		Target.removeEventListener(Event.ENTER_FRAME, onFrame);
		
		HitBtn is MovieClip ? HitBtn.buttonMode = false : null;
		
		Target["Disable"] = null;
		Target["Enable"] = null;
		Target["setEvent"] = null;
		Target["Select"] = null;
		Target["core"] = null;
		
		Target["selected"] = null;
		Target["isActive"] = null;
		
		Target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		
		Target.removeEventListener(MCButton.OVER, EventHandler);
		Target.removeEventListener(MCButton.OUT, EventHandler);
		Target.removeEventListener(MCButton.DOWN, EventHandler);
		Target.removeEventListener(MCButton.UP, EventHandler);
		Target.removeEventListener(MCButton.CLICK, EventHandler);
		Target.removeEventListener("init", EventHandler);
		
		HitBtn.removeEventListener(MouseEvent.ROLL_OVER,MouseHandler);
		HitBtn.removeEventListener(MouseEvent.ROLL_OUT,MouseHandler);
		HitBtn.removeEventListener(MouseEvent.MOUSE_DOWN, MouseHandler);
		HitBtn.removeEventListener(MouseEvent.MOUSE_UP, MouseHandler);
		HitBtn.removeEventListener(MouseEvent.CLICK,MouseHandler);
	}
}