package cn.vision.utils.math
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.geom.plane.Line;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * 直线工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class LineUtil extends NoInstance
	{
		
		/**
		 * 直线平移。
		 * 
		 * @param $line:Line 要平移的直线。
		 * @param $x:Number x方向平移。
		 * @param $y:Number y方向平移。
		 * @param $clone:Boolean 是否复制新对象，还是直接改变直线本身。
		 * 
		 */
		public static function move($line:Line, $x:Number, $y:Number, $clone:Boolean = true):Line
		{
			var matrix:Matrix = new Matrix;
			matrix.translate($x, $y);
			return $line.transform(matrix, $clone);
		}
		
		
		/**
		 * 直线旋转。
		 * 
		 * @param $line:Line 要缩放的直线。
		 * @param $radian:Number 以弧度为单位的旋转角度。
		 * @param $clone:Boolean 是否复制新对象，还是直接改变直线本身。
		 * 
		 */
		public static function rotate($line:Line, $radian:Number, $clone:Boolean = true):Line
		{
			var matrix:Matrix = new Matrix;
			matrix.rotate($radian);
			return $line.transform(matrix, $clone);
		}
		
		
		/**
		 * 直线缩放。
		 * 
		 * @param $line:Line 要缩放的直线。
		 * @param $x:Number x方向缩放。
		 * @param $y:Number y方向缩放。
		 * @param $clone:Boolean 是否复制新对象，还是直接改变直线本身。
		 * 
		 */
		public static function scale($line:Line, $scaleX:Number, $scaleY:Number, $clone:Boolean = true):Line
		{
			var matrix:Matrix = new Matrix;
			matrix.scale($scaleX, $scaleY);
			return $line.transform(matrix, $clone);
		}
		
		
		/**
		 * 判断a, b条线段是否相交。
		 * 
		 * @param $a1:Point 直线a第一个点。
		 * @param $a2:Point 直线a第二个点。
		 * @param $b1:Point 直线b第一个点。
		 * @param $b2:Point 直线b第二个点。
		 * 
		 * @return Boolean true为相交，false为不相交。
		 * 
		 */
		public static function collision($a1:Point, $a2:Point, $b1:Point, $b2:Point, $side:Boolean = false):Boolean
		{
			var result1:int = side($a1, $a2, $b1) * side($a1, $a2, $b2);
			var result2:int = side($b1, $b2, $a1) * side($b1, $b2, $a2);
			return result1 < 0 || ($side && result1 == 0) || result2 < 0 || ($side && result2 == 0);
		}
		
		
		/**
		 * 获取平面直线上的点集合。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 结束点。
		 * @param $seg:Number 直线段。
		 * @param $front:Number 开始距离。
		 * @param $back:Number 结束距离。
		 * 
		 * @return Vector.<Point> 点集合。
		 * 
		 */
		public static function getPoints($start:Point, $end:Point, $seg:Number, $front:Number = 0, $back:Number = 0):Vector.<Point>
		{
			var dis:Number = Point.distance($start, $end);
			var per:Number = $seg / (dis - $front - $back);
			var fro:Number = $front / dis;
			var bac:Number = (1 - $back / dis);
			var points:Vector.<Point> = new Vector.<Point>;
			if (0 < per && per <= 1)
			{
				for (var tmp:Number = fro; tmp < bac; tmp += per)
					ArrayUtil.push(points, Point.interpolate($end, $start, tmp));
			}
			return points;
		}
		
		
		/**
		 * 获取三维空间直线上的点集合。
		 * 
		 * @param $start:Vector3D 起始点。
		 * @param $end:Vector3D 结束点。
		 * @param $seg:Number 直线段。
		 * @param $front:Number 开始距离。
		 * @param $back:Number 结束距离。
		 * 
		 * @return Vector.<Vector3D> 点集合。
		 * 
		 */
		public static function getVector3Ds($start:Vector3D, $end:Vector3D, $seg:Number, $front:Number = 0, $back:Number = 0):Vector.<Vector3D>
		{
			const dis:Number = Vector3D.distance($start, $end);
			const per:Number = $seg / (dis - $front - $back);
			const fro:Number = $front / dis;
			const bac:Number = (1 - $back / dis);
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			if (0 < per && per <= 1)
			{
				for (var tmp:Number = fro; tmp < bac; tmp += per)
					ArrayUtil.push(points, Vector3DUtil.interpolate($end, $start, tmp));
			}
			return points;
		}
		
		
		/**
		 * 求两直线的交点。
		 * 
		 * @param $a1:Point 线段A起始点。
		 * @param $a2:Point 线段A终止点。
		 * @param $b1:Point 线段B起始点。
		 * @param $b1:Point 线段B终止点。
		 * @param $segment:Boolean (default = false) 是否启用线段限制，
		 * 
		 */
		public static function intersection($a1:Point, $a2:Point, $b1:Point, $b2:Point, $segment:Boolean = false):Point
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
				var n3:Number = (n1 * x34 - x12 * n2) / s;
				var n4:Number = (n1 * y34 - y12 * n2) / s;
				var result:Point = new Point(n3, n4);
				if($segment)
				{
					if (!MathUtil.between(n3, $a1.x, $a2.x) ||
						!MathUtil.between(n3, $b1.x, $b2.x) || 
						!MathUtil.between(n4, $a1.y, $a2.y) || 
						!MathUtil.between(n4, $b1.y, $b2.y)) result = null;
				}
			}
			return result;
		}
		
		
		/**
		 * 线段上到目标位置距离最近的点。
		 * 
		 * @param $target:Point 目标位置。
		 * @param $start:Point 线段起始点。
		 * @param $end:Point 线段终点。
		 * @param $segment:Boolean (default = false) 是否启用线段限制，
		 * 
		 */
		public static function nearestToPoint($target:Point, $start:Point, $end:Point, $segment:Boolean = false):Point
		{
			var line:Point = $end.subtract($start);
			var angle:Number = Vector2DUtil.angle(line);
			var plus:Point = PointUtil.rotateAround($target, $start, -angle);
			plus.y = $start.y;
			if ($segment) plus.x = MathUtil.clamp(plus.x, $start.x, $start.x + line.length);
			return PointUtil.rotateAround(plus, $start, angle);
		}
		
		
		/**
		 * 求直线斜率。
		 * 
		 * @param $p1:Point 直线上第一个点。
		 * @param $p2:Point 直线上第二个点。
		 * 
		 */
		public static function slope($p1:Point, $p2:Point):Number
		{
			return ($p2.y - $p1.y) / ($p2.x - $p1.x); 
		}
		
		
		/**
		 * 检测点在直线向量的哪一侧，左下返回-1，右上返回1，直线上返回0。
		 * 
		 * @param $start:Point 直线起始点。
		 * @param $end:Point 直线终止点。
		 * @param $point:Point 目标点。
		 * 
		 * @return int 
		 * 
		 */
		public static function side($start:Point, $end:Point, $point:Point):int
		{
			var d:Number = ($point.x - $start.x) * ($end.y - $start.y) - ($end.x - $start.x) * ($point.y - $start.y);
			return d == 0 ? d : d / MathUtil.abs(d);
		}
		
	}
}