/**
 * @author totofish
 * @date 2010/5/27 - 2010/7/1
 * @email eaneanean@hotmail.com
 */

/******************************************

用法說明：

將繼承本class的MovieClip拖到其他MovieClip內使用
讓他動態附加此功能
transitionIn : 進場事件
transitionInComplete : 進場完畢事件
transitionOut : 退場事件
transitionOutComplete : 退場完畢事件

涵式:
MC.transitionIn();
MC.transitionOut();
MC.transitionInComplete();
MC.transitionOutComplete();

可搭配totofish.util.ParentTransition快速註冊事件
ParentTransition.setEvent(mc, {In:callfun, 
							   InComplete:callfun, 
							   Out:callfun, 
							   OutComplete:callfun,
							   other1:callfun2,
							   other2:callfun2});

*********************************************/

package totofish.ui {
	import flash.display.MovieClip;
	import totofish.interfaces.ITrans;
	import flash.events.Event;
	
	[Event(name = "transitionIn", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionOut", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionInComplete", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionOutComplete", type = "totofish.ui.ParentTransMC")]
	
	public class ParentTransMC extends MovieClip implements ITrans {
		public static const TRANSITION_OUT:String = "transitionOut";
		public static const TRANSITION_IN:String = "transitionIn";
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		
		private var Target:MovieClip;                                                                // 目標物
		
		
		public function ParentTransMC() {
			super();
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			visible = false;
			mouseChildren = false;
			mouseEnabled = false;
			
			Target = parent as MovieClip;
			Target.transitionIn = transitionIn;
			Target.transitionOut = transitionOut;
			Target.transitionInComplete = transitionInComplete;
			Target.transitionOutComplete = transitionOutComplete;
			Target.core = this;
			
			// 基本上下面這行沒作用
			if(Target["init"])Target["init"].apply(null,[{target:Target,currentTarget:Target,type:"init"}]);
		}
		public function transitionIn():void	{
			Target.dispatchEvent(new Event(ParentTransMC.TRANSITION_IN));
		}
		public function transitionOut():void {
			Target.dispatchEvent(new Event(ParentTransMC.TRANSITION_OUT));
		}
		public function transitionInComplete():void	{
			Target.dispatchEvent(new Event(ParentTransMC.TRANSITION_IN_COMPLETE));
		}
		public function transitionOutComplete():void {
			Target.dispatchEvent(new Event(ParentTransMC.TRANSITION_OUT_COMPLETE));
		}
	}
}