###Summary

這是 **totofish** 個人慣用的 **`ActionScript`** 類別

包含資料傳送類別、地址選擇器、日期選擇器、按鈕控制、濾鏡...




###Getting Started

* **`totofish.ui.MCButton.as`** 按鈕控制類別用法說明

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



* **`totofish.ui.FrameControl.as`** 按鈕控制類別用法說明

```actionscript
FrameControl.goFrame(MC, 15, EventHandler, ["a",true]);
function EventHandler(a,b){
		trace(a, b);
}

// 到某一指定影格(後2參數非必要)
FrameControl.goFrame(MC, 15);
// 播放到最後影格(後2參數非必要)
FrameControl.goLast(MC, EventHandler, [1, 2]);
// 播放到第一影格(後2參數非必要)
FrameControl.goFront(MC, EventHandler, [1, 2]);
```




* **`totofish.ui.VScroll.as`** 按鈕控制類別用法說明

```actionscript
var VS:VScroll = new VScroll({bar:bar_mc,          // 拉把
							  barH:100,            // 拉把移動限制距離
							  content:content_mc,  // 內容
							  areaH:100,           // 內容顯示範圍高度
							  top:top_mc,
							  bottom:bottom_mc});        

VS.reset();
```