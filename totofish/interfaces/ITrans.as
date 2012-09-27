/**
 * @author totofish
 * @date 2010/5/27
 * @email eaneanean@hotmail.com
 */

package totofish.interfaces {
	import flash.events.IEventDispatcher;
	
	[Event(name = "transitionIn", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionOut", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionInComplete", type = "totofish.ui.ParentTransMC")]
	[Event(name = "transitionOutComplete", type = "totofish.ui.ParentTransMC")]
	
	public interface ITrans extends IEventDispatcher{
		
		function transitionIn():void;
		function transitionOut():void;
		function transitionInComplete():void;
		function transitionOutComplete():void;
	}
}