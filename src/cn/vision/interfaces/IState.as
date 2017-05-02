package cn.vision.interfaces
{
	
	/**
	 * 
	 * 状态模式接口。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	public interface IState
	{
		
		/**
		 * 
		 * 上一个状态。
		 * 
		 */
		
		function get lastState():String;
		
		
		/**
		 * 
		 * 当前状态。
		 * 
		 */
		
		function get state():String;
		
		/**
		 * @private
		 */
		function set state($value:String):void;
		
	}
}