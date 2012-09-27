/**
 * @author totofish
 * @date 2010/4/26 - 2010/7/21
 * @email eaneanean@hotmail.com
 */

package totofish.form {
	
	import flash.events.*;
	import flash.net.*;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;
	
	public class HTTP {
		protected static var _instance:HTTP;
		
		public function HTTP(){
		
		}
		
		protected static function getInstance():HTTP {
			if (_instance == null) { _instance = new HTTP(); }
			return _instance;
		}
		
		/////////////////////////////////////////////////
		//
		// send(成功失敗function, 網址, 傳送的資料(object), method)
		//
		/////////////////////////////////////////////////
		public static function send(Fun:Function, url:String, obj:Object, method:String="POST"):void {
			getInstance().send(Fun, url, obj, method);
		}
		public function send(Fun:Function, url:String, obj:Object, method:String = "POST"):void {
			var loader:URLLoader = new URLLoader();
			var CB:CallBack = new CallBack(Fun, obj);
			loader.addEventListener(Event.COMPLETE, CB.completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, CB.ioErrorHandler);
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
			for(var i in obj){
				variables[i] = obj[i];
			}
            request.data = variables;
			if(method=="POST")request.method = URLRequestMethod.POST;
			else request.method = URLRequestMethod.GET;
				
			loader.load(request);
		}
		
		//////////////////////////////////////////////
		//
		// JPG圖檔傳送   sendJpg(成功失敗function, 圖素, 網址, GET傳送的資料(object)
		//
		//////////////////////////////////////////////
		public static function sendJpg(Fun:Function, bmp:BitmapData, url:String, obj:Object):void {
			getInstance().sendJpg(Fun, bmp, url, obj);
		}
		public function sendJpg(Fun:Function, bmp:BitmapData, url:String, obj:Object):void {
			var byteArray:ByteArray = new JPGEncoder(obj.quality?obj.quality:100).encode(bmp);
			var Streamloader:URLLoader = new URLLoader();
			Streamloader.addEventListener(IOErrorEvent.IO_ERROR, StreamERRORHandler);
			Streamloader.addEventListener(Event.COMPLETE, StreamCompleteHandler);
			var getStr:String = "?file=jpeg";
			for(var i in obj){
				getStr += "&"+encodeURIComponent(i)+"="+encodeURIComponent(obj[i]);
			}
			getStr += "&r="+Math.random();
			var Streamrequest:URLRequest = new URLRequest(url+getStr);
			Streamrequest.method = URLRequestMethod.POST;             // POST傳送
			Streamrequest.contentType = "application/octet-stream";   // MIME 類型
			Streamrequest.data = byteArray;                           // ByteArray形式ZIP資料
			Streamloader.load(Streamrequest);
			
			function StreamCompleteHandler(event:Event){
				var loader:URLLoader = URLLoader(event.target);
				try{
					var Data:Object = JSON.decode(loader.data.toString());
				}catch (e) {
					trace("非json格式");
				}
				if(Fun != null) Fun.apply(null,[{success:true, json:Data, data:loader.data, sendData:obj}]);
			}
			function StreamERRORHandler(event:IOErrorEvent){
				if(Fun != null) Fun.apply(null,[{success:false, json:null, data:null, sendData:obj}]);
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
					var Data:Object = JSON.decode(STRloader.data.toString());
				}catch (e) {
					trace("非json格式");
				}
				if(Fun != null) Fun.apply(null,[{success:true, json:Data, data:STRloader.data, sendData:str}]);
			}
			function ioErrorHandler(event:IOErrorEvent) {
				if(Fun != null) Fun.apply(null,[{success:false, json:null, data:null, sendData:str}]);
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
					var Data:Object = JSON.decode(loader.data.toString());
				}catch (e) {
					trace("非json格式");
				}
				if(Fun != null) Fun.apply(null,[{success:true, json:Data, data:loader.data, sendData:obj}]);
			}
			function StreamERRORHandler(event:IOErrorEvent){
				if(Fun != null) Fun.apply(null,[{success:false, json:null, data:null, sendData:obj}]);
			}
		}
	}
}










import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import com.adobe.serialization.json.JSON;

class CallBack {
	public var DATA:Object;
	private var _Fun:Function;
	
	public function CallBack(Fun:Function, data:Object) {
		DATA = data;
		_Fun = Fun;
	}
	
	public function completeHandler(event:Event):void {
		var loader:URLLoader = URLLoader(event.target);
		try{
			var Data:Object = JSON.decode(loader.data.toString());
		}catch (e) {
			trace("非json格式");
		}
		if(_Fun != null) _Fun.apply(null,[{success:true, json:Data, data:loader.data, sendData:DATA}]);
	}
	
	public function ioErrorHandler(event:IOErrorEvent):void {
		if(_Fun != null) _Fun.apply(null,[{success:false, json:null, data:null, sendData:DATA}]);
	}
	
	public function progressHandler(event:ProgressEvent):void {
		// 暫不提供此功能哈哈
	}
}