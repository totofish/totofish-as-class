package totofish.util {
	import flash.utils.ByteArray;
	public class ObjectUtil {
		
		public function ObjectUtil() {
			throw new Error("ObjectUtil class is static container only");
		}
		
		// 複製Object
		public static function cloneObject(cloneObj:Object):Object {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(cloneObj);
			byteArray.position = 0;
			return byteArray.readObject() as Object;
		}
	}
}