package cn.vision.consts
{
	
	/**
	 * 
	 * 定义了一些数学常量。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	
	
	public final class MathConsts extends Consts
	{
		
		/**
		 * 
		 * loge3，以自然数为底的3的对数。
		 * 
		 * @default 1.0986122886681096913952452369225
		 * 
		 */
		
		public static const LN3:Number = 1.0986122886681096913952452369225;
		
		
		/**
		 * @private
		 * 定义1/loge3数值。
		 */
		vs static const LN3_1:Number = 0.91023922662683739361424016573613;
		
		/**
		 * @private
		 * 定义角度转弧度所乘数值。
		 */
		vs static const ANGLE_MOD_PI:Number = 57.295779513082320876798154814105;
		
		/**
		 * @private
		 * 定义弧度转角度所乘数值。
		 */
		vs static const PI_MOD_ANGLE:Number = 0.01745329251994329576923690768489;
		
	}
}