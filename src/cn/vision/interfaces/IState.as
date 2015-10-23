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
	
	import cn.vision.pattern.core.State;
	

	public interface IState
	{
		
		/**
		 * 
		 * 注册一种状态。
		 * 
		 * @param $name:String 名称标识。
		 * @param $state:State 对应的状态。
		 * 
		 * @return State 返回注册成功的状态实例。
		 * 
		 */
		
		//function registState($name:String, $state:State):State;
		
		
		/**
		 * 
		 * 移除一种状态。
		 * 
		 * @param $name:String 状态名称标识。
		 * 
		 * @return Boolean true为移除成功，false为移除失败，表示不包含这种状态。
		 * 
		 */
		
		//function removeState($name:String):Boolean;
		
		
		/**
		 * 
		 * 获取状态。
		 * 
		 * @param $state:* 可以是要移除状态类别的完全限定名，状态类别Class。
		 * 
		 * @return State 返回获取的状态实例。
		 * 
		 */
		
		//function retrieveState($name:String):State;
		
		
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