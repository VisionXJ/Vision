package cn.vision.consts
{
	
	/**
	 * 
	 * <code>ConstsCommandPriority</code>定义命令优先级常量，只有并行命令队列支持优先级。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	
	public final class CommandPriorityConsts extends NoInstance
	{
		
		/**
		 * 
		 * 较高优先级，加入队列时会加在队列开头，当前命令执行完毕后执行。
		 * 
		 */
		
		public static const HIGH:uint = 1;
		
		
		/**
		 * 
		 * 最高优先级，会立即执行。
		 * 
		 */
		
		public static const HIGHEST:uint = 2;
		
		
		/**
		 * 
		 * 普通优先级，加入队列时会加在队列末。
		 * 
		 */
		
		public static const NORMAL:uint = 0;
		
	}
}