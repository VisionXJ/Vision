package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	/**
	 * 定义了一些常用文件函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class FileUtil extends NoInstance
	{
		
		/**
		 * 根据文件名或文件路径获取文件的拓展名。
		 * 
		 * @param $url:String 文件名或文件路径。
		 * 
		 * @return String 拓展名。
		 * 
		 */
		public static function getExtension($url:String):String
		{
			var index:int = $url.lastIndexOf(".");
			return index > -1 ? $url.substr(index + 1).toLowerCase() : null;
		}
		
		/**
		 * 根据文件路径获取文件名。
		 * 
		 * @param $url:String 文件路径。
		 * 
		 * @return String 文件名。
		 * 
		 */
		public static function getName($url:String):String
		{
			$url = $url.split("\\").join("/");
			var index:int = $url.lastIndexOf("/");
			return $url.substr(index + 1);
		}
		
	}
}