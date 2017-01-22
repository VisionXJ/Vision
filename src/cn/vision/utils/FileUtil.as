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
	import cn.vision.system.VSFile;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
	public final class FileUtil extends NoInstance
	{
		
		/**
		 * 
		 * 删除文件。
		 * 
		 * @param $path:String 文件绝对路径。
		 * 
		 */
		
		public static function deleteFile($absolutePath:String):Boolean
		{
			var result:Boolean;
			var file:VSFile = new VSFile($absolutePath);
			if (file.exists)
			{
				try
				{
					file.deleteFile();
					result = true;
				}
				catch(e:Error) { }
			}
			return result;
		}
		
		/**
		 * 
		 * 移动文件。
		 * 
		 * @param $fromPath:String 需要移动的文件路径。
		 * @param $toPath:String 移动至的路径。
		 * @param $overwrite:Boolean (default = false) 强制覆盖。
		 * 
		 */
		
		public static function moveFile($fromPath:String, $toPath:String, $overwrite:Boolean = false):void
		{
			var fromFile:VSFile = new VSFile($fromPath);
			var toFile:VSFile = new VSFile($toPath);
			if (fromFile.exists)
			{
				fromFile.moveTo(toFile, $overwrite);
			}
		}
		
		
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
		 * 从文本文件中读取字符串。
		 * 
		 * @param $path:String 文件绝对路径。
		 * 
		 */
		
		public static function readUTF($absolutePath:String):String
		{
			var file:VSFile = new VSFile($absolutePath);
			if (file.exists)
			{
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.READ);
				var result:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				file = null;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 保存字符串到文件。
		 * 
		 * @param $path:String 文件路径。
		 * @param $data:String 要保存的字符串。
		 * 
		 */
		
		public static function saveUTF($path:String, $data:String):void
		{
			var file:VSFile = new VSFile($path);
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes($data);
			stream.close();
			file = null;
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
			var file:File = File.applicationDirectory.resolvePath($url);  //启动 EXE文件的位置。
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
			var file:File = File.desktopDirectory.resolvePath($url);   //在桌面上追加路径
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
		
		
		/**
		 * 
		 * 判定两个文件是否为相同。<br>
		 * 特别的，如果参数之一为文件夹类型或不存在则直接返回为false。
		 * 
		 * @return 俩文件相同则返回true。
		 * 
		 */
		
		public static function compareFile($file1:File, $file2:File):Boolean
		{
			var result:Boolean;
			
			//不存在或者为文件夹类型都返回为 false。
			if ($file1.exists && $file2.exists && 
				!$file1.isDirectory && !$file2.isDirectory)
			{
				var stream1:FileStream = new FileStream;
				var stream2:FileStream = new FileStream;
				
				stream1.open($file1, FileMode.READ);
				stream2.open($file2, FileMode.READ);
				
				//如果长度不相等则直接返回 false。
				result = stream1.bytesAvailable == stream2.bytesAvailable;
				
				var readAble:uint = stream1.bytesAvailable;
				
				while (result && (stream1.position != readAble))
				{
					if (stream1.readByte() != stream2.readByte())
						result = false;
				}
				
				stream1.close();
				stream2.close();
			}
			
		 	return result; 
		}
		
	}
}