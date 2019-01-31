package cn.vision.utils
{
	
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.geom.Point;
	
	/**
	 * 定义了一些常用数学函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class MathUtil extends NoInstance
	{
		
		/**
		 * 计算并返回由参数 $value 指定的数字的绝对值。
		 * 
		 * @param $value 要返回绝对值的数字。
		 * 
		 * @return Number 指定参数的绝对值。
		 * 
		 */
		public static function abs($value:Number):Number
		{
			return $value < 0 ? -$value : $value;
		}
		
		
		/**
		 * 判断$value是否介于$num1和$num2之间。
		 * 
		 * @param $value:Number 需要被判定的数。
		 * @param $num1:Number 第一个数。
		 * @param $num2:Number 第二个数。
		 * 
		 * @return Boolean true为在两者之间。
		 * 
		 */
		public static function between($value:Number, $num1:Number, $num2:Number):Boolean
		{
			var max:Number = Math.max($num1, $num2);
			return max == $value || (($num1 <= $value) != ($num2 <= $value));
		}
		
		
		/**
		 * 返回与$value更近的数，如果$min和$max与$value同样近，则优先返回$min。
		 * 
		 * @param $value:Number 要比较的值。
		 * @param $num1:Number 最小值。
		 * @param $num2:Number 最大值。
		 * 
		 * @return 与$value更近的值。
		 * 
		 */
		public static function near($value:Number, $num1:Number, $num2:Number):Number
		{
			return abs($num1 - $value) > abs($num2 - $value) ? $num2 : $num1;
		}
		
		
		/**
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
		 * @param $num1:Number 限制区间第一个数，不区分前后顺序。
		 * @param $num2:Number 限制区间第一个数，不区分前后顺序。
		 * 
		 * @return Number 返回的数值。
		 * 
		 */
		
		public static function clamp($value:Number, $num1:Number, $num2:Number):Number
		{
			var min:Number = $num1 < $num2 ? $num1 : $num2;
			var max:Number = $num1 < $num2 ? $num2 : $num1;
			return $value < min ? min : ($value > max ? max : $value);
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
		 * @param $accuracy:int (default = -1) 需要判断的精度，0表示四舍五入整数比较，-1表示绝对相等。
		 * 
		 * @return Boolean
		 * 
		 */
		
		public static function equal($a:Number, $b:Number, $accuracy:int = -1):Boolean
		{
			var f:Number = Math.pow(10, $accuracy);
			return ($accuracy==-1)?($a==$b):(f == 1) ? (Math.round($a) == Math.round($b)) : (int(abs($a - $b) * f) == 0);
		}
		
		
		
		/**
		 * 小数点后保留多少位有效数字，后面的数值进行四舍五入。
		 * 
		 * @param $value:Number 要操作的数值。
		 * @param $accuracy:uint (default = 0) 小数点后保留的位数，为0时不做约束。
		 * 
		 * @return Number
		 * 
		 */
		public static function float($value:Number, $accuracy:uint = 0):Number
		{
			var plus:Number = Math.pow(10, $accuracy);
			return Math.round($value * plus) / plus;
		}
		
		
		/**
		 * 判断是否为偶数。
		 * 
		 * @param $value:int 判断的数值。
		 * 
		 * @return Boolean true为偶数，false为奇数。
		 * 
		 */
		public static function even($value:int):Boolean
		{
			return !($value & 1);
		}
		
		
		/**
		 * 验证一个数是否为整数。
		 * 
		 * @param $value:Number 判断的数值。
		 * 
		 * @return Boolean true为整数，false不是整数。
		 * 
		 */
		public static function integer($value:Number):Boolean
		{
			return $value % 1 == 0;
		}
		
		
		/**
		 * 求以2为底的对数。
		 * 
		 * @param $value:Number
		 * 
		 * @return Number
		 * 
		 */
		public static function log2($value:Number):Number
		{
			return Math.log($value) * MathConsts.vs::LN2_1;
		}
		
		
		/**
		 * 求以3为底的对数。
		 * 
		 * @param $value:Number 
		 * 
		 * @return Number
		 * 
		 */
		public static function log3($value:Number):Number
		{
			return Math.log($value) * MathConsts.vs::LN3_1;
		}
		
		
		/**
		 * 求以$base为底数的对数。
		 * 
		 * @param $value:Number
		 * 
		 * @return Number
		 * 
		 */
		public static function log($value:Number, $base:Number):Number
		{
			return Math.log($value) / Math.log($base);
		}
		
		
		/**
		 * 整数求余数。
		 * 
		 * @param $numerator:int 分子。
		 * @param $divisor:int 除数。
		 * 
		 * @return int 余数。
		 * 
		 */
		public static function modulo($numerator:int, $divisor:int):int
		{
			return $numerator & ($divisor - 1);
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
		
		public static function moduloAngle($angle:Number, $radian:Boolean = false):Number
		{
			var m:Number = $radian ? Math.PI * 2 : 360;
			$angle = $angle % m;
			$angle =($angle < 0) ? m + $angle : $angle;
			return $angle;
		}
		
		
		/**
		 * 将数值单位化成1，0，-1的单位整数。
		 * 
		 * @param $value:Number 要单位化的数值。
		 * @param $zero:Boolean (default = false) 是否包含0。
		 * 
		 */
		public static function normal($value:Number, $zero:Boolean = false):int
		{
			return $value < 0 ? -1 : ($zero ? ($value == 0 ? 0 : 1) : 1);
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
		
		
		/**
		 *  $value∈[min, max]是否成立。
		 * 
		 * @param $value:Number 要检测的数值。
		 * @param $min:Number 区间最小值。
		 * @param $max:Number 区间最大值。
		 * @param $left:Boolean (default = false) 区间左侧开闭情况，true为闭，false为开。
		 * @param $right:Boolean (default = false) 区间右侧开闭情况，true为闭，false为开。
		 * 
		 */
		public static function range($value:Number, $min:Number, $max:Number, $left:Boolean = true, $right:Boolean = false):Boolean
		{
			return  ($value > $min || ($left  && $value == $min)) && 
					($value < $max || ($right && $value == $max));
		}
		
		/**
		 * $value是否等于0
		 * 
		 * @param $value:Number 要检测的数值。
		 * @param $precision:Number 精度。
		 * 
		 */		
		public static function isZero($value:Number, $precision:Number = 0.001):Boolean
		{
			return abs($value) < $precision;
		}
		
	}
}