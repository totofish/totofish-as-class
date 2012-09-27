/**
 * @author totofish
 * @date 2010/5/4
 * @email eaneanean@hotmail.com
 */
/******************************************

地址控制用法說明：

import totofish.form.AddressControl;

var AC:AddressControl = new AddressControl(z_txt,county_CB,town_CB,address_txt);
// 檢查地址是否填寫完整
trace(AC.CheckData());   true || 原因字串
// 顯示地址
trace(AC.value);
// 清除地址
AC.reset();
// 設定地址
AC.value = 123|county|town|address;

*********************************************/

package totofish.form {
	import fl.controls.ComboBox;
	import flash.text.TextField;
	import flash.events.Event;
	import fl.data.DataProvider;
	
	public class AddressControl	{
		private var county_array:Array = ["臺北市", "基隆市", "新北市", "宜蘭縣", "新竹市", "新竹縣", "桃園縣", "苗栗縣", "臺中市", "彰化縣", "南投縣", "嘉義市", "嘉義縣", "雲林縣", "臺南市", "高雄市", "南海諸島", "澎湖縣", "屏東縣", "臺東縣", "花蓮縣", "金門縣", "連江縣"]
		private var town_array:Array = [["100中正區", "103大同區", "104中山區", "105松山區", "106大安區", "108萬華區", "110信義區", "111士林區", "112北投區", "114內湖區", "115南港區", "116文山區"],
										["200仁愛區", "201信義區", "202中正區", "203中山區", "204安樂區", "205暖暖區", "206七堵區"], 
										["207萬里區", "208金山區", "220板橋區", "221汐止區", "222深坑區", "223石碇區", "224瑞芳區", "226平溪區", "227雙溪區", "228貢寮區", "231新店區", "232坪林區", "233烏來區", "234永和區", "235中和區", "236土城區", "237三峽區", "238樹林區", "239鶯歌區", "241三重區", "242新莊區", "243泰山區", "244林口區", "247蘆洲區", "248五股區", "249八里區", "251淡水區", "252三芝區", "253石門區"],
										["260宜蘭市", "261頭城鎮", "262礁溪鄉", "263壯圍鄉", "264員山鄉", "265羅東鎮", "266三星鄉", "267大同鄉", "268五結鄉", "269冬山鄉", "270蘇澳鎮", "272南澳鄉", "290釣魚台列嶼"],
										["300新竹市"],
										["302竹北市", "303湖口鄉", "304新豐鄉", "305新埔鎮", "306關西鎮", "307芎林鄉", "308寶山鄉", "310竹東鎮", "311五峰鄉", "312橫山鄉", "313尖石鄉", "314北埔鄉", "315峨眉鄉"],
										["320中壢市", "324平鎮市", "325龍潭鄉", "326楊梅鎮", "327新屋鄉", "328觀音鄉", "330桃園市", "333龜山鄉", "334八德市", "335大溪鎮", "336復興鄉", "337大園鄉", "338蘆竹鄉"],
										["350竹南鎮", "351頭份鎮", "352三灣鄉", "353南庄鄉", "354獅潭鄉", "356後龍鎮", "357通霄鎮", "358苑裡鎮", "360苗栗市", "361造橋鄉", "362頭屋鄉", "363公館鄉", "364大湖鄉", "365泰安鄉", "366銅鑼鄉", "367三義鄉", "368西湖鄉", "369卓蘭鎮"],
										["400中區", "401東區", "402南區", "403西區", "404北區", "406北屯區", "407西屯區", "408南屯區", "411太平區", "412大里區", "413霧峰區", "414烏日區", "420豐原區", "421后里區", "422石岡區", "423東勢區", "424和平區", "426新社區", "427潭子區", "428大雅區", "429神岡區", "432大肚區", "433沙鹿區", "434龍井區", "435梧棲區", "436清水區", "437大甲區", "438外埔區", "439大安區"],
										["500彰化市", "502芬園鄉", "503花壇鄉", "504秀水鄉", "505鹿港鎮", "506福興鄉", "507線西鄉", "508和美鎮", "509伸港鄉", "510員林鎮", "511社頭鄉", "512永靖鄉", "513埔心鄉", "514溪湖鎮", "515大村鄉", "516埔鹽鄉", "520田中鎮", "521北斗鎮", "522田尾鄉", "523埤頭鄉", "524溪州鄉", "525竹塘鄉", "526二林鎮", "527大城鄉", "528芳苑鄉", "530二水鄉"],
										["540南投市", "541中寮鄉", "542草屯鎮", "544國姓鄉", "545埔里鎮", "546仁愛鄉", "551名間鄉", "552集集鎮", "553水里鄉", "555魚池鄉", "556信義鄉", "557竹山鎮", "558鹿谷鄉"],
										["600嘉義市"],
										["602番路鄉", "603梅山鄉", "604竹崎鄉", "605阿里山鄉", "606中埔鄉", "607大埔鄉", "608水上鄉", "611鹿草鄉", "612太保市", "613朴子市", "614東石鄉", "615六腳鄉", "616新港鄉", "621民雄鄉", "622大林鎮", "623溪口鄉", "624義竹鄉", "625布袋鎮"],
										["630斗南鎮", "631大埤鄉", "632虎尾鎮", "633土庫鎮", "634褒忠鄉", "635東勢鄉", "636臺西鄉", "637崙背鄉", "638麥寮鄉", "640斗六市", "643林內鄉", "646古坑鄉", "647莿桐鄉", "648西螺鎮", "649二崙鄉", "651北港鎮", "652水林鄉", "653口湖鄉", "654四湖鄉", "655元長鄉"],
										["700中西區", "701東區", "702南區", "704北區", "708安平區", "709安南區", "710永康區", "711歸仁區", "712新化區", "713左鎮區", "714玉井區", "715楠西區", "716南化區", "717仁德區", "718關廟區", "719龍崎區", "720官田區", "721麻豆區", "722佳里區", "723西港區", "724七股區", "725將軍區", "726學甲區", "727北門區", "730新營區", "731後壁區", "732白河區", "733東山區", "734六甲區", "735下營區", "736柳營區", "737鹽水區", "741善化區", "742大內區", "743山上區", "744新市區", "745安定區"],
										["800新興區", "801前金區", "802苓雅區", "803鹽埕區", "804鼓山區", "805旗津區", "806前鎮區", "807三民區", "811楠梓區", "812小港區", "813左營區", "814仁武區", "815大社區", "820岡山區", "821路竹區", "822阿蓮區", "823田寮區", "824燕巢區", "825橋頭區", "826梓官區", "827彌陀區", "828永安區", "829湖內區", "830鳳山區", "831大寮區", "832林園區", "833鳥松區", "840大樹區", "842旗山區", "843美濃區", "844六龜區", "845內門區", "846杉林區", "847甲仙區", "848桃源區", "849那瑪夏區", "851茂林區", "852茄萣區"],
										["817東沙", "819南沙"],
										["880馬公市", "881西嶼鄉", "882望安鄉", "883七美鄉", "884白沙鄉", "885湖西鄉"],
										["900屏東市", "901三地門鄉", "902霧臺鄉", "903瑪家鄉", "904九如鄉", "905里港鄉", "906高樹鄉", "907鹽埔鄉", "908長治鄉", "909麟洛鄉", "911竹田鄉", "912內埔鄉", "913萬丹鄉", "920潮州鎮", "921泰武鄉", "922來義鄉", "923萬巒鄉", "924崁頂鄉", "925新埤鄉", "926南州鄉", "927林邊鄉", "928東港鎮", "929琉球鄉", "931佳冬鄉", "932新園鄉", "940枋寮鄉", "941枋山鄉", "942春日鄉", "943獅子鄉", "944車城鄉", "945牡丹鄉", "946恆春鎮", "947滿州鄉"],
										["950臺東市", "951綠島鄉", "952蘭嶼鄉", "953延平鄉", "954卑南鄉", "955鹿野鄉", "956關山鎮", "957海端鄉", "958池上鄉", "959東河鄉", "961成功鎮", "962長濱鄉", "963太麻里鄉", "964金峰鄉", "965大武鄉", "966達仁鄉"],
										["970花蓮市", "971新城鄉", "972秀林鄉", "973吉安鄉", "974壽豐鄉", "975鳳林鎮", "976光復鄉", "977豐濱鄉", "978瑞穗鄉", "979萬榮鄉", "981玉里鎮", "982卓溪鄉", "983富里鄉"],
										["890金沙鎮", "891金湖鎮", "892金寧鄉", "893金城鎮", "894烈嶼鄉", "896烏坵鄉"],
										["209南竿鄉", "210北竿鄉", "211莒光鄉", "212東引鄉"]];
								
		private var FDAPTORIC_zip:Array = new Array()
		private var zip:String
		
		private var ZT:TextField;
		private var CB:ComboBox;
		private var TB:ComboBox;
		private var AT:TextField;

		public function AddressControl(zipT:TextField, countyB:ComboBox, townB:ComboBox, addT:TextField) {
			ZT = zipT;
			CB = countyB;
			TB = townB;
			AT = addT;
			
			if (ZT) {
				ZT.maxChars = 3;
				ZT.restrict = "0-9";
			}
			if (addT) {
				addT.maxChars = 30;
				addT.restrict = "^\u0001-\u001F\u0000\u0080-\u00FF";
			}
			
			var ay:DataProvider  = new DataProvider();
			ay.addItem({data:0, label:"縣市"});
			for (var i = 0; i < county_array.length; i++){
				ay.addItem({data:county_array[i], label:county_array[i]});
			}
			CB.dataProvider = ay;
			var ay2:DataProvider  = new DataProvider();
			ay2.addItem( { data:0, label:"市/區/鄉/鎮" } );
			TB.dataProvider = ay2;
			
			
			CB.addEventListener(Event.CHANGE, addressChangeHandler);
			TB.addEventListener(Event.CHANGE, addressChangeHandler);
		}
		
		private function addressChangeHandler(event:*):void {
			if (event.target == CB)	{
				if (ZT) ZT.text = "";
				if (event.target.selectedIndex != 0){
					var ay:DataProvider  = new DataProvider();
					ay.addItem({data:0, label:"市/區/鄉/鎮"});
					var tmp_array = town_array[event.target.selectedIndex - 1];
					FDAPTORIC_zip = new Array();
					for (var i = 0; i < tmp_array.length ; i++)	{
						FDAPTORIC_zip.push(tmp_array[i].substr(0, 3));
						ay.addItem({data:tmp_array[i].substr(3), label:tmp_array[i].substr(3)});
					}
					TB.dataProvider = ay;
					TB.selectedIndex = 1;
					addressChangeHandler( { target:TB } );
				}else{
					TB.selectedIndex = 0;
					var dp:DataProvider = new DataProvider();
					dp.addItem({data:0, label:"市/區/鄉/鎮"});
					TB.dataProvider = dp;
				}
			}else if (event.target == TB) {
				zip = FDAPTORIC_zip[event.target.selectedIndex - 1];
				if (ZT) ZT.text = zip == null ? "" : zip;
			}
		}
		
		private function findItem(dp:DataProvider, str:String):int {
			for (var i = 0; i < dp.length ; i++) {
				if (str == dp.getItemAt(i).data) return i;
			}
			return 0;
		}
		
		//////////////////////////////////////////
		//
		// public setter getter
		//
		//////////////////////////////////////////
		
		public function get value():String {
			var s:String = "";
			s += ZT ? ZT.text : "";
			s += (CB.value == "0" ? "" : CB.value);
			s += (TB.value == "0" ? "" : TB.value);
			s += AT ? AT.text : "";
			return s;
		}
		
		// zip|county|town|address
		public function set value(str:String):void {
			var s_array:Array = str.split("|");
			var i:int = 0;
			var tmpZIP:String = "";
			if (ZT) {
				tmpZIP = s_array[i];
				i++
			}
			if (CB) {
				CB.selectedIndex = findItem(CB.dataProvider, s_array[i]);
				i++
			}
			if (TB) {
				addressChangeHandler( { target:CB } );
				TB.selectedIndex = findItem(TB.dataProvider, s_array[i]);
				addressChangeHandler( { target:TB } );
				i++
			}
			if (AT) {
				AT.text = s_array[i];
			}
			ZT.text = tmpZIP;
		}
		
		//////////////////////////////////////////
		//
		// public function
		//
		//////////////////////////////////////////
		
		public function CheckData():* {
			if (ZT) {
				if (ZT.text == "" || ZT.text.length < 3) return "請填寫郵遞區號";
			}
			if (AT) {
				if (AT.text == "") {
					return "請填寫地址";
				}else if (AT.text.length < 5) {
					return "地址字數過少";
				}else if (!isNaN(Number(AT.text))) {
					return "地址不能全部數字";
				}
			}
			if (CB.selectedIndex == 0) {
				return "請選擇縣市";
			}
			if (TB.selectedIndex == 0) {
				return "請選擇市區鄉鎮";
			}
			if (ZT) {
				if (ZT.text != zip) return "郵遞區號錯誤";
			}
			return true;
		}
		
		public function reset():void {
			CB.selectedIndex = 0;
			addressChangeHandler( { target:CB } );
			if (AT) AT.text = "";
		}
	}
}