/**
 * @author totofish
 * @date 2010/5/27 - 2010/7/1
 * @email eaneanean@hotmail.com
 */

/******************************************

用法說明：

幫助點選編輯影片片段用將繼承本class的MovieClip拖到其他MovieClip內使用

可搭配totofish.util.ParentTransition快速註冊事件
ParentTransition.setEvent(mc, {In:callfun, 
							   InComplete:callfun, 
							   Out:callfun, 
							   OutComplete:callfun,
							   other1:callfun2,
							   other2:callfun2});

*********************************************/

package totofish.ui {
	import flash.display.MovieClip;
	public class ParentTransMC extends MovieClip {
		public function ParentTransMC() {
			super();
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			visible = false;
			mouseChildren = false;
			mouseEnabled = false;
		}
	}
}