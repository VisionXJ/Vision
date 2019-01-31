package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * 点工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Point2DUtil extends NoInstance
	{
		
		/**
		 * 获取a到b所构成的线段与X轴的夹角，弧度为单位。
		 * 
		 * @param $a:Point 点1。
		 * @param $b:Point 点2。
		 * 
		 */
		public static function angle($a:Point, $b:Point):Number
		{
			return Math.atan2($b.y - $a.y, $b.x - $a.x);
		}
		
		
		/**
		 * 检查点p的坐标范围是否在ab两点之间。
		 * 
		 * @param $p:Point 点P。
		 * @param $a:Point 点a。
		 * @param $b:Point 点b。
		 * @param $accuracy:uint (default = 0) 为0表示不限制精度。
		 * 
		 * @return Boolean true为在ab之间。
		 * 
		 */
		public static function between($p:Point, $a:Point, $b:Point, $accurency:uint = 0):Boolean
		{
			return  MathUtil.between(
						MathUtil.float($p.x, $accurency), 
						MathUtil.float($a.x, $accurency), 
						MathUtil.float($b.x, $accurency)) && 
					MathUtil.between(
						MathUtil.float($p.y, $accurency), 
						MathUtil.float($a.y, $accurency), 
						MathUtil.float($b.y, $accurency));
		}
		
		
		/**
		 * 对点p进行范围约束，并返回一个新的点，该点在a,b所构成的矩形范围内。
		 * 
		 * @param $p:Point 点p。
		 * @param $a:Point ab范围约束点a。
		 * @param $b:Point ab范围约束点b。
		 * 
		 */
		public static function clamp($p:Point, $a:Point, $b:Point):Point
		{
			return new Point(MathUtil.clamp($p.x, $a.x, $b.x), MathUtil.clamp($p.y, $a.y, $b.y));
		}
		
		
		/**
		 * 检测两个点是否近似相等。
		 * 
		 * @param $a:Point 点a。
		 * @param $b:Point 点b。
		 * @param $accuracy:uint (default = -1) 需要判断的精度，0表示四舍五入整数比较。
		 * 
		 */
		public static function equal($a:Point, $b:Point, $accuracy:int = -1):Boolean
		{
			return MathUtil.equal($a.x, $b.x, $accuracy) && MathUtil.equal($a.y, $b.y, $accuracy);
		}
		
		
		/**
		 * $p点在某角度平移一段距离得到的新点。
		 * 
		 * @param $p:Point 点p。
		 * @param $radian:Number 与X轴的夹角，弧度为单位。
		 * @param $length:Number 平移的距离。
		 * 
		 * @return Point 得到的新点。
		 * 
		 */
		public static function offset($p:Point, $radian:Number, $length:Number):Point
		{
			return $p.add(Point.polar($length, $radian));
		}
			
		
		/**
		 * $p绕$o旋转$radian之后的新点。
		 * 
		 * @param $p:Point 点p。
		 * @param $radian:Number 旋转的弧度。
		 * @param $o:Point 围绕点o。
		 * 
		 * @return Point 得到的新点。
		 * 
		 */
		public static function rotate($p:Point, $radian:Number, $o:Point = null):Point
		{
			$o = $o || new Point;
			var result:Point = new Point;
			const cos:Number = Math.cos($radian);
			const sin:Number = Math.sin($radian);
			const sbx:Number = $p.x - $o.x;
			const sby:Number = $p.y - $o.y;
			result.setTo(
				sbx * cos - sby * sin + $o.x, 
				sbx * sin + sby * cos + $o.y);
			return result;
		}
		
		
		/**
		 * 给定2点求斜率。
		 * 
		 * @param $a:Point 点1。
		 * @param $b:Point 点2。
		 * 
		 * @return Number 斜率。
		 * 
		 */
		public static function slope($a:Point, $b:Point):Number
		{
			return ($b.y - $a.y) / ($b.x - $a.x);
		}
		
		
		/**
		 * @private
		 */
		vs static function normal($v:Number, $o:Boolean = false):int
		{
			return $v < 0 ? -1 : ($o ? ($v == 0 ? 0 : 1) : 1);
		}
		
	}
}