package cn.vision.utils
{
	
	/**
	 * 
	 * 定义了一些常用的文件操作。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.filesystem.File;
	
	
	public final class FileUtil extends NoInstance
	{
		
		/**
		 * 
		 * 从URL获取文件类型。<br>
		 * 注意：该方法只能简单判断文件类型。
		 * 
		 */
		
		public static function getFileTypeByURL(url:String):String
		{
			var arr:Array = url.split(".");
			return arr[arr.length - 1];
		}
		
		
		/**
		 * 
		 * 获取包含在应用程序目录的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathApplication($url:String):String
		{
			var file:File = File.applicationDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
		
		/**
		 * 
		 * 获取包含在应用程序存储目录的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathApplicationStorage($url:String):String
		{
			var file:File = File.applicationStorageDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
		
		/**
		 * 
		 * 获取包含在缓存目录文件夹的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathCache($url:String):String
		{
			var file:File = File.cacheDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
		
		/**
		 * 
		 * 获取包含在桌面目录文件夹的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathDesktop($url:String):String
		{
			var file:File = File.desktopDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
		
		/**
		 * 
		 * 获取包含在用户文档目录文件夹的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathDocuments($url:String):String
		{
			var file:File = File.documentsDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
		
		/**
		 * 
		 * 获取包含在用户目录文件夹的绝对路径。
		 * 
		 * @param $url:String 相对路径。
		 * 
		 * @return String 绝对路径。
		 * 
		 */
		
		public static function resolvePathUser($url:String):String
		{
			var file:File = File.userDirectory.resolvePath($url);
			file.canonicalize();
			return file.nativePath;
		}
		
	}
}