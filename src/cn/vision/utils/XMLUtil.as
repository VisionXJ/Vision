package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	
	/**
	 * 定义了一些XML，XMLList操作函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class XMLUtil extends NoInstance
	{
		
		/**
		 * 验证是否为XML格式字符串。
		 * 
		 * @param $value:* 验证的字符串。
		 * 
		 * @return Boolean 是否为XML格式字符串。
		 * 
		 */
		public static function validate($value:String):Boolean
		{
			return $value.charAt(0) == "<";
		}
		
	}
}