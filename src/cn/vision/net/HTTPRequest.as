package cn.vision.net
{
	
	/**
	 * 
	 * HTTP请求，一个完整的FTP请求应包含加载地址和存储地址。
	 * AIR Only
	 * 
	 * @see cn.vision.net.HTTPLoader
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
	
	
	public final class HTTPRequest extends VSObject implements IRequest
	{
		
		/**
		 * 
		 * <code>HTTPRequest</code>构造函数。
		 * 
		 * @param $loadURL:String (default = null) 加载路径。
		 * @param $saveURL:String (default = null) 存储路径。
		 * 
		 */
		
		public function HTTPRequest($loadURL:String = null, $saveURL:String = null)
		{
			super();
			
			initialize($loadURL, $saveURL);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($loadURL:String, $saveURL:String):void
		{
			loadURL = $loadURL;
			saveURL = $saveURL;
		}
		
		
		/**
		 * 
		 * 请求是否可用，加载地址，存储地址都不能为空。
		 * 
		 */
		
		public function get available():Boolean
		{
			return ! StringUtil.isEmpty(loadURL) && ! StringUtil.isEmpty(saveURL);
		}
		
		
		/**
		 * 
		 * 加载路径。
		 * 
		 */
		
		public var loadURL:String;
		
		
		/**
		 * 
		 * 存储路径。
		 * 
		 */
		
		public var saveURL:String;
		
	}
}