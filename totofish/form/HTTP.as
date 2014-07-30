/**
 * @author totofish
 * @date 2010/4/26 - 2012/3/29
 * @email eaneanean@hotmail.com
 */

package totofish.form {
	
	import flash.events.*;
	import flash.net.*;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	//import com.adobe.serialization.json.JSON;
	import totofish.events.HTTPEvent;
	
	public class HTTP {
		
		public function HTTP(){
			throw new Error("HTTP class is static container only");
		}
		
		/////////////////////////////////////////////////
		//
		// send(成功失敗function, 網址, 傳送的資料(object), method)
		//
		/////////////////////////////////////////////////
		public static function send(Fun:Function, url:String, obj:Object, method:String = "POST"):void {
			var Dloader:URLLoader = new URLLoader();
			Dloader.addEventListener(Event.COMPLETE, completeHandler);
			Dloader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
			for(var i in obj){
				variables[i] = obj[i];
			}
            request.data = variables;
			if(method=="POST")request.method = URLRequestMethod.POST;
			else request.method = URLRequestMethod.GET;
				
			Dloader.load(request);
			function completeHandler(event:Event) {
				var loader:URLLoader = URLLoader(event.target);
				try{
					var Data:Object = JSON.parse(loader.data.toString());
				}catch (e) {
					//trace("非json格式");
				}
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, true, obj, loader.data, Data)]);
			}
			function ioErrorHandler(event:IOErrorEvent) {
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, false, obj, null, null)]);
			}
		}
		
		//////////////////////////////////////////////////
		//
		// String傳送(或XML格式字串)  sendString(成功失敗function, 網址, 傳送的資料(xml or string))
		//
		//////////////////////////////////////////////////
		public static function sendString(Fun:Function, url:String, str:String):void {
			var STRloader:URLLoader = new URLLoader();
			STRloader.addEventListener(Event.COMPLETE, completeHandler);
			STRloader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			var STRrequest:URLRequest = new URLRequest(url);
            STRrequest.data = str;
			STRrequest.method = URLRequestMethod.POST;
			STRloader.load(STRrequest);
			function completeHandler(event:Event) {
				var STRloader:URLLoader = URLLoader(event.target);
				try{
					var Data:Object = JSON.parse(STRloader.data.toString());
				}catch (e) {
					//trace("非json格式");
				}
				//if (Fun != null) Fun.apply(null, [ { success:true, json:Data, data:STRloader.data, sendData:str } ]);
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, true, str, STRloader.data, Data)]);
			}
			function ioErrorHandler(event:IOErrorEvent) {
				//if (Fun != null) Fun.apply(null, [ { success:false, json:null, data:null, sendData:str } ]);
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, false, str, null, null)]);
			}
		}
		
		//////////////////////////////////////////////////
		//
		// ByteArray傳送(編碼由外部處理)   sendStream(成功失敗function, ByteArray, 網址, GET傳送的資料(object)
		//
		//////////////////////////////////////////////////
		public static function sendStream(Fun:Function, bit:ByteArray, url:String, obj:Object):void {
			var Streamloader:URLLoader = new URLLoader();
			Streamloader.addEventListener(IOErrorEvent.IO_ERROR, StreamERRORHandler);
			Streamloader.addEventListener(Event.COMPLETE, StreamCompleteHandler);
			var getStr:String = "?r="+Math.random();
			for(var i in obj){
				getStr += "&"+encodeURIComponent(i)+"="+encodeURIComponent(obj[i]);
			}
			
			var Streamrequest:URLRequest = new URLRequest(url+getStr);
			Streamrequest.method = URLRequestMethod.POST;             // POST傳送
			Streamrequest.contentType = "application/octet-stream";   // MIME 類型
			Streamrequest.data = bit;                                 // ByteArray
			Streamloader.load(Streamrequest);
			
			function StreamCompleteHandler(event:Event){
				var loader:URLLoader = URLLoader(event.target);
				try{
					var Data:Object = JSON.parse(loader.data.toString());
				}catch (e) {
					//trace("非json格式");
				}
				//if (Fun != null) Fun.apply(null, [ { success:true, json:Data, data:loader.data, sendData:obj } ]);
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, true, obj, loader.data, Data)]);
			}
			function StreamERRORHandler(event:IOErrorEvent){
				//if (Fun != null) Fun.apply(null, [ { success:false, json:null, data:null, sendData:obj } ]);
				if (Fun != null) Fun.apply(null, [new HTTPEvent(HTTPEvent.EventType, false, obj, null, null)]);
			}
		}
	}
}