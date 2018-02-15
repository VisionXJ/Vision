package cn.vision.interfaces
{
	
	public interface IData
	{
		
		/**
		 * 定义使用的数据参数。
		 */
		function get data():Object;
		
		/**
		 * @private
		 */
		function set data($value:Object):void;
	}
}