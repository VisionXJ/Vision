package cn.vision.interfaces
{
	import cn.vision.pattern.core.State;

	public interface IState
	{
	
		/**
		 * 
		 * 上一个状态。
		 * 
		 */
		
		function get lastState():State;
		
		/**
		 * 
		 * 当前状态。
		 * 
		 */
		
		function get state():State;
		
		/**
		 * @private
		 */
		function set state($value:State):void;
		
	}
}