###Summary

這是 **totofish** 個人慣用的 **`ActionScript`** 類別

包含資料傳送類別、地址選擇器、日期選擇器、按鈕控制、濾鏡...




###Getting Started

* **`totofish.ui.MCButton`** 按鈕控制類別用法說明

```actionscript
MCButton.setBtn(mc);
MCButton.setBtn(mc, {speed:10,                    // 全狀態影格速度預設為 1 , 10便代表一次跳10格的播放速度 0代表直接跳
				smooth:{ up:NaN, over:NaN, down:NaN, selected:NaN, disable:0 },   // 各狀態speed時間，如果狀態速度為NaN就取speed速度
				LABEL_UP:"Up",                    // 一般狀態標籤
				LABEL_OVER:"Over",                // ROLL_OVER狀態標籤
				LABEL_DOWN:"Down",                // MouseDown狀態標籤
				LABEL_SELECTED:"Selected",        // Selected狀態標籤
				LABEL_DISABLE:"Disable",          // Disable狀態標籤
				selected:true,                    // 是否為選取狀態
				enable:true,                      // 按鈕是否enable
				autoKill:true,                    // 是否當 removeChild 時移除按鈕功能,預設true
				autoRun:true,                     // 是否依照 label 標籤跑影格
				setEvent:{onClick:EventHandler}   // 直接設定事件function,用法請參考setEvent方法
			   });

MC.Smooth({ up:0, over:0, down:0, selected:0, disable:0 });
MC.ClearSmooth();
MC.core.speed = 2;
MC.core.selected = !MC.core.selected;
MC.core.autoKill = false;
MC.core.autoRun = false;
MC.core.isEnable();
MC.core.LABEL_UP = "Up";
MC.core.LABEL_OVER = "Over";
MC.core.LABEL_DOWN = "Down";
MC.core.LABEL_SELECTED = "Selected";
MC.core.LABEL_DISABLE = "Disable";
MC.Select(selected);
MC.Enable();
MC.Disable();
MC.setEvent({onClick:EventHandler,
			 onDown:EventHandler,
			 onOver:EventHandler,
			 onOut:EventHandler,
			 onUp:EventHandler});

MC.onClick = function(e:Event){};
MC.onDown = function(){);
MC.onOver = MC.onOut = MC.onUp = EventHandler;

MC.addEventListener(MCButton.OVER, EventHandler);
MC.addEventListener(MCButton.OUT, EventHandler);
MC.addEventListener(MCButton.DOWN, EventHandler);
MC.addEventListener(MCButton.UP, EventHandler);
MC.addEventListener(MCButton.CLICK, EventHandler);

function EventHandler(e:Event){
	 // e.target --- MC
	 // e.type   --- 事件
}
function EventHandler(){
	 // arguments[0].target --- MC
	 // arguments[0].type   --- 事件
}
function EventHandler(...args){
	 // args[0].target   --- MC
	 // args[0].type     --- 事件
}

```



* **`totofish.ui.FrameControl.as`** 時間軸播放控制類別用法說明

```actionscript
FrameControl.goFrame(MC, 15, EventHandler, ["a",true]);
function EventHandler(a,b):void {
		trace(a, b);
}

// 到某一指定影格(後2參數非必要)
FrameControl.goFrame(MC, 15);
// 播放到最後影格(後2參數非必要)
FrameControl.goLast(MC, EventHandler, [1, 2]);
// 播放到第一影格(後2參數非必要)
FrameControl.goFront(MC, EventHandler, [1, 2]);
```




* **`totofish.ui.VScroll`** 直式Scroll類別用法說明

```actionscript
var VS:VScroll = new VScroll({bar:bar_mc,          // 拉把
							  barH:100,            // 拉把移動限制距離
							  content:content_mc,  // 內容
							  areaH:100,           // 內容顯示範圍高度
							  top:top_mc,
							  bottom:bottom_mc});        

VS.reset();
```




* **`totofish.ui.HScroll`** 直式Scroll類別用法說明

```actionscript
var HS:HScroll = new HScroll({bar:bar_mc,          // 拉把
							  barW:100,            // 拉把移動限制距離
							  content:content_mc,  // 內容
							  areaW:100,           // 內容顯示範圍寬度
							  left:left_mc,
							  right:right_mc});        

HS.reset();
```




* **`totofish.form.HTTP`** HTTP類別用法說明

```actionscript
function EventHandler(e:HTTPEvent):void {
	// e.sendData  -- 當初送出的參數object
	if(e.success){
		// e.data      -- 返回的原始資料
		// e.json      -- 如果是json物件，這邊就會有質
	}else{
		// 失敗
	}
}
HTTP.send(EventHandler, "target.php", {search:"key"}, "GET");
HTTP.sendString(EventHandler, "target.php", '<?xml version="1.0"?>');
HTTP.sendStream(EventHandler, ByteArray, "target.php", {getData:"data"});
```




* **`totofish.form.BornControl`** 日期選擇類別用法說明

```actionscript
var BC:BornControl = new BornControl(Year_ComboBox, Month_ComboBox, Day_ComboBox);
BC.value = "2008/2/31"; // 設為指定日期
BC.reset(); // 設為無選取狀態
// BC.value
// BC.year
// BC.month
// BC.day
```




* **`totofish.form.AddressControl`** 地址選擇類別用法說明

```actionscript
var AC:AddressControl = new AddressControl(z_TextField, county_ComboBox, town_ComboBox, address_TextField);
// 檢查地址是否填寫完整
trace(AC.CheckData());   true || 原因字串
// 顯示地址
trace(AC.value);
// 清除地址
AC.reset();
// 設定地址
AC.value = 123|county|town|address;
```




* **`totofish.media.QRScanner`** QRCode掃描儀搭配類別用法說明

```actionscript
QRScanner.setTarget(stage);
QRScanner.getInstance().addEventListener(QRScanner.BEEP, qrHandler, false, 0, true);
// 或
QRScanner.setTarget(stage).addEventListener(QRScanner.BEEP, qrHandler, false, 0, true);
function qrHandler(e:BubblesEvent):void {
	trace(e.data.QRCode);
}
// 取得註冊對象
QRScanner.getTarget();
// 移除監控對象
QRScanner.getTarget().removeEventListener(QRScanner.BEEP, qrHandler);
QRScanner.delTarget();
```




* **`totofish.filters.Pixelate`** Pixelate濾鏡用法說明

```actionscript
// 馬賽克濾鏡套用
var filter:Pixelate = new Pixelate(5);
filter.dimension(5);
MC.filters = [filter];
```




* **`totofish.filters.RGB`** RGB濾鏡用法說明

```actionscript
// RGB分離
var filter:RGB = new RGB([1, 0, 1]);
filter.RGBChannel([0, 0, 1]);
MC.filters = [filter];
```




* **`totofish.util.ParentTransition`** MovieClip註冊自訂事件類別用法說明

```actionscript
function callfun(e:Event):void {
	switch(e.type) {
		case "In":
		case "InComplete":
		case "Out":
		case "OutComplete":
		case "other1":
		case "other2":
			trace(e.target);
	}
}
ParentTransition.setEvent(mc, {In:callfun, 
							   InComplete:callfun, 
							   Out:callfun, 
							   OutComplete:callfun,
							   other1:callfun2,
							   other2:callfun2});
mc.other1();
```




* **`totofish.util.StringUtil`** 字串驗證處理類別用法說明

```actionscript
StringUtil.checkTWID("a123456789"); // 身分證驗證
StringUtil.getTwID(1);              // 產生性別男的身分證號
// 更多請看class內說明
```
