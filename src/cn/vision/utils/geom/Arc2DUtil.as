package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.geom.Arc2D;
	import cn.vision.geom.Line2D;
	import cn.vision.geom.Vector2D;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * 2D圆弧工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Arc2DUtil extends NoInstance
	{
		
		/**
		 * 已知圆弧Y坐标值，求圆弧的X坐标。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * @param $y:Number Y坐标。
		 * 
		 * @return * X坐标轴的值，如果是一个，则返回该值，如果是两个，则返回一个数组，如果输入的Y坐标不在圆弧范围内，则返回空。
		 * 
		 */
		public static function evalX($a:Arc2D, $y:Number):*
		{
			var result:Array = [];
			var values:* = Ellipse2DUtil.evalX($a, $y);
			if (values)
			{
				if (values is Number && vs::between($a, new Point(values, $y))) return values;
				else if (values is Array)
				{
					for each (var value:Number in values)
					{
						if (vs::between($a, new Point(value, $y)))
							ArrayUtil.push(result, value);
					}
					return result.length ? (result.length == 1 ? result[0] : result) : null;
				}
			}
			return null;
		}
		
		
		/**
		 * 已知圆弧X坐标值，求圆弧的Y坐标。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * @param $x:Number X坐标。
		 * 
		 * @return * Y坐标轴的值，如果是一个，则返回该值，如果是两个，则返回一个数组，如果输入的X坐标不在圆弧范围内，则返回空。
		 * 
		 */
		public static function evalY($a:Arc2D, $x:Number):*
		{
			var result:Array = [];
			var values:* = Ellipse2DUtil.evalY($a, $x);
			if (values)
			{
				if (values is Number && vs::between($a, new Point($x, values))) return values;
				else if (values is Array)
				{
					for each (var value:Number in values)
					{
						if (vs::between($a, new Point($x, value)))
							ArrayUtil.push(result, value);
					}
					return result.length ? (result.length == 1 ? result[0] : result) : null;
				}
			}
			return null;
		}
		
		
		/**
		 * 两圆弧的交点。
		 * 
		 * @param $a1:Arc2D 圆弧1。
		 * @param $a2:Arc2D 圆弧2。
		 * 
		 * @return Array 交点数组，如果没有任何交点，则返回null。
		 * 
		 */
		public static function intersect($a1:Arc2D, $a2:Arc2D):Array
		{
			var result:Array = [];
			if (Point.distance($a1.center, $a2.center) <= $a1.r + $a2.r)
			{
				var a1r2:Number = Math.pow($a1.r, 2);
				var a1h2:Number = Math.pow($a1.h, 2);
				var line:Line2D = new Line2D(
					2 * ($a1.h - $a2.h), 2 * ($a1.k - $a2.k),
					a1r2 - Math.pow($a2.r, 2) - 
					a1h2 + Math.pow($a2.h, 2) - 
					Math.pow($a1.k, 2) + Math.pow($a2.k, 2));
				var points:Array = intersectLine($a1, line);
				for each (var p:Point in points)
					if (vs::between($a2, p)) ArrayUtil.push(result, p);
			}
			return result.length == 0 ? null : result;
		}
		
		
		/**
		 * 圆弧与直线的交点。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * @param $l:Line2D 直线。
		 * 
		 * @return * 如果是一个交点，则直接返回该点，如果是两个交点，则返回交点数组，如果没有交点，则返回null。
		 * 
		 */
		public static function intersectLine($a:Arc2D, $l:Line2D):*
		{
			var result:Array = [], p:Point;
			var points:Array = Ellipse2DUtil.intersectLine($a, $l);
			for each (p in points)
				if (vs::between($a, p)) ArrayUtil.push(result, p);
			return result;
		}
		
		
		/**
		 * 圆弧与向量的交点。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * @param $v:Vector2D 向量。
		 * 
		 * @return Array 如果是一个交点，则直接返回该点，如果是2个交点，则返回交点数组，如果没有交点，则返回null。
		 * 
		 */
		public static function intersectVector($a:Arc2D, $v:Vector2D):*
		{
			var result:Array = [];
			var values:Array = intersectLine($a, $v);
			for each (var p:Point in values)
			{
				if (Segment2DUtil.nexusPoint($v.start, $v.end, p))
					ArrayUtil.push(result, p);
			}
			return result;
		}
		
		
		/**
		 * 求圆弧长度。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * 
		 * @return Number
		 * 
		 */
		public static function length($a:Arc2D):Number
		{
			return $a.r * Math.abs($a.radianEnd - $a.radianStart);
		}
		
		
		/**
		 * 点与圆弧的关系。
		 * 
		 * @param $a:Arc2D 圆弧。
		 * @param $p:Point 点。
		 * 
		 * @return Boolean true为点在圆弧上。
		 * 
		 */
		public static function nexusPoint($a:Arc2D, $p:Point):Boolean
		{
			return Point.distance($p, $a.center) == $a.r ? vs::between($a, $p) : false;
		}
		
		
		/**
		 * 获取圆弧的点集。
		 * 
		 * @param $arc:Arc2D 圆弧。
		 * @param $seg:Number (default = 5) 分段距离。
		 * 
		 * @return Array 点集数组。
		 * 
		 */
		public static function points($a:Arc2D, $seg:Number = 5):Array
		{
			var theta:Number = ($a.radianEnd - $a.radianStart) * $seg / length($a);
			var segs:Number = Math.abs(($a.radianEnd - $a.radianStart) / theta);
			var result:Array = [];
			var angle:Number = $a.radianStart;
			for (var i:int = 0; i < segs; i++, angle += theta)
				ArrayUtil.push(result, Point2DUtil.offset($a.center, angle, $a.r));
			return result;
		}
		
		
		/**
		 * 检测当前弧圆心到点p与X轴的夹角是否在圆弧内。
		 */
		vs static function between($a:Arc2D, $p:Point):Boolean
		{
			const ang:Number = MathUtil.moduloAngle(Point2DUtil.angle($a.center, $p), true);
			const min:Number = Math.min($a.radianStart, $a.radianEnd), 
				  max:Number = Math.max($a.radianStart, $a.radianEnd);
			const tmp:Number = MathUtil.moduloAngle(min, true);
			return MathUtil.between(ang, tmp, tmp + max - min);
		}
		
	}
}