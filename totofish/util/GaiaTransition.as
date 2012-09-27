/**
 * @author totofish
 * @date 2010/5/25
 * @email eaneanean@hotmail.com
 */

/******************************************
 搭配 com.gaiaframework.templates.AbstractBase 使用
 *********************************************/
 
package totofish.util {
	import com.gaiaframework.events.PageEvent;
	import flash.display.MovieClip;
	
	public class GaiaTransition	{
		
		public function GaiaTransition() {
			throw new Error("GaiaTransition class is static container only");
		}
		
		// mc, {In:callfun, InComplete:callfun, Out:callfun, OutComplete:callfun}
		public static function setEvent(target:MovieClip, eventObj:Object):void {
			for(var i in eventObj){
				switch(i){
				case "In":
					target.addEventListener(PageEvent.TRANSITION_IN, eventObj[i], false, 0, true);
				break;
				case "InComplete":
					target.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, eventObj[i], false, 0, true);
				break;
				case "Out":
					target.addEventListener(PageEvent.TRANSITION_OUT, eventObj[i], false, 0, true);
				break;
				case "OutComplete":
					target.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, eventObj[i], false, 0, true);
				}
			}
		}
	}
}