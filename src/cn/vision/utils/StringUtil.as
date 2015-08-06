package cn.vision.utils
{
	
	/**
	 * 
	 * <code>StringUtil</code>定义了一些常用字符串操作函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.filesystem.File;
	
	
	public final class StringUtil extends NoInstance
	{
		
		/**
		 * 
		 * 字符串如果是英文，转换首字母为大写或小写。
		 * 
		 * @param $value 要转换的字符串
		 * @param $lower (default = true) true为转小写，false为转大写，默认为true。
		 * 
		 */
		
		public static function lowercaseInitials($value:String, $lower:Boolean = true):String
		{
			var f:String = $value.charAt(0);
			return ($lower ? f.toLowerCase() : f.toUpperCase()) + $value.substr(1);
		}
		
		
		/**
		 * 
		 * 格式化uint，如果长度不足，会在前面补0。
		 * 
		 */
		
		public static function formatUint($value:uint, $length:uint = 1):String
		{
			$length = Math.max(1, $length);
			var result:String = $value.toString();
			while(result.length < $length) result = "0" + result;
			return result;
		}
		
		/**
		 * 
		 * 转换任意Object为String。
		 * 
		 */
		
		public static function toString($value:Object):String
		{
			return $value ? $value.toString() : null;
		}
		
		
		/**
		 * 
		 * 验证字符串是否为空。
		 * 
		 */
		
		public static function isEmpty($value:String):Boolean
		{
			return ! ($value && $value != "");
		}
		
		
		/**
		 * 
		 * 获取换行符，不同的操作系统换行符不同。
		 * 
		 * @return String 换行符。
		 * 
		 */
		
		public static function get lineEnding():String
		{
			return lineEndingSymbol || (lineEndingSymbol = File.lineEnding);
		}
		
		
		/**
		 * @private
		 */
		private static var lineEndingSymbol:String;
		
	}
}