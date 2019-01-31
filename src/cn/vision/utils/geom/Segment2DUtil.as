package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.geom.Line2D;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * 线段工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Segment2DUtil extends NoInstance
	{
		
		/**
		 * a，b线段的交点。
		 * 
		 * @param $a1:Point 线段a点1。
		 * @param $a2:Point 线段a点2。
		 * @param $b1:Point 线段b点1。
		 * @param $b2:Point 线段b点2。
		 * @param $limit:Boolean (default = false) 是否开启线段限制。
		 * 
		 */
		public static function intersect($a1:Point, $a2:Point, $b1:Point, $b2:Point, $limit:Boolean = true):Point
		{
			var x12:Number = $a1.x - $a2.x;
			var x34:Number = $b1.x - $b2.x;
			var y12:Number = $a1.y - $a2.y;
			var y34:Number = $b1.y - $b2.y;
			var s:Number = x12 * y34 - y12 * x34;
			if(s != 0)
			{
				var n1:Number = $a1.x * $a2.y - $a1.y * $a2.x;
				var n2:Number = $b1.x * $b2.y - $b1.y * $b2.x;
				var result:Point = new Point(
					(n1 * x34 - x12 * n2) / s, 
					(n1 * y34 - y12 * n2) / s);
				if($limit && 
					!Point2DUtil.between(result, $a1, $a2) || 
					!Point2DUtil.between(result, $b1, $b2)) result = null;
			}
			return result;
		}
		
		
		/**
		 * 线段ab上到点p距离最近的点。
		 * 
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * @param $p:Point 目标点。
		 * @param $limit:Boolean 是否开启线段限制。
		 * 
		 */
		public static function nearest($a:Point, $b:Point, $p:Point, $limit:Boolean = true):Point
		{
			var radian:Number = -Point2DUtil.angle($a, $b);
			var nb:Point = Point2DUtil.rotate($b, radian, $a);
			var re:Point = new Point(Point2DUtil.rotate($p, radian, $a).x, $a.y);
			if ($limit) re.x = MathUtil.clamp(re.x, $a.x, nb.x);
			return Point2DUtil.rotate(re, -radian, $a);
		}
		
		
		/**
		 * a，b线段是否相交。
		 * 
		 * @param $a1:Point 直线a第一个点。
		 * @param $a2:Point 直线a第二个点。
		 * @param $b1:Point 直线b第一个点。
		 * @param $b2:Point 直线b第二个点。
		 * @param $side:Boolean 是否包含边界点。
		 * 
		 * @return Boolean true为相交，false为不相交。
		 * 
		 */
		public static function nexus($a1:Point, $a2:Point, $b1:Point, $b2:Point, $side:Boolean = false):Boolean
		{
			var result1:int = side($a1, $a2, $b1) * side($a1, $a2, $b2);
			var result2:int = side($b1, $b2, $a1) * side($b1, $b2, $a2);
			return (result1 < 0 || ($side && result1 == 0)) && (result2 < 0 || ($side && result2 == 0));
		}
		
		
		/**
		 * 线段ab与目标点p的位置关系。
		 * 
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * @param $p:Point 目标点。
		 * 
		 * @return Boolean true表示目标点在直线上。
		 * 
		 */
		public static function nexusPoint($a:Point, $b:Point, $p:Point):Boolean
		{
			return side($a, $b, $p) == 0 && Point2DUtil.between($p, $a, $b);
		}
		
		
		/**
		 * 求线段ab的垂直平分线。
		 * 
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * 
		 * @return Line2D
		 * 
		 */
		public static function pebi($a:Point, $b:Point):Line2D
		{
			var c:Point = Point.interpolate($a, $b, .5);
			var k:Number = ($a.x - $b.x) / ($b.y - $a.y);
			return $a.y == $b.y ? new Line2D(1, 0, c.x) : new Line2D(k, -k * c.x + c.y);
		}
			
		
		/**
		 * 检测点p在线段ab的哪一侧，左返回-1，右返回1，直线上返回0。
		 * 
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * @param $p:Point 目标点。
		 * 
		 * @return int 
		 * 
		 */
		public static function side($a:Point, $b:Point, $p:Point):int
		{
			return MathUtil.normal(($b.y - $a.y) * ($p.x - $a.x) - ($b.x - $a.x) * ($p.y - $a.y), true);
		}
		
	}
}