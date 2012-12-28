package totofish.events {
	import flash.events.Event;
	
	public class HTTPEvent extends Event {
		public static const EventType:String = "HTTPEvent";
		public var success:Boolean;
		public var data:*;
		public var json:Object;
		public var sendData:Object;
		
		public function HTTPEvent(type:String, $success:Boolean, $sendData:Object, $data:* = null, $json:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			success = $success;
			data = $data;
			json = $json;
			sendData = $sendData;
			super(type,bubbles,cancelable);
		}
		
		public override function toString():String { 
			return formatToString("HTTPEvent", "type", "bubbles", "cancelable", "eventPhase", "data"); 
		}
		
		public override function clone():Event {
              return new HTTPEvent(type, success, sendData, data, json, bubbles, cancelable);
        }
	}
}