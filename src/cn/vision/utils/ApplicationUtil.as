package cn.vision.utils
{
	
	/**
	 * 
	 * 定义了一些application工具函数。<br>
	 * AIR only。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import air.update.ApplicationUpdaterUI;
	
	import cn.vision.core.NoInstance;
	import cn.vision.system.VSFile;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	
	
	public final class ApplicationUtil extends NoInstance
	{
		
		/**
		 * 
		 * 退出播放器。
		 * 
		 */
		
		public static function exit():void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		
		/**
		 * 
		 * 调用外部程序。
		 * 
		 * $path:String 程序路径。
		 * $args 相关参数。
		 * 
		 */
		
		public static function execute($path:String, ...$args):void
		{
			if (NativeProcess.isSupported)
			{
				var process:NativeProcess = new NativeProcess;
				var file:VSFile = new VSFile($path);
				if (file.exists)
				{
					var info:NativeProcessStartupInfo = new NativeProcessStartupInfo;
					info.executable = file;
					if ($args && $args.length)
					{
						var l:uint = $args.length;
						var args:Vector.<String> = new Vector.<String>;
						for (var i:uint = 0; i < l; i++)
							args[i] = String($args[i]);
						info.arguments = args;
					}
					process.start(info);
				}
			}
		}
		
		
		/**
		 * 
		 * 获取当前版本号。
		 * 
		 */
		
		public static function getVersion():String
		{
			var ui:ApplicationUpdaterUI = new ApplicationUpdaterUI;
			return ui.currentVersion;
		}
		
	}
}