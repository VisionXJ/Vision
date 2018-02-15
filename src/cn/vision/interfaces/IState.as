package cn.vision.interfaces
{
	
	public interface IState
	{
		
		/**
		 * 上一个状态。
		 */
		function get lastState():String;
		
		
		/**
		 * 当前状态。
		 */
		function get state():String;
		
		/**
		 * @private
		 */
		function set state($value:String):void;
		
	}
}