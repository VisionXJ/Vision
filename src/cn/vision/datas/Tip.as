package cn.vision.datas
{
	
	import cn.vision.core.vs;
	
	
	/**
	 * 提示数据。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Tip
	{
		
		/**
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
		 * 转换为String时输出的内容。
		 * 
		 * @return String
		 * 
		 */
		public function toString():String
		{
			return content;
		}
		
		
		/**
		 * 提示标题。
		 */
		public function get title():String
		{
			switch (type)
			{
				case 0:
					return "Error : ";
				case 2:
					return "Record : ";
				case 1:
				default:
					return "Notice : ";
			}
		}
		
		
		/**
		 * 提示内容。
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