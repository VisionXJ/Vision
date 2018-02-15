package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	
	
	/**
	 * 用于为新的实例生成唯一ID标识。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class IDUtil extends NoInstance
	{
		
		
		/**
		 * 生成一个带时间戳的ID。
		 * 
		 * @return String
		 * 
		 */
		public static function generateTimestanpID():String
		{
			return ObjectUtil.convert(new Date, String, "YYYYMMDDHHMISSMS") + StringUtil.formatUint(Math.random() * 10000, 4);
		}
		
		
		/**
		 * 生成一个新的实例ID标识。
		 * 
		 * @param $key:String (default = null) 关键字。
		 * 
		 * @return uint
		 * 
		 */
		public static function generateID($key:String = null):uint
		{
			return $key ? (IDS[$key] = IDS[$key] == undefined ? 1 : IDS[$key] + 1) : ++id;
		}
		
		
		/**
		 * 生成一个新的实例ID标识。
		 * 
		 * @param $key:String (default = null) 关键字。
		 * 
		 * @return uint
		 * 
		 */
		public static function registID($key:String, $id:uint):void
		{
			if (($key && IDS[$key] && IDS[$key] < $id) || IDS[$key] == undefined) IDS[$key] = $id;
		}
		
		
		/**
		 * @private
		 */
		private static var id:uint = 0;
		
		
		/**
		 * @private
		 */
		private static const IDS:Object = {};
		
	}
}