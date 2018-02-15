package cn.vision.interfaces
{
	public interface ISelect
	{
		
		/**
		 * 当前选项能否被选中。
		 */
		function get selectable():Boolean;
		
		/**
		 * @private
		 */
		function set selectable($value:Boolean):void;
		
		
		/**
		 * 当前选项是否被选中。
		 */
		function get selected():Boolean;
		
		/**
		 * @private
		 */
		function set selected($value:Boolean):void;
		
		/**
		 * 当前选项的序号。
		 */
		function get index():uint;
		
		/**
		 * @private
		 */
		function set index($value:uint):void;
		
	}
}