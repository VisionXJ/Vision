package cn.vision.interfaces
{
	public interface ISelectedIndex
	{
		
		/**
		 * 当前被选中的选项的序号。
		 */
		function get selectedIndex():int;
		
		/**
		 * @private
		 */
		function set selectedIndex($value:int):void;
		
		/**
		 * 当前被选中的选项。
		 */
		function get selectedItem():*;
		
		/**
		 * @private
		 */
		function set selectedItem($value:*):void;
		
	}
}