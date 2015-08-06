package cn.vision.net
{
	
	/**
	 * 
	 * 文件加载，保存请求。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSObject;
	import cn.vision.interfaces.IAvailable;
	import cn.vision.utils.StringUtil;
	
	import flash.utils.ByteArray;
	
	
	public class FileRequest extends VSObject implements IAvailable
	{
		
		/**
		 * 
		 * <code>FileRequest</code>构造函数。
		 * 
		 * @param $saveURL:String (default = null) 保存路径。
		 * @param $loadURL:String (default = null) 存储路径。
		 * 
		 */
		
		public function FileRequest($saveURL:String = null, $data:ByteArray = null)
		{
			super();
			
			initialize($saveURL, $data);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($saveURL:String, $data:ByteArray):void
		{
			saveURL = $saveURL;
			data    = $data;
		}
		
		
		/**
		 * 
		 * 请求是否可用，存储地址和数据都不能为空。
		 * 
		 */
		
		public function get available():Boolean
		{
			return data && !StringUtil.isEmpty(saveURL);
		}
		
		
		/**
		 * 
		 * 保存路径。
		 * 
		 */
		
		public var saveURL:String;
		
		
		/**
		 * 
		 * 保存的数据。
		 * 
		 */
		
		public var data:ByteArray;
		
	}
}