package cn.vision.utils
{
	
	/**
	 * 
	 * ByteArrayUtil定义了一些常用函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.utils.ByteArray;
	
	
	public final class ByteArrayUtil extends NoInstance
	{
		
		/**
		 * 
		 * 转换为ByteArray。
		 * 
		 * @param $data:Object 需要转换的实例。
		 * 
		 * @return ByteArray 转换后的ByteArray。
		 * 
		 */
		
		public static function convertByteArray($data:*):ByteArray
		{
			if ($data != null)
			{
				var name:String = ClassUtil.getClassName($data, false);
				name = name.toLowerCase() + "2ByteArray";
				var result:ByteArray = ByteArrayUtil[name] ? 
					ByteArrayUtil[name]($data) : string2Bytearray($data.toString());
			}
			return result;
		}
		
		
		/**
		 * @private
		 */
		private static function bytearray2ByteArray($data:ByteArray):ByteArray
		{
			return $data;
		}
		
		/**
		 * @private
		 */
		private static function string2Bytearray($data:String):ByteArray
		{
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes($data);
			return bytes;
		}
		
		/**
		 * @private
		 */
		private static function object2Bytearray($data:Object):ByteArray
		{
			var bytes:ByteArray = new ByteArray;
			bytes.writeObject($data);
			return bytes;
		}
		
	}
}