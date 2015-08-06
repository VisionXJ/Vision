package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ColorUtil</code>字符串与uint颜色值转换工具类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	
	public final class ColorUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 转换颜色字符串为uint。
		 * 
		 * @param $value:String
		 * 
		 * @return uint
		 * 
		 */
		
		public static function colorString2uint($value:String):uint
		{
			if ($value.charAt(0) == "#") 
				$value = "0x" + $value.substr(1);
			return uint($value);
		}
		
		
		/**
		 * 
		 * 转换uint为颜色字符串。
		 * 
		 * @param $value
		 * @param $prefix (default = "0x") 前缀可以为 "0x" 或 "#" 。
		 * 
		 * @return String
		 * 
		 */
		
		public static function colorUint2String($value:uint, $prefix:String = "0x"):String
		{
			$prefix = ($prefix=="#") ? "#" : "0x";
			return $prefix + $value.toString(16);
		}
		
		
		/**
		 * 
		 * 设置高亮颜色通道。
		 * 
		 * @param $displayObject:DisplayObject 设置高亮的显示对象。
		 * @param $value:Number 0-1之间的一个值。
		 * 
		 */
		
		public static function highlight($displayObject:DisplayObject, $value:Number):void
		{
			if ($displayObject)
			{
				var offSet:Number = $value * 255;
				$displayObject.transform.colorTransform
					= new ColorTransform(1, 1, 1, 1, offSet, offSet, offSet, offSet);
			}
			
		}
		
		
		/**
		 * 
		 * 取消颜色通道。
		 * 
		 * @param $displayObject:DisplayObject 显示对象。
		 * 
		 */
		
		public static function normalize($displayObject:DisplayObject):void
		{
			if ($displayObject)
				$displayObject.transform.colorTransform = new ColorTransform;
		}
		
	}
}