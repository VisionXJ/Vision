package cn.vision.interfaces
{
	
	public interface IDataProvider extends ILength
	{
		
		/**
		 * 定义数据源。
		 */
		function get dataProvider():Object;
		
		/**
		 * @private
		 */
		function set dataProvider($value:Object):void;
		
		
		/**
		 * 定义子项目呈现渲染器。
		 */
		function get itemRender():Class;
		
		/**
		 * @private
		 */
		function set itemRender($value:Class):void;
		
	}
}