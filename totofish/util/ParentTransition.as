/**
 * @author totofish
 * @date 2010/5/27
 * @email eaneanean@hotmail.com
 */

/******************************************

協助 ParentTransMC 快速註冊事件

用法說明：
ParentTransition.setEvent(mc, {In:callfun, 
							   InComplete:callfun, 
							   Out:callfun, 
							   OutComplete:callfun,
							   other1:callfun2,
							   other2:callfun2});

*********************************************/
 
package totofish.util {
	import flash.display.MovieClip;
	import totofish.ui.ParentTransMC;
	import flash.events.Event;
	
	public class ParentTransition	{
		
		public function ParentTransition() {
			throw new Error("ParentTransition class is static container only");
		}
		
		// mc, {In:callfun, InComplete:callfun, Out:callfun, OutComplete:callfun}
		public static function setEvent(target:MovieClip, eventObj:Object):void {
			for(var i in eventObj){
				CreatEvent(target, i, eventObj[i]);
			}
		}
		
		private static function CreatEvent(target:MovieClip, event:String, fun:Function):void {
			target.addEventListener(event, fun, false, 0, true);
			target[event] = function() {
				MovieClip(target).dispatchEvent(new Event(event));
			}
		}
	}
}