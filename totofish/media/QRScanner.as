/**
 * @author totofish
 * @date 2013/9/27
 * @email eaneanean@hotmail.com
 */

package totofish.media {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.*;
	import flash.events.EventDispatcher;
	import totofish.events.BubblesEvent;
	
/**
 * 用法說明：
 * 
 * QRScanner.setTarget(stage);
 * QRScanner.getInstance().addEventListener(QRScanner.BEEP, qrHandler, false, 0, true);
 * 
 * // 或
 * QRScanner.setTarget(stage).addEventListener(QRScanner.BEEP, qrHandler, false, 0, true);
 * 
 * private function qrHandler(e:BubblesEvent):void {
 * 		trace(e.data.QRCode);
 * }
 * 
 * // 取得註冊對象
 * QRScanner.getTarget();
 * 
 * // 移除監控對象
 * QRScanner.getTarget().removeEventListener(QRScanner.BEEP, qrHandler);
 * QRScanner.delTarget();
 * 
 */	
	
	public class QRScanner extends EventDispatcher {
		protected static var _instance:QRScanner;
		protected var _target:DisplayObject;
		private var QRStr:String = "";
		// EVENT 偵聽事件
		public static const BEEP:String = "CLICK";
		
		public function QRScanner() {
			
		}
		
		private function KeyDown(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case 13:
					dispatchEvent(new BubblesEvent(QRScanner.BEEP, {QRCode:QRStr} ));
					QRStr = "";
					break;
				case 16:
					// 怪異字元
					break;
				default:
					QRStr += String.fromCharCode(event.charCode);
					//trace(QRStr + "   :    " + event.charCode + "    :   " + event.keyCode);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////
		//
		// Public Methods
		//
		/////////////////////////////////////////////////////////////////////////////
		
		public static function getInstance():QRScanner {
			if (_instance == null) { _instance = new QRScanner(); }
			return _instance;
		}
		
		/**
		 * Static method for creating a QRScanner instance.<br />
		 * 註冊接收鍵盤事件的對象，同時也返回QRScanner對象<br />
		 * <code>
		 * 	QRScanner.setTarget(stage);
		 * </code>
		 * @param target 必須是DisplayObject,用來註冊接收鍵盤事件的對象，同時也返回QRScanner對象.
		 */
		public static function setTarget(target:DisplayObject):EventDispatcher {
			return getInstance().setTarget(target);
		}
		
		protected function setTarget(target:DisplayObject):EventDispatcher {
			_target = target;
			_target.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown, false, 0, true);
			return _instance;
		}
		
		/**
		 * Static method for creating a QRScanner instance.<br />
		 * 取得註冊接收鍵盤事件的對象<br />
		 * <code>
		 * 	QRScanner.getTarget();
		 * </code>
		 */
		public static function getTarget():DisplayObject {
			return getInstance().getTarget();
		}
		
		protected function getTarget():DisplayObject {
			return _target;
		}
		
		/**
		 * Static method for creating a QRScanner instance.<br />
		 * 刪除註冊接收鍵盤事件的對象<br />
		 * <code>
		 * 	QRScanner.delTarget();
		 * </code>
		 */
		public static function delTarget():void {
			getInstance().delTarget();
		}
		
		protected function delTarget():void {
			_target.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			_target = null;
		}
		
	}
}