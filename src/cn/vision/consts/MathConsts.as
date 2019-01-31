package cn.vision.consts
{
	
	import cn.vision.core.vs;
	
	/**
	 * 定义了一些数学常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class MathConsts extends Consts
	{
		
		/**
		 * loge3，以自然数为底的3的对数。
		 * 
		 * @default 1.0986122886681096913952452369225
		 * 
		 */
		public static const LN3:Number = 1.0986122886681096913952452369225;
		
		/**
		 * PI * 2，360度的弧度表示方式。
		 * 
		 * @default 6.283185307179586476925286766559
		 * 
		 */
		public static const PI2:Number = 6.283185307179586476925286766559;
		
		/**
		 * PI，180度的弧度表示方式。
		 * 
		 * @default 3.1415926535897932384626433832795
		 * 
		 */
		public static const PI:Number = 3.1415926535897932384626433832795;
		
		/**
		 * PI * 3 / 4，135度的弧度表示方式。
		 * 
		 * @default 2.3561944901923449288469825374596
		 * 
		 */
		public static const PI3_4:Number = 2.3561944901923449288469825374596;
		
		/**
		 * PI / 2，90度的弧度表示方式。
		 * 
		 * @default 1.5707963267948966192313216916398
		 * 
		 */
		public static const PI_2:Number = 1.5707963267948966192313216916398;
		
		/**
		 * PI / 4，45度的弧度表示方式。
		 * 
		 * @default 0.78539816339744830961566084581988
		 * 
		 */
		public static const PI_4:Number = 0.78539816339744830961566084581988;
		
		/**
		 * @private
		 * 定义1/loge2数值。
		 */
		vs static const LN2_1:Number = 1.4426950408889634073599246810019;
		
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
		
		/**
		 * @private
		 * 定义获取颜色深浅所需的乘积。
		 */
		vs static const COLOR_MOD:Number = 0.00390625;
		
	}
}