package cn.vision.managers
{
	
	/**
	 * 
	 * 状态类管理器。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.pattern.core.State;
	import cn.vision.utils.ClassUtil;
	
	
	public final class StateManager extends Manager
	{
		
		/**
		 * 
		 * 注册一种状态类。
		 * 
		 */
		
		public static function registState($name:String, $state:Class):Boolean
		{
			return (states[$name] || (! ClassUtil.validateSubclass($state, State)))
				? false 
				: states[$name] = $state;
		}
		
		
		/**
		 * 
		 * 删除一种状态类。
		 * 
		 */
		
		public static function removeState($name:String):Boolean
		{
			var result:Boolean = states[$name];
			if (result) delete states[$name];
			return result;
		}
		
		
		/**
		 * 
		 * 获取一种状态类。
		 * 
		 */
		
		public static function retrieveState($name:String):State
		{
			return states[$name];
		}
		
		
		/**
		 * @private
		 */
		private static const states:Map = new Map;
		
	}
}