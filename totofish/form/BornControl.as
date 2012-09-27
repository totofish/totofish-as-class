/**
 * @author totofish
 * @date 2010/4/26
 * @email eaneanean@hotmail.com
 */

package totofish.form {
	import fl.controls.ComboBox;
	import flash.events.Event;
	import fl.data.DataProvider;
	
	public class BornControl{
		
		private var YB:ComboBox;
		private var MB:ComboBox;
		private var DB:ComboBox;
		
		////////////////// 生日控制 ****************************************
		public function BornControl(Y:ComboBox, M:ComboBox, D:ComboBox) {
			YB = Y;
			MB = M;
			DB = D;
			
			var mm:Number = new Date().getFullYear();     // 今年
			for (var iii = mm; iii >= mm-90; iii--) {
				YB.addItem({data:iii, label:iii});
			}
			
			for (var ii = 1; ii <= 12; ii++) {
				MB.addItem({data:ii, label:ii});
			}
			
			for (var i = 1; i <= 31; i++) {
				DB.addItem({data:i, label:i});
			}
			
			YB.addEventListener(Event.CHANGE, bornHandler);
			MB.addEventListener(Event.CHANGE, bornHandler);
			DB.addEventListener(Event.CHANGE, bornHandler);
		}
		
		// 日期偵測
		private function bornHandler(event:* = null):void {
			var num:Number = 32;
			do {
				num--;
				var max_date:Date = new Date(int(YB.value), int(MB.value)-1, num);
			} while (num != max_date.getDate());
			
			if (DB.selectedIndex > num-1) {
				DB.selectedIndex = num-1;
			}
		}
		
		public function get value():String {
			return YB.value + "/" + MB.value + "/" + DB.value;
		}
		public function set value(str:String):void {
			var ay:Array = str.split("/")
			var YD:DataProvider = YB.dataProvider;
			for(var i=0;i<YD.length;i++){
				if(YD.getItemAt(i).data == int(ay[0])){
					YB.selectedIndex = i;
				}
			}
			var MD:DataProvider = MB.dataProvider;
			for(i=0;i<MD.length;i++){
				if(MD.getItemAt(i).data == int(ay[1])) MB.selectedIndex = i;
			}
			var DD:DataProvider = DB.dataProvider;
			for(i=0;i<DD.length;i++){
				if(DD.getItemAt(i).data == int(ay[2])) DB.selectedIndex = i;
			}
			bornHandler();
		}
		
		public function get year():String {
			return YB.value;
		}
		
		public function get month():String {
			return MB.value;
		}
		
		public function get day():String {
			return DB.value;
		}
		
		public function CheckData():Boolean {
			return true;
		}
		
		public function reset():void {
			YB.selectedIndex = 0;
			MB.selectedIndex = 0;
			DB.selectedIndex = 0;
		}
	}
}