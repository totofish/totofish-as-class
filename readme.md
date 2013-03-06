###Summary

這是 **totofish** 個人慣用的 **`ActionScript`** 類別

包含資料傳送類別、地址選擇器、日期選擇器、按鈕控制、濾鏡...




###Getting Started

* **`totofish.ui.MCButton.as`** 用法說明

```actionscript
MCButton.setBtn(mc);
MCButton.setBtn(mc, {speed:10,                         // 全狀態影格速度預設為 1 , 10便代表一次跳10格的播放速度 0代表直接跳
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
```