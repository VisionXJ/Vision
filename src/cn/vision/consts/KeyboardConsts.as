package cn.vision.consts
{
	
	/**
	 * 定义键盘功能键控制常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class KeyboardConsts extends Consts
	{
		
		/**
		 * 指定不使用功能键。
		 * 
		 * @default 0
		 * 
		 */
		public static const NONE:uint = 0;
		
		
		/**
		 * 指定使用Shift键。<br>
		 * 该值可以和其他功能键用逻辑或符号 "|" 进行组合，如：
		 * KeyboardConsts.SHIFT|KeyboardConsts.CTRL。
		 * 
		 * @default 1
		 * 
		 */
		public static const SHIFT:uint = 1;
		
		
		/**
		 * 指定使用Ctrl键。<br>
		 * 该值可以和其他功能键用逻辑或符号 "|" 进行组合，如：
		 * KeyboardConsts.CTRL|KeyboardConsts.SHIFT。
		 * 
		 * @default 2
		 * 
		 */
		public static const CTRL:uint = 2;
		
		
		/**
		 * 指定使用Alt键。<br>
		 * 该值可以和其他功能键用逻辑或符号 "|" 进行组合，如：
		 * KeyboardConsts.ALT|KeyboardConsts.SHIFT.
		 * 
		 * @default 4
		 * 
		 */
		public static const ALT:uint = 4;
		
	}
}