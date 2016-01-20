package cn.vision.data
{
	
	/**
	 * 
	 * 提示数据。
	 * 
	 */
	
	
	import cn.vision.core.vs;
	
	
	public class Tip
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $message (default = "") 提示内容。
		 * @param $type (default = 0) 0为“Error”，1为“Notice”，2为记录Record，其他Undefined。
		 * 
		 */
		
		public function Tip($content:String = "", $type:uint = 0)
		{
			vs::content = $content;
			type        = $type;
		}
		
		
		/**
		 * 
		 * 转换为String时输出的内容。
		 * 
		 */
		
		public function toString():String
		{
			return content;
		}
		
		
		/**
		 * 
		 * 提示标题。
		 * 
		 */
		
		public function get title():String
		{
			switch (type)
			{
				case 0:
					return "Error : ";
				case 1:
					return "Notice : ";
				case 2:
					return "Record : ";
				default:
					return "Undefined:";
			}
		}
		
		
		/**
		 * 
		 * 提示内容。
		 * 
		 */
		
		public function get content():String
		{
			return vs::content;
		}
		
		
		/**
		 * @private
		 */
		private var type:uint;
		
		
		/**
		 * @private
		 */
		vs var content:String;
		
	}
}