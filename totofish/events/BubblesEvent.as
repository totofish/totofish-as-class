package totofish.events {
	import flash.events.Event;
	
	public class BubblesEvent extends Event	{
		public var data:Object;
		
		public function BubblesEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			this.data = data;
			super(type,bubbles,cancelable);
		}
		
		public override function toString():String { 
			return formatToString("BubblesEvent", "type", "bubbles", "cancelable", "eventPhase", "data"); 
		}
		
		public override function clone():Event {
              return new BubblesEvent(type, data, bubbles, cancelable);
        }
		
	}
}