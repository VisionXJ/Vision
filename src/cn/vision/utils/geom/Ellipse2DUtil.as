package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.geom.Ellipse2D;
	import cn.vision.geom.Line2D;
	import cn.vision.geom.Vector2D;
	import cn.vision.utils.ArrayUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 椭圆工具。
	 * 
	 * @author exyjen
	 * 
	 */
	public final class Ellipse2DUtil extends NoInstance
	{
		
		/**
		 * 求椭圆面积。
		 * 
		 * @param $e:Ellipse2D
		 * 
		 * @return Number
		 * 
		 */
		public static function acreage($e:Ellipse2D):Number
		{
			return Math.PI * $e.a * $e.b;
		}
		
		
		/**
		 * 获取椭圆的矩形范围。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * 
		 * @return Rectangle 矩形范围。
		 * 
		 */
		public static function bounds($e:Ellipse2D):Rectangle
		{
			const ap2:Number = Math.pow($e.a, 2), bp2:Number = Math.pow($e.b, 2);
			const cos:Number = Math.cos($e.angle), cosp2:Number = Math.pow(cos, 2);
			const sin:Number = Math.sin($e.angle), sinp2:Number = Math.pow(sin, 2);
			const C:Number = cosp2 * sinp2 * Math.pow(bp2 - ap2, 2);
			const AY:Number = bp2 * cosp2 + ap2 * sinp2;
			const BY:Number = -AY * ap2 * bp2;
			const DY:Number = AY * (bp2 * sinp2 + ap2 * cosp2);
			const y1:Number = Math.sqrt(BY / (C - DY)) + $e.k;
			const y2:Number =-Math.sqrt(BY / (C - DY)) + $e.k;
			const AX:Number = bp2 * sinp2 + ap2 * cosp2;
			const BX:Number = -AX * ap2 * bp2;
			const DX:Number = AX * (bp2 * cosp2 + ap2 * sinp2);
			const x1:Number = Math.sqrt(BX / (C - DX)) + $e.h;
			const x2:Number =-Math.sqrt(BX / (C - DX)) + $e.h;
			return new Rectangle(x2, y2, x1 - x2, y1 - y2);
		}
		
		
		/**
		 * 已知椭圆Y坐标值，求椭圆的X坐标。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $y:Number Y坐标。
		 * 
		 * @return Array X坐标轴的值，可能是0个，1个或2个。
		 * 
		 */
		public static function evalX($e:Ellipse2D, $y:Number):Array
		{
			var result:Array = [];
			$y -= $e.k;
			const sin:Number = Math.sin($e.angle), cos:Number = Math.cos($e.angle);
			const sinp2:Number = Math.pow(sin, 2), cosp2:Number = Math.pow(cos, 2);
			const ap2:Number = Math.pow($e.a, 2), bp2:Number = Math.pow($e.b, 2);
			const A:Number = bp2 * cosp2 + ap2 * sinp2;
			const B:Number = 2 * cos * sin * (bp2 - ap2) * $y;
			const C:Number = (bp2 * sinp2 + ap2 * cosp2) * Math.pow($y, 2) - ap2 * bp2;
			const D:Number = Math.sqrt(B * B - 4 * A * C);
			const r1:Number = -0.5 * (B - D) / A + $e.h;
			const r2:Number = -0.5 * (B + D) / A + $e.h;
			if (!isNaN(r1)) ArrayUtil.push(result, r1);
			if (!isNaN(r2) && r1 != r2) ArrayUtil.push(result, r2);
			return result;
		}
		
		
		/**
		 * 已知椭圆X坐标值，求椭圆的Y坐标。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $x:Number X坐标。
		 * 
		 * @return Array Y坐标轴的值，可能是0个，1个或2个。
		 * 
		 */
		public static function evalY($e:Ellipse2D, $x:Number):Array
		{
			var result:Array = [];
			$x -= $e.h;
			const sin:Number = Math.sin($e.angle), cos:Number = Math.cos($e.angle);
			const sinp2:Number = Math.pow(sin, 2), cosp2:Number = Math.pow(cos, 2);
			const ap2:Number = Math.pow($e.a, 2), bp2:Number = Math.pow($e.b, 2);
			const A:Number = bp2 * sinp2 + ap2 + cosp2;
			const B:Number = 2 * cos * sin * (bp2 - ap2) * $x;
			const C:Number = (bp2 * cosp2 + ap2 * sinp2) * Math.pow($x, 2) - ap2 * bp2;
			const D:Number = Math.sqrt(B * B - 4 * A * C);
			const r1:Number = -0.5 * (B - D) / A + $e.k;
			const r2:Number = -0.5 * (B + D) / A + $e.k;
			if (!isNaN(r1)) ArrayUtil.push(result, r1);
			if (!isNaN(r2) && r1 != r2) ArrayUtil.push(result, r2);
			return result;
		}
		
		
		/**
		 * 求直线与椭圆的交点。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $l:Line2D 直线。
		 * 
		 * @return Array 交点数组，可能是0个，1个或2个。
		 * 
		 */
		public static function intersectLine($e:Ellipse2D, $l:Line2D):Array
		{
			var result:Array = [], p:Point, values:Array, value:Number, x:Number, y:Number;
			if ($l.B == 0)
			{
				x = Line2DUtil.evalX($l, 0);
				values = evalY($e, x);
				for each (value in values)
					ArrayUtil.push(result, new Point(x, value));
			}
			else if ($l.A == 0)
			{
				y = Line2DUtil.evalY($l, 0);
				values = evalX($e, y);
				for each (value in values)
					ArrayUtil.push(result, new Point(value, y));
			}
			else
			{
				$l = $l.clone();
				Geom2DUtil.move($l, -$e.h, -$e.k);
				const sin:Number = Math.sin($e.angle), cos:Number = Math.cos($e.angle);
				const sinp2:Number = Math.pow(sin, 2), cosp2:Number = Math.pow(cos, 2);
				const ap2:Number = Math.pow($e.a, 2), bp2:Number = Math.pow($e.b, 2);
				const lk:Number = $l.k, lkp2:Number = Math.pow($l.k, 2);
				const lb:Number = $l.b, lbp2:Number = Math.pow($l.b, 2);
				const A:Number = bp2 * (cosp2 + 2 * lk * cos * sin + lkp2 * sinp2) + 
					ap2 * (lkp2 * cosp2 - 2 * lk * cos * sin + sinp2);
				const B:Number = 2 * bp2 * lb * (cos * sin + lk * sinp2) - 
					2 * ap2 * lb * (cos * sin - lk * cosp2);
				const C:Number = lbp2 * (bp2 * sinp2 + ap2 * cosp2) - ap2 * bp2;
				const D:Number = Math.sqrt(B * B - 4 * A * C);
				const x1:Number = -0.5 * (B - D) / A;
				const x2:Number = -0.5 * (B + D) / A;
				if (!isNaN(x1)) 
				{
					p = new Point(x1, Line2DUtil.evalY($l, x1));
					p.offset($e.h, $e.k);
					ArrayUtil.push(result, p);
				}
				if (!isNaN(x2) && x1 != x2)
				{
					p = new Point(x2, Line2DUtil.evalY($l, x2));
					p.offset($e.h, $e.k);
					ArrayUtil.push(result, p);
				}
			}
			return result;
		}
		
		
		/**
		 * 求直线与线段的交点。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * 
		 * @return Array 交点数组，可能是0个，1个或2个。
		 * 
		 */
		public static function intersectSegment($e:Ellipse2D, $a:Point, $b:Point):Array
		{
			var result:Array = [], points:Array = intersectLine($e, new Line2D($a, $b)), p:Point;
			for each(p in points)
			{
				if (Point2DUtil.between(p, $a, $b))
					result[result.length] = p;
			}
			return result;
		}
		
		
		/**
		 * 求直线与向量的交点。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $v:Vector2D 向量。
		 * 
		 * @return Array 交点数组，可能是0个，1个或2个。
		 * 
		 */
		public static function intersectVector($e:Ellipse2D, $v:Vector2D):Array
		{
			var result:Array = [], points:Array = intersectLine($e, $v), 
				p:Point, a:Point = $v.start, b:Point = $v.end;
			for each(p in points)
			{
				if (Point2DUtil.between(p, a, b))
					result[result.length] = p;
			}
			return result;
		}
		
		
		/**
		 * 求椭圆周长，使用周钰承椭圆周长公式。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * 
		 * @return Number
		 * 
		 */
		public static function perimeter($e:Ellipse2D):Number
		{
			const asb:Number = $e.a - $e.b, anb:Number = $e.a + $e.b;
			const smn:Number = asb / anb, smnp2:Number = Math.pow(smn, 2);
			return Math.PI * anb * (1 + 3 * smnp2 / (10 + Math.sqrt(4 - 3 * smnp2)) + 
				PERIMETER_C * Math.pow(smn, 14.233 + 13.981 * Math.pow(smn, 6.42)));
		}
		
		
		/**
		 * 从椭圆中心点发出一条与X轴夹角为$angle的射线，与椭圆相交的点。
		 * 
		 * @param $e:Ellipse2D 椭圆。
		 * @param $angle:Number 射线与X轴的夹角。
		 * 
		 * @return Point 射线与椭圆相交的点。
		 * 
		 */
		public static function point($e:Ellipse2D, $angle:Number):Point
		{
			var end:Point = Point2DUtil.offset($e.center, $angle, $e.a + 1);
			var points:Array = intersectSegment($e, $e.center, end);
			return points[0];
		}
		
		
		/**
		 * 4/pi - 14/11
		 */
		private static const PERIMETER_C:Number = 11.293643341631900226577846260391;
		
	}
}