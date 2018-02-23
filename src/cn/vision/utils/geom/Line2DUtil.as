package cn.vision.utils.geom
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.geom.geom2d.Line2D;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 2D直线工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Line2DUtil extends NoInstance
	{
		
		/**
		 * 点到直线距离。
		 * 
		 * @param $line:Line2D 直线。
		 * @param $point:Point 点。
		 * @param $signed:Boolean (default = false) 是否带符号，符号与点在直线的哪一侧有关。
		 * 
		 * @return Number
		 * 
		 * @see cn.vision.utils.geom.Line2DUtil.side()
		 * 
		 */
		public static function distance($line:Line2D, $point:Point, $signed:Boolean = false):Number
		{
			var result:Number = vs::normal($line.B) * vs::formula(
				$line, $point.x, $point.y) / vs::caculateA2_B2($line);
			return $signed ? result : Math.abs(result);
		}
		
		
		/**
		 * 获取直线上给定范围的两个点。
		 * 
		 * @param $line:Line 相关的直线。
		 * @param $bounds:Rectangle (default = null) 矩形范围，<br>
		 * 如果参数为空，则返回与坐标轴的交点；<br>
		 * 如果直线经过该举行范围，则返回矩形范围边沿的点。
		 * 
		 * @return Array 一个或两个点的集合。
		 * 
		 */
		public function listP2($l:Line2D, $b:Rectangle = null):Array
		{
			var result:Array = [], n:Number, p:Number;
			const CB:Number = -$l.C / $l.B;
			const CA:Number = -$l.C / $l.A;
			if ($b)
			{
				if ($l.A == 0)
				{
					if (MathUtil.between(CB, $b.top, $b.bottom))
					{
						result[0] = new Point($b.left , CB);
						result[1] = new Point($b.right, CB);
					}
				}
				if ($l.B == 0)
				{
					if (MathUtil.between(CA, $b.left, $b.right))
					{
						result[0] = new Point(CA, $b.top);
						result[1] = new Point(CA, $b.bottom);
					}
				}
				else
				{
					n = -($b.left * $l.A + $l.C) / $l.B;
					if (MathUtil.between(n, $b.top, $b.bottom)) 
						ArrayUtil.push(result, new Point($b.left, n));
					n = -($b.right * $l.A + $l.C) / $l.B;
					if (MathUtil.between(n, $b.top, $b.bottom)) 
						ArrayUtil.push(result, new Point($b.right, n));
					n = -($b.top * $l.B + $l.C) / $l.A;
					if (MathUtil.between(n, $b.left, $b.right)) 
						ArrayUtil.push(result, new Point($b.top, n));
					n = -($b.bottom * $l.B + $l.C) / $l.A;
					if (MathUtil.between(n, $b.left, $b.right)) 
						ArrayUtil.push(result, new Point($b.bottom, n));
				}
			}
			else
			{
				if ($l.A == 0)
				{
					result[0] = new Point(0, CB);
					result[1] = new Point(1, CB);
				}
				else if ($l.B == 0)
				{
					result[0] = new Point(CA, 0);
					result[1] = new Point(CA, 1);
				}
				else
				{
					result[0] = new Point(0, CB);
					result[1] = new Point(CA, 0);
				}
			}
			return result;
		}
		
		
		/**
		 * 直线上距离指定点最近的点。
		 * 
		 * @param $line:Line2D 直线。
		 * @param $point:Point 指定点。
		 * 
		 * @return Point 直线上距离指定点最近的点。
		 * 
		 */
		public static function nearest2Point($line:Line2D, $point:Point):Point
		{
			var a2b2:Number = vs::caculateA2_B2($line);
			var plus:Number = $line.B * $point.x - $line.A * $point.y;
			return new Point(
				( $line.B * plus - $line.A * $line.C) / a2b2, 
				(-$line.A * plus - $line.B * $line.C) / a2b2);
		}
		
		
		/**
		 * 直线与点的位置关系。<br>
		 * 直线下方或左方($line.B=0时)：-1；<br>
		 * 直线上方或右方($line.B=0时)：1；<br>
		 * 直线上：0。
		 * 
		 * @param $l:Line2D 直线。
		 * @param $p:Point 点。
		 * 
		 * @return int 
		 * 
		 */
		public static function nexusPoint($l:Line2D, $p:Point):int
		{
			return vs::normal(vs::normal($l.B) * vs::formula($l, $p.x, $p.y), true);
		}
		
		
		/**
		 * 直线与直线的位置关系。<br>
		 * -1：平行，0：重合，1：相交。
		 * 
		 * @param $l1:Line2D 直线1。
		 * @param $l2:Line2D 直线2。
		 * 
		 * @return int 
		 * 
		 */
		public static function nexusLine($l1:Line2D, $l2:Line2D):int
		{
			return $l1.B == 0 && $l2.B == 0
				? ($l1.C / $l1.A == $l2.C / $l2.A ? 0 : -1)
				: ($l1.k == $l2.k ? ($l1.b == $l2.b ? 0 : -1) : 1);
		}
		
		
		/**
		 * 直线与线段的位置关系。<br>
		 * -1：不相交，0：重合，1：相交。
		 * 
		 * @param $l:Line2D 直线。
		 * @param $p1:Point 线段起点。
		 * @param $p2:Point 线段终点。
		 * 
		 * @return int
		 * 
		 */
		public static function nexusSegment($l:Line2D, $p1:Point, $p2:Point):int
		{
			var n1:int = vs::formula($l, $p1.x, $p1.y);
			var n2:int = vs::formula($l, $p2.x, $p2.y);
			var ns:int = vs::normal(n1 * n2, true);
			switch (ns)
			{
				case 1: case -1: return -ns;
				default: return n1 == n2 ? 0 : 1;
			}
		}
		
		
		/**
		 * 两直线交点，只有当两直线相交时才返回一个Point，否则返回null。
		 * 
		 * @param $l1:Line2D 直线1。
		 * @param $l2:Line2D 直线2。
		 * 
		 * @return Point 
		 * 
		 */
		public static function intersectLine($l1:Line2D, $l2:Line2D):Point
		{
			var d:Number = $l1.A * $l2.B - $l2.A * $l1.B;
			return d == 0 ? null : new Point(
				($l1.B * $l2.C - $l2.B * $l1.C) / d, 
				($l2.A * $l1.C - $l1.A * $l2.C) / d);
		}
		
		
		/**
		 * 直线与线段的交点，如果不相交，返回null。
		 * 
		 * @param $l:Line2D 直线。
		 * @param $p1:Point 线段起点。
		 * @param $p2:Point 线段终点。
		 * 
		 */
		public static function intersectSegment($l:Line2D, $p1:Point, $p2:Point):Point
		{
			var p:Point = intersectLine($l, new Line2D($p1, $p2));
			if (p && Point2DUtil.between(p, $p1, $p2)) return p;
			return null;
		}
		
		
		vs static function caculateA2_B2($line:Line2D):Number
		{
			return Math.sqrt($line.A * $line.A + $line.B * $line.B);
		}
		
		vs static function formula($line:Line2D, $x:Number, $y:Number):Number
		{
			return $line.A * $x + $line.B * $y + $line.C;
		}
		
		vs static function normal($value:Number, $zero:Boolean = false):int
		{
			return $value < 0 ? -1 : ($zero ? ($value == 0 ? 0 : 1) : 1);
		}
		
	}
}