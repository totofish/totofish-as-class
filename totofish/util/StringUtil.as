/**
 * 資料來源 
 * http://www.klstudio.com/post/113.html
 * http://active.tutsplus.com/articles/roundups/15-useful-as3-snippets-on-snipplr-com/
 * +其他自己製作微調部分
 * 
 */

package totofish.util{

	public class StringUtil{

		function StringUtil(){
			throw new Error("StringUtil class is static container only");
		}
		
		// 台灣身分證驗證
		public static function checkTWID(id:String):Boolean {
			var headPoint:Object = { 'A':1, 'B':10, 'C':19, 'D':28, 'E':37, 'F':46,
									 'G':55, 'H':64, 'I':39, 'J':73, 'K':82, 'L':2,
									 'M':11, 'N':20, 'O':48, 'P':29, 'Q':38, 'R':47,
									 'S':56, 'T':65, 'U':74, 'V':83, 'W':21, 'X':3,
									 'Y':12,'Z':30};
			var re1:RegExp = new RegExp('^[a-zA-Z][1-2][0-9]{8}$');
			if(re1.test(id) && id.length == 10){
				var ay:Array = id.split("");
				var num:int = headPoint[ay[0].toLocaleUpperCase()];
				for(var i=1; i<ay.length-1; i++){
					num += (9 - i) * int(ay[i]);
				}
				var checkid:int = num % 10 == 0 ? 0 : 10 - num % 10;
				if(checkid == ay[9]){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
		
		// 簡易台灣身分證產生
		public static function getTwID(g:int = 0):String {
			// g = 1 = 男, g = 2 = 女   -- 縣市會影響到英文開頭，這邊亂數決定
			g = g > 2 ? 0 : g < 0 ? 0 : g;
			var headPoint:Object = { 'A':1, 'B':10, 'C':19, 'D':28, 'E':37, 'F':46,
									 'G':55, 'H':64, 'I':39, 'J':73, 'K':82, 'L':2,
									 'M':11, 'N':20, 'O':48, 'P':29, 'Q':38, 'R':47,
									 'S':56, 'T':65, 'U':74, 'V':83, 'W':21, 'X':3,
									 'Y':12,'Z':30};
			var id:String = String.fromCharCode(int(Math.random() * 26) + 65);
			var gender:int = g == 0 ? int(Math.random() * 2) + 1 : g;
			var num:int = headPoint[id] + gender * 8;
			id += String(gender);
			
			for(var i=0; i<7; i++){
				var n:int = int(Math.random() * 10);
				num += n * (7 - i);
				id += String(n);
			}
			var checkid:int = num % 10 == 0 ? 0 : 10 - num % 10;
			return id + String(checkid);
		}
		
		// 忽略大小字母比較字符是否相等
		public static function equalsIgnoreCase(char1:String,char2:String):Boolean{
			return char1.toLowerCase() == char2.toLowerCase();
		}

		// 比較字符是否相等
		public static function equals(char1:String,char2:String):Boolean{
			return char1 == char2;
		}
		
		// 檢查是否為正確EMail格式 (感覺比較完整的方式，不允許數字開頭)
		public static function isEmail(char:String):Boolean {
			if (char == null) return false;
			if (char.length == 0) return false;
			var reg:RegExp = new RegExp("^[a-zA-Z][\\w.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z.]*[a-zA-Z]$");
			return reg.test(char);
		}
		
		// 是否為Email地址
		public static function isEmail2(char:String):Boolean{
			if(char == null){
				return false;
			}else if (char.split("@").length > 2) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
				return true;
		}
		
		// 是否為Email地址
		public static function checkEmail(char:String):Boolean {
			if(char == null){
				return false;
			}
			var pattern:RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/
			if(pattern.test(char)){
				if(char.split("@").length > 2){
					return false;
				}else{
					return true;
				}
			}else{
				return false;
			}
		}
		
		// 是否為有效Email地址 (不好)
		public function isValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/i;
			return emailExpression.test(email);
		}

		// 是否是數值字符串;
		public static function isNumber(char:String):Boolean{
			if(char == null){
				return false;
			}
			return !isNaN(Number(char));
		}
    
		// 是否为Double型數據
		public static function isDouble(char:String):Boolean{
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		
		// Integer
		public static function isInteger(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}

		// English
		public static function isEnglish(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}

		// 中文
		public static function isChinese(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		
		// 雙字節
		public static function isDoubleChar(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		
		// 含有中文字符
		public static function hasChineseChar(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}

		// 註冊字符
		public static function hasAccountChar(char:String,len:uint=15):Boolean{
			if(char == null){
				return false;
			}
			if(len < 10){
				len = 15;
			}
			char = trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", "");
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		
		// URL地址
		public static function isURL(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}

		// 是否為空白
		public static function isWhitespace(char:String):Boolean{
			switch (char){
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}

		// 去左右空格
		public static function trim(char:String):String{
			if(char == null){
				return null;
			}
			return rtrim(ltrim(char));
		}

		// 去左空格
		public static function ltrim(char:String):String{
			if(char == null){
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return char.replace(pattern,"");
		}

		// 去右空格
		public static function rtrim(char:String):String{
			if(char == null){
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return char.replace(pattern,"");
		}

		// 是否為前綴字符串
		public static function beginsWith(char:String, prefix:String):Boolean{         
			return (prefix == char.substring(0, prefix.length));
		}

		// 是否為後綴字符串
		public static function endsWith(char:String, suffix:String):Boolean{
			return (suffix == char.substring(char.length - suffix.length));
		}

		// 去除指定字符串
		public static function remove(char:String,remove:String):String{
			return replace(char,remove,"");
		}

		// 字符串替换
		public static function replace(char:String, replace:String, replaceWith:String):String{
			return char.split(replace).join(replaceWith);
		}

		// utf16轉utf8编碼
		public static function utf16to8(char:String):String{
			var out:Array = new Array();
			var len:uint = char.length;
			for(var i:uint=0;i<len;i++){
				var c:int = char.charCodeAt(i);
				if(c >= 0x0001 && c <= 0x007F){
					out[i] = char.charAt(i);
				} else if (c > 0x07FF) {
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
													0x80 | ((c >>  6) & 0x3F),
													0x80 | ((c >>  0) & 0x3F));
				} else {
					out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
													0x80 | ((c >>  0) & 0x3F));
				}
			}
			return out.join('');
		}

		// utf8轉utf16编碼
		public static function utf8to16(char:String):String{
			var out:Array = new Array();
			var len:uint = char.length;
			var i:uint = 0;
			while(i<len){
				var c:int = char.charCodeAt(i++);
				switch(c >> 4){
					case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
						// 0xxxxxxx
						out[out.length] = char.charAt(i-1);
					break;
					case 12: case 13:
						// 110x xxxx   10xx xxxx
						var char2:int = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
					break;
					case 14:
						// 1110 xxxx  10xx xxxx  10xx xxxx
						char2 = char.charCodeAt(i++);
						var char3:int = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
						((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
					break;
				}
			}
			return out.join('');
		}
     
		// FB分享連結
		/**
		 * Static method for creating a StringUtil instance.<br />
		 * 組合FB分享連結網址<br />
		 * <code>
		 * 	StringUtil.fbSharerLink("http://www.google.com", "title", "內文", "90x90.jpg");
		 * </code>
		 * @param url 分享網址
		 * @param title 分享標題
		 * @param summary 分享簡介內文
		 * @param images 圖片位置
		 */
		public static function fbSharerLink(url:String, title:String, summary:String, images:String):String {
			return "http://www.facebook.com/sharer.php?s=100&p[url]=" + encodeURIComponent(url) + "&p[title]=" + encodeURIComponent(title) + "&p[summary]=" + encodeURIComponent(summary) + "&p[images][0]=" + encodeURIComponent(images);
		}
		
		// FB分享META連結
		/**
		 * Static method for creating a StringUtil instance.<br />
		 * 組合FB分享META連結網址<br />
		 * <code>
		 * 	StringUtil.fbSharerLink("http://www.google.com", "title");
		 * </code>
		 * @param url 分享網址
		 * @param title 分享標題
		 */
		public static function fbMetaLink(url:String, title:String):String {
			return "http://www.facebook.com/sharer.php?u=" + encodeURIComponent(url) + "&t=" + encodeURIComponent(title);
		}
		
		// twitter分享連結
		/**
		 * Static method for creating a StringUtil instance.<br />
		 * 組合twitter分享連結網址<br />
		 * <code>
		 * 	twSharerLink.fbSharerLink("http://www.google.com", "內文");
		 * </code>
		 * @param url 分享網址
		 * @param text 分享簡介內文
		 */
		public static function twSharerLink(url:String, text:String):String {
			return "http://twitter.com/intent/tweet?original_referer=" + encodeURIComponent(url) + "&text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(url);
		}
		
	}
}