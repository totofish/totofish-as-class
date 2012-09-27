package totofish.filters{
	import com.greensock.*;
	import com.greensock.plugins.TweenPlugin;
	import totofish.filters.Pixelate;
	import flash.filters.ShaderFilter;
	
	public class PixelateFilterPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 1.0;
		/** @private **/
		private static var _propNames:Array = ["dimension"];
		/** @private **/
		protected var _filter:Pixelate;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		public function PixelateFilterPlugin() {
			super();
			this.propName = "pixelate";
			this.overwriteProps = ["dimension"];
		}
		
		/** @private **/	
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			var filters:Array = _target.filters, _index:int = -1, i:int;
			i = filters.length;
			while (i--) {
				if (filters[i] is ShaderFilter) {
					_index = i;
					break;
				}
			}
			_filter = new Pixelate();
			if (_index == -1 || filters[_index] == null) {
				_target.filters = [_filter];
			}else {
				filters[_index] = _filter;
				_target.filters = filters;
			}
			
			addTween(_filter, "dimension", _filter["dimension"], value["dimension"], "dimension");
			
			return true;
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			updateTweens(n);
			var filters:Array = _target.filters, _index:int = -1, i:int;
			i = filters.length;
			while (i--) {
				if (filters[i] is ShaderFilter) {
					_index = i;
					break;
				}
			}
			filters[_index] = _filter;
			_target.filters = filters;
		}
	}
}