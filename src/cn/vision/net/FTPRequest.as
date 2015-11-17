package cn.vision.net
{
	
	/**
	 * 
	 * FTP请求，一个完整的FTP请求应包含FTP host，FTP端口，用户名，密码，加载地址，存储地址。
	 * AIR Only
	 * 
	 * @see cn.vision.net.FTPLoader
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSObject;
	import cn.vision.interfaces.IRequest;
	import cn.vision.utils.StringUtil;
	
	import flash.utils.ByteArray;
	
	
	public final class FTPRequest extends VSObject implements IRequest
	{
		
		/**
		 * 
		 * <code>FTPRequest</code>构造函数。
		 * 
		 * @param $host:String (default = null) FTP IP。
		 * @param $userName:String (default = null) FTP 用户名。
		 * @param $passWord:String (default = null) FTP 密码。
		 * @param $port:uint (default = 21) FTP 端口。
		 * @param $remoteURL:String (default = null) 下载路径，若是上传模式则为上传路径。
		 * @param $localURL:String (default = null) 存储路径，如是上传模式则为需要上传的文件路径。
		 * 
		 */
		
		public function FTPRequest(
			$host:String = null,
			$userName:String = null,
			$passWord:String = null,
			$port:uint = 21,
			$remoteURL:String = null,
			$localURL :String = null)
		{
			super();
			
			initialize($host, $userName, $passWord, $port, $remoteURL, $localURL);
		}
		
		
		/**
		 * @private
		 */
		private function initialize(
			$host:String,
			$userName:String,
			$passWord:String,
			$port:uint,
			$remoteURL:String,
			$localURL :String):void
		{
			host = $host;
			port = $port;
			userName = $userName;
			passWord = $passWord;
			remoteURL = $remoteURL;
			localURL  = $localURL;
		}
		
		
		/**
		 * 
		 * 请求是否可用，IP，端口，用户名，密码，加载地址，存储地址任何一项都不能为空。
		 * 
		 */
		
		public function get available():Boolean
		{
			return !(port == 0 || 
				StringUtil.isEmpty(host) || 
				StringUtil.isEmpty(userName) || 
				StringUtil.isEmpty(passWord) || 
				StringUtil.isEmpty(remoteURL) || 
				StringUtil.isEmpty(localURL));
		}
		
		
		/**
		 * 
		 * FTP IP。
		 * 
		 */
		
		public var host:String;
		
		
		/**
		 * 
		 * 下载路径，若是上传模式则为上传路径。
		 * 
		 */
		
		public var remoteURL:String;
		
		
		/**
		 * 
		 * 密码。
		 * 
		 */
		
		public var passWord:String;
		
		
		/**
		 * 
		 * 端口。
		 * 
		 */
		
		public var port:uint;
		
		
		/**
		 * 
		 * 用户名。
		 * 
		 */
		
		public var userName:String;
		
		
		/**
		 * 
		 * 存储路径，如是上传模式则为需要上传的文件路径。
		 * 
		 */
		
		public var localURL:String;
		
	}
}