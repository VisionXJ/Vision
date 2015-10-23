package cn.vision.consts.state
{
	
	/**
	 * 
	 * 定义了UI状态常量。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.Consts;
	
	
	public final class UIStateConsts extends Consts
	{
		
		/**
		 * 
		 * UI初始化状态，此时UI开始初始化。
		 * 
		 */
		
		public static const INITIALIZE:String = "initialize";
		
		
		/**
		 * 
		 * UI准备完毕状态，此时UI已经可以使用。
		 * 
		 */
		
		public static const READY:String = "ready";
		
	}
}