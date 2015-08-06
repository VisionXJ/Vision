package cn.vision.pattern.core
{
	
	/**
	 * 
	 * 是所有状态的基类，用于描述实例的状态，所做的操作。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.StringUtil;
	
	
	public class State extends VSObject
	{
		
		/**
		 * 
		 * <code>State</code>构造函数。
		 * 
		 */
		
		public function State()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize():void
		{
			vs::title = StringUtil.lowercaseInitials(className);
		}
		
		
		/**
		 * 
		 * 激活当前状态。
		 * 
		 */
		
		public function active():void
		{
			
		}
		
		
		/**
		 * 
		 * 冻结当前状态。
		 * 
		 */
		
		public function freeze():void
		{
			
		}
		
		
		/**
		 * 
		 * 状态的标题，每种类的状态标题应该唯一。
		 * 
		 */
		public function get title():String
		{
			return vs::title;
		}
		
		
		/**
		 * @private
		 */
		vs var title:String;
		
	}
}