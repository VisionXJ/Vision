package cn.vision.consts.state
{
	
	/**
	 * 
	 * 定义了命令状态常量。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.Consts;
	
	
	public final class CommandStateConsts extends Consts
	{
		
		/**
		 * 
		 * 命令初始化状态，此时命令开始初始化。
		 * 
		 */
		
		public static const INITIALIZE:String = "initialize";
		
		
		/**
		 * 
		 * 命令闲置状态，此时命令初始化完毕，尚未开始运行。
		 * 
		 */
		
		public static const IDLE:String = "idle";
		
		
		/**
		 * 
		 * 命令运行状态，此时命令正在运行中。
		 * 
		 */
		
		public static const RUNNING:String = "running";
		
		
		/**
		 * 
		 * 命令结束状态，此时命令已运行完毕。
		 * 
		 */
		
		public static const FINISHED:String = "finished";
		
	}
}