/**
 * @author totofish
 * @date 2010/9/16
 * @email eaneanean@hotmail.com
 */

package totofish.ui {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ParentMCButton extends Sprite {
		private var Target:MovieClip;    // 目標物
		
		[Inspectable(name="Label Normal", defaultValue="Up")]
		public var LABEL_UP:String = "Up";
		
		[Inspectable(name="Label Over", defaultValue="Over")]
		public var LABEL_OVER:String = "Over";
		
		[Inspectable(name="Label Down", defaultValue="Down")]
		public var LABEL_DOWN:String = "Down";
		
		[Inspectable(name="Label Selected", defaultValue="Selected")]
		public var LABEL_SELECTED:String = "Selected";  // 非主動
		
		[Inspectable(name="Label Disable", defaultValue="Disable")]
		public var LABEL_DISABLE:String = "Disable";    // 非主動
		
		[Inspectable(name="smooth", defaultValue="up:NaN, over:NaN, down:NaN, selected:NaN, disable:0")]
		public var SmoothObj:Object = { up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 };       // 狀態平滑時間
		
		[Inspectable(name="speed", defaultValue=1)]
		public var speed:uint = 1;
		
		[Inspectable(defaultValue=false)]
		public var selected:Boolean = false;
		
		[Inspectable(defaultValue=true)]
		public var enable:Boolean = true;
		
		[Inspectable(defaultValue=true)]
		public var autoKill:Boolean = true;
		
		private var _autoRun:Boolean = false;

		public function ParentMCButton() {
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			visible = false;
			mouseChildren = false;
			mouseEnabled = false;
			
			Target = parent as MovieClip;
			
									  
			// 組件變數會在實體化後才改變，所以要延遲從新指定變數，或是[Inspectable 標籤使用在setter的方法上...
			addEventListener(Event.ENTER_FRAME, init, false, 0, true);
			//addEventListener(Event.FRAME_CONSTRUCTED, init, false, 0, true); // 發佈為player 9似乎不支援
		}
		
		private function init(e:Event = null):void {
			if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, init);
			//if (hasEventListener(Event.FRAME_CONSTRUCTED)) removeEventListener(Event.FRAME_CONSTRUCTED, init);
			
			if (!MCButton.checkButton(Target)) {
				MCButton.setBtn(Target, { speed:speed,
									  smooth         :SmoothObj,
									  LABEL_UP       :LABEL_UP,
									  LABEL_OVER     :LABEL_OVER,
									  LABEL_DOWN     :LABEL_DOWN,
									  LABEL_SELECTED :LABEL_SELECTED,
									  LABEL_DISABLE  :LABEL_DISABLE,
									  selected       :selected,
									  enable         :enable,
									  autoKill       :autoKill,
									  autoRun        :_autoRun	  	  } );
			}else {
				Target.core.speed = speed;
				Target.Smooth(SmoothObj);
				Target.core.LABEL_UP = LABEL_UP;
				Target.core.LABEL_OVER = LABEL_OVER;
				Target.core.LABEL_DOWN = LABEL_DOWN;
				Target.core.LABEL_SELECTED = LABEL_SELECTED;
				Target.core.LABEL_DISABLE = LABEL_DISABLE;
				Target.core.autoKill = autoKill;
				//Target.core.autoRun = _autoRun;
				if(selected) Target.Select(selected);
				if (!enable) Target.Disable();
			}
		}
		
		// autoRun 需要在設定按鈕時就設置正確，所以當設定好此屬性才按鈕化
		[Inspectable(defaultValue=false)]
		public function set autoRun(bo:Boolean):void {
			_autoRun = bo;
			MCButton.setBtn(Target, { speed:speed,
									  smooth         :SmoothObj,
									  LABEL_UP       :LABEL_UP,
									  LABEL_OVER     :LABEL_OVER,
									  LABEL_DOWN     :LABEL_DOWN,
									  LABEL_SELECTED :LABEL_SELECTED,
									  LABEL_DISABLE  :LABEL_DISABLE,
									  selected       :selected,
									  enable         :enable,
									  autoKill       :autoKill,
									  autoRun        :_autoRun	  	  } );
		}
	}
}