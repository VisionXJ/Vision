package cn.vision.consts
{
	
	import cn.vision.consts.Consts;
	
	
	/**
	 * 定义了UI状态常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class UIStateConsts extends Consts
	{
		
		/**
		 * UI初始化状态，此时UI开始初始化。
		 * 
		 * @default initialize
		 * 
		 */
		public static const INITIALIZE:String = "initialize";
		
		
		/**
		 * UI准备完毕状态，此时UI已经可以使用。
		 * 
		 * @default ready
		 * 
		 */
		public static const READY:String = "ready";
		
	}
}