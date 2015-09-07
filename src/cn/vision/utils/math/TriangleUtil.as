package cn.vision.utils.math
{
	import cn.vision.core.NoInstance;
	
	import flash.geom.Point;
	
	public final class TriangleUtil extends NoInstance
	{
		
		/**
		 * 
		 * 计算三角形中线交点。<br>
		 * 先求出2条中线，然后计算中线的交点。
		 * 
		 * @param $p1:Point 三角形的第一个顶点。
		 * @param $p2:Point 三角形的第二个顶点。
		 * @param $p3:Point 三角形的第三个顶点。
		 * 
		 * @return Point 中线交点。
		 * 
		 */
		
		public static function evaluatMidCrossing($p1:Point, $p2:Point, $p3:Point):Point
		{
			//y = (x - m1.x) * (p1.y - m1.y) / (p1.x - m1.x) + m1.y;
			//y = (x - m2.x) * (p2.y - m2.y) / (p2.x - m2.x) + m2.y;
			//(x - m1.x) * (p1.y - m1.y) / (p1.x - m1.x) + m1.y = (x - m2.x) * (p2.y - m2.y) / (p2.x - m2.x) + m2.y
			//(x - m1.x) * (p1.y - m1.y) / (p1.x - m1.x) = (x - m2.x) * (p2.y - m2.y) / (p2.x - m2.x) - (m1.y - m2.y)
			//(x - m1.x) * (p1.y - m1.y) * (p2.x - m2.x) = (x - m2.x) * (p2.y - m2.y) * (p1.x - m1.x) - (m1.y - m2.y) * (p2.x - m2.x) * (p1.x - m1.x)
			//(x - m2.x) * (p2.y - m2.y) * (p1.x - m1.x) - (x - m1.x) * (p1.y - m1.y) * (p2.x - m2.x) = (m1.y - m2.y) * (p2.x - m2.x) * (p1.x - m1.x)
			//(x - m2.x) * r1 - (x - m1.x) * r2 = r3;
			//r1 * x - m2.x * r1 - r2 * x + m1.x * r2 = r3;
			//(r1 - r2) * x - (m2.x * r1 - m1.x * r2) = r3;
			var m1:Point = Point.interpolate($p2, $p3, .5);
			var m2:Point = Point.interpolate($p1, $p3, .5);
			var r1:Number = ($p2.y - m2.y) * ($p1.x - m1.x);
			var r2:Number = ($p1.y - m1.y) * ($p2.x - m2.x);
			var r3:Number = ( m1.y - m2.y) * ($p2.x - m2.x) * ($p1.x - m1.x);
			var x:Number = (r3 + (m2.x * r1 - m1.x * r2)) / (r1 - r2);
			var y:Number = (x - m1.x) * ($p1.y - m1.y) / ($p1.x - m1.x) + m1.y;
			return new Point(x, y);
		}
		
	}
}