package cn.vision.utils
{
	
	/**
	 * 
	 * 日志记录工具。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.data.Tip;
	import cn.vision.system.VSFile;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
	public final class LogUtil extends NoInstance
	{
		
		/**
		 * 
		 * 输出一些内容。
		 * 
		 * @param ...$args 需要输出的内容。
		 * 
		 */
		
		public static function log(...$args):String
		{
			trace.apply(null, $args);
			return debug($args);
		}
		
		
		/**
		 * 
		 * 输出一个提示。
		 * 
		 * @param $tip:Tip 需要输出的提示。
		 * @param $meta:* 相关变量的引用。
		 * 
		 */
		
		public static function logTip($tip:Tip, $meta:* = null):String
		{
			return log(RegexpUtil.replaceTag($tip, $meta));
		}
		
		/**
		 * @private
		 */
		private static function initialize():void
		{
			var n:Date = new Date;
			var e:String = "log/" + n.fullYear + "-" + (n.month + 1) + "-" + n.date + ".log";
			var s:String = FileUtil.resolvePathApplication(e);
			if(!file || file.nativePath != s)
			{
				file = new VSFile(FileUtil.resolvePathApplication(e));
				stream = stream || new FileStream;
				stream.open(file, FileMode.APPEND);
				
				file.size && print(StringUtil.lineEnding);
				
				print("###########################################");
				print("#");
				print("# " + new Date);
				print("#");
				print("###########################################");
				print(StringUtil.lineEnding);
				
				stream.close();
			}
		}
		
		/**
		 * @private
		 */
		private static function debug($data:*):String
		{
			initialize();
			
			stream.open(file, FileMode.APPEND);
			
			var date:Date = new Date;
			var t:String = date.hours + ":" + date.minutes + ":" +date.seconds + " ";
			var d:String = $data.toString();
			var s:String = t + d;
			
			print(s);
			
			stream.close();
			return d;
		}
		
		/**
		 * @private
		 */
		private static function print($data:String):void
		{
			stream.writeBytes(ByteArrayUtil.convertByteArray($data + StringUtil.lineEnding));
		}
		
		
		/**
		 * @private
		 */
		private static var file:VSFile;
		
		/**
		 * @private
		 */
		private static var stream:FileStream;
		
	}
}