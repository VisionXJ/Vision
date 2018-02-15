package cn.vision.consts
{
	
	import cn.vision.consts.Consts;
	
	
	/**
	 * 定义了命令状态常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class CommandStateConsts extends Consts
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
		
		
		/**
		 * 命令结束状态，此时命令已运行完毕。
		 * 
		 * @default finished
		 * 
		 */
		public static const FINISHED:String = "finished";
		
	}
}