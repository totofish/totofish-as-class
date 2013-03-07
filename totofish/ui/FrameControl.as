/**
 * @author totofish
 * @date 2011/5/17
 * @email eaneanean@hotmail.com
 */

package totofish.ui {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

/**
 * 用法說明：
 * 
 * import flash.display.MovieClip;
 * import totofish.ui.FrameControl;
 * 
 * 
 * FrameControl.goFrame(MC, 15, EventHandler, ["a",true]);
 * function EventHandler(a,b){
 * 		trace(a, b);
 * }
 * 
 * // 到某一指定影格(後2參數非必要)
 * FrameControl.goFrame(MC, 15);
 * // 播放到最後影格(後2參數非必要)
 * FrameControl.goLast(MC, EventHandler, [1, 2]);
 * // 播放到第一影格(後2參數非必要)
 * FrameControl.goFront(MC, EventHandler, [1, 2]);
 * 
 */

	public class FrameControl extends Sprite {
		
		protected static var _instance:FrameControl;
		protected var targetHash:Dictionary;
		
		public function FrameControl() {
			targetHash = new Dictionary();
		}
		
		protected static function getInstance():FrameControl {
			if (_instance == null) { _instance = new FrameControl(); }
			return _instance;
		}
		
		/////////////////////////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		/////////////////////////////////////////////////////////////////////////////
		
		///////////// goFrame ///////////////////////////////////////////////////////
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 指定MovieClip跑到某一影格完成後回摳function<br />
		 * <code>
		 * 	FrameControl.goFrame(target, "in", EventHandler, [10,true...]);
		 * </code>
		 * @param _target 必須是MovieClip對象.
		 * @param _frame 為unit或string, 代表要前往的影格.
		 * @param _function 前往至該影格後回call的function.
		 * @param _params 回call同時帶回的參數.
		 */
		public static function goFrame(_target:MovieClip, _frame:*, _function:Function = null, _params:Array = null):void {
			getInstance().goFrame(_target, _frame, _function, _params);
		}
		
		public function goFrame(_target:MovieClip, _frame:*, _function:Function, _params:Array):void {
			if (uint(_frame)) _frame < 0 ? _frame = 0 : _frame > _target.totalFrames ? _frame = _target.totalFrames : null;
			
			targetHash[_target] = new TargetData(_target, _frame, _function, _params);
			if (targetHash[_target].targetFrame <= 0) {
				delete targetHash[_target];
			}else{
				if (hasEventListener(Event.ENTER_FRAME) == false) { this.addEventListener(Event.ENTER_FRAME, onFrame); }
			}
		}
		
		///////////// goLast ///////////////////////////////////////////////////////
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 指定MovieClip播放到最後一格然後回摳function<br />
		 * <code>
		 * 	FrameControl.goLast(target, EventHandler, [10,true...]);
		 * </code>
		 * @param _target 必須是MovieClip對象.
		 * @param _function 前往最後影格後回call的function.
		 * @param _params 回call同時帶回的參數.
		 */
		static public function goLast(_target:MovieClip, _function:Function = null, _params:Array = null):void {
			getInstance().goFrame(_target, _target.totalFrames, _function, _params);
		}
		
		///////////// goFront ///////////////////////////////////////////////////////
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 指定MovieClip播放到第 1 格然後回摳function<br />
		 * <code>
		 * 	FrameControl.goFront(target, EventHandler, [10,true...]);
		 * </code>
		 * @param _target 必須是MovieClip對象.
		 * @param _function 前往最後影格後回call的function.
		 * @param _params 回call同時帶回的參數.
		 */
		static public function goFront(_target:MovieClip, _function:Function = null, _params:Array = null):void {
			getInstance().goFrame(_target, 1, _function, _params);
		}
		
		//////////// checkTarget /////////////////////////////////// target:MovieClip
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 檢查是否有附加前往影格功能<br />
		 * <code>
		 * 	FrameControl.checkTarget(target);
		 * </code>
		 * @param _target 必須是MovieClip.
		 */
		public static function checkTarget(_target:MovieClip):Boolean {
			return getInstance().checkTarget(_target);
		}
		
		protected function checkTarget(_target:MovieClip):Boolean {
			return targetHash[_target] == null ? false : true;
		}
		
		//////////// killTarget //////////////////////////////////// target:MovieClip
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 移除指定MovieClip的附加前往影格功能<br />
		 * <code>
		 * 	FrameControl.killTarget(target);
		 * </code>
		 * @param _target 必須是MovieClip.
		 */
		public static function killTarget(_target:MovieClip):void {
			getInstance().killTarget(_target);
		}
		
		protected function killTarget(_target:MovieClip):void {
			delete targetHash[_target];
		}
		
		//////////// killAll ////////////////////////////////////////////////////////
		/**
		 * Static method for creating a FrameControl instance.<br />
		 * 移除所有已附加過的對象的前往影格功能<br />
		 * <code>
		 * 	FrameControl.killAll();
		 * </code>
		 */
		public static function killAll():void {
			getInstance().killAll();
		}
		
		protected function killAll():void {
			for (var i:* in targetHash) {
				killTarget(i);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////
		//
		// Protected Methods
		//
		/////////////////////////////////////////////////////////////////////////////
		
		protected function onFrame(p_event:Event):void {
			var hasRun:Boolean = false;
			for (var t:Object in targetHash) {
				hasRun = true;
				var obj:TargetData = targetHash[t] as TargetData;
				if (t.currentFrame == obj.targetFrame) {
					if(obj.callBak != null){
						if (obj.params != null) {
							(obj.callBak as Function).apply(null, obj.params);
						} else {
							obj.callBak();
						}
					}
					delete targetHash[t];
				}else if(t.currentFrame < obj.targetFrame){
					t.nextFrame();
				}else {
					t.prevFrame();
				}
			}
			if (hasRun == false) { removeEventListener(Event.ENTER_FRAME, onFrame); }
		}
		
	}
}











import flash.display.MovieClip;

class TargetData  {
	public var target:MovieClip;
	public var targetFrame:uint;
	public var params:Array;
	public var callBak:Function;
	private var labels:Object;
	
	public function TargetData(_target:MovieClip, _frame:*, _function:Function, _params:Array) {
		target = _target;
		updateLabels(_target);
		callBak = _function;
		params = _params;
		targetFrame = getFrameNumber(_frame);
	}
	private function updateLabels(_target:MovieClip):void {
		var lbls:Array = _target.currentLabels;
		labels = {};
		for (var i:uint=0; i<lbls.length; i++) {
			labels[lbls[i].name] = lbls[i].frame;
		}
	}
	public function getFrameNumber(_frame:*):uint {
		var frameNum:uint = uint(_frame);
		if (frameNum) { return frameNum; }
		var label:String = String(_frame);
		if (label == null) { return 0; }
		frameNum = labels[label];
		return frameNum;
	}
}