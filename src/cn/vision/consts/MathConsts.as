package cn.vision.consts
{
	
	/**
	 * 
	 * <code>ConstsMath</code>定义了一些数学常量。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	
	public final class MathConsts extends NoInstance
	{
		
		/**
		 * 
		 * loge3，以自然数为底的3的对数，值为1.0986122886681098。
		 * 
		 */
		
		public static const LN3:Number = 1.0986122886681098;
		
		
		/**
		 * @private
		 */
		vs static const ANGLE_MOD_PI:Number = 57.295779513082320876798154814105;
		
		/**
		 * @private
		 */
		vs static const PI_MOD_ANGLE:Number = 0.01745329251994329576923690768489;
		
	}
}