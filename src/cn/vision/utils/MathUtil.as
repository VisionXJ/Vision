package cn.vision.utils
{
	
	/**
	 * 
	 * <code>MathUtil</code>定义了一些常用数学函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.geom.Point;
	
	
	public final class MathUtil extends NoInstance
	{
		
		/**
		 * 
		 * 角度转弧度。
		 * 
		 * @param $angle:Number 角度。
		 * 
		 * @return Number 弧度。
		 * 
		 */
		
		public static function angleToRadian($angle:Number):Number
		{
			return MathConsts.vs::PI_MOD_ANGLE * $angle;
		}
		
		
		/**
		 * 
		 * 范围取值。
		 * 
		 * @param $value:Number 需要限制的数值。
		 * @param $min:Number 最小值。
		 * @param $max:Number 最大值。
		 * 
		 * 
		 * @return Number 返回的数值。
		 * 
		 */
		
		public static function clamp($value:Number, $min:Number, $max:Number):Number
		{
			return Math.min(Math.max($value, $min), $max);
		}
		
		
		/**
		 * 
		 * 比较2个数值大小。
		 * 
		 * @param $a:Number 第一个数值。
		 * @param $b:Number 第二个数值。
		 * 
		 * @return int 值为 -1，$date1 小于 $date2；值为 0，$date1 等于 $date2；值为1，$date1 大于 $date2。
		 * 
		 */
		
		public static function compare($a:Number, $b:Number):int
		{
			return $a < $b ? -1 : ($a > $b ? 1 : 0);
		}
		
		
		/**
		 * 
		 * 判断两个数值是否相等。
		 * 
		 * @param $a:Number 第一个数值。
		 * @param $b:Number 第二个数值。
		 * @param $accuracy:uint (default = 0) 需要判断的精度，0表示则不规范精度。
		 * 
		 * @return Boolean
		 * 
		 */
		
		public static function equal($a:Number, $b:Number, $accuracy:uint = 0):Boolean
		{
			var f:Number = Math.pow(10, $accuracy);
			return (f == 1) ? ($a == $b) : (Math.floor(Math.abs($a - $b) * f) == 0);
		}
		
		
		/**
		 * 
		 * 求以2为底的对数。
		 * 
		 * @param $value:Number
		 * 
		 * @return Number
		 * 
		 */
		
		public static function log2($value:Number):Number
		{
			return Math.log($value) / Math.LN2;
		}
		
		
		/**
		 * 
		 * 求以3为底的对数。
		 * 
		 * @param value
		 * 
		 * @return Number
		 * 
		 */
		
		public static function log3($value:Number):Number
		{
			return Math.log($value) / MathConsts.LN3;
		}
		
		
		/**
		 * 
		 * 把角度限制在大等于0，小于360度之间。
		 * 
		 * @param $angle:Number 角度。
		 * 
		 * @return Number 转换后的角度。
		 * 
		 */
		
		public static function moduloAngle($angle:Number):Number
		{
			$angle = $angle % 360;
			return  ($angle < 0) ? 360 + $angle : $angle;
		}
		
		
		/**
		 * 
		 * 弧度转角度。
		 * 
		 * @param $radian:Number 弧度。
		 * 
		 * @return Number 角度。
		 * 
		 */
		
		public static function radianToAngle($radian:Number):Number
		{
			return MathConsts.vs::ANGLE_MOD_PI * $radian;
		}
		
	}
}