package cn.vision.consts
{
	
	import cn.vision.consts.Consts;
	
	
	/**
	 * 定义了队列状态常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class QueueStateConsts extends Consts
	{
		
		/**
		 * 命令初始化状态，此时命令开始初始化。
		 * 
		 * @default initialize
		 * 
		 */
		public static const INITIALIZE:String = "initialize";
		
		
		/**
		 * 命令闲置状态，此时命令初始化完毕，尚未开始运行。
		 * 
		 * @default idle
		 * 
		 */
		public static const IDLE:String = "idle";
		
		
		/**
		 * 命令运行状态，此时命令正在运行中。
		 * 
		 * @default running
		 * 
		 */
		public static const RUNNING:String = "running";
		
	}
}