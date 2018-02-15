package cn.vision.utils.math
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * 定义了一些贝塞尔曲线常用数学函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class BezierUtil extends NoInstance
	{
		
		/**
		 * 返回二次贝塞尔曲线上到目标位置最近的点。
		 * 
		 * @param $target:Point 目标位置。
		 * @param $start:Point 二次贝塞尔曲线线段起始点。
		 * @param $end:Point 二次贝塞尔曲线线段终点。
		 * @param $ctrl:Point 二次贝塞尔曲线线段控制点。
		 * 
		 */
		public static function curveNearestToPoint($target:Point, $start:Point, $end:Point, $ctrl:Point):Point
		{
			var posMin:Point = new Point;
			//start-target
			var ts:Point = $start.subtract($target);
			//ctrl-start
			var A:Point = $ctrl.subtract($start);
			//end-ctrl-A
			var B:Point = $end.subtract($ctrl).subtract(A);
			// search points P of bezier curve with PM.(dP / dt) = 0
			// a calculus leads to a 3d degree equation :
			var a:Number = B.x * B.x + B.y * B.y;
			var b:Number = 3 * (A.x * B.x + A.y * B.y);
			var c:Number = 2 * (A.x * A.x + A.y * A.y) + ts.x * B.x + ts.y * B.y;
			var d:Number = ts.x * A.x + ts.y * A.y;
			var sol:Array = thirdDegreeEquation(a, b, c, d);
			
			var t:Number, dist:Number, tMin:Number;
			var distMin:Number = Number.MAX_VALUE;
			var d0:Number = Point.distance($target, $start);
			var d2:Number = Point.distance($target, $end);
			
			if (sol)
			{
				for (var i:int = 0, l:int = sol.length; i < l; i += 1)
				{
					t = sol[i];
					if (t >= 0 && t <= 1)
					{
						ts = getCurvePoint($start, $end, $ctrl, t);
						dist = Point.distance($target, ts);
						if (dist < distMin)
						{
							tMin = t;
							distMin = dist;
							posMin.x = ts.x;
							posMin.y = ts.y;
						}
					}
				}
				
				//the closest point is on the curve
				if (!isNaN(tMin) && distMin < d0 && distMin < d2) return posMin;
			}
			posMin.copyFrom(d0 < d2 ? $start : $end);
			return posMin;
		}
		
		private static function thirdDegreeEquation(a:Number, b:Number, c:Number, d:Number):Array
		{
			solution.length = 0;
			if (Math.abs(a) > zeroMax)
			{
				var z:Number, p:Number, q:Number, p3:Number, D:Number, offset:Number, u:Number, v:Number, three_1:Number;
				// let's adopt form: x3 + ax2 + bx + d = 0
				z = a; // multi-purpose util variable
				a = b / z;
				b = c / z;
				c = d / z;
				// we solve using Cardan formula: http://fr.wikipedia.org/wiki/M%C3%A9thode_de_Cardan
				three_1 = 1 / 3;
				p = b - a * a * three_1;
				q = a * (2 * a * a - 9 * b) / 27 + c;
				p3 = p * p * p;
				D = q * q + 4 * p3 / 27;
				offset = -a * three_1;
				if (D > zeroMax)
				{
					// D positive
					z = Math.sqrt(D);
					u = ( -q + z) * .5;
					v = ( -q - z) * .5;
					u = u >= 0 ? Math.pow(u, three_1) : -Math.pow( -u, three_1);
					v = v >= 0 ? Math.pow(v, three_1) : -Math.pow( -v, three_1);
					solution[0] = u + v + offset;
				}
				else if (D < -zeroMax)
				{
					// D negative
					u = 2 * Math.sqrt(-p * three_1);
					v = Math.acos(-Math.sqrt( -27 / p3) * q * .5) * three_1;
					solution[0] = u * Math.cos(v) + offset;
					solution[1] = u * Math.cos(v + 2 * Math.PI * three_1) + offset;
					solution[2] = u * Math.cos(v + 4 * Math.PI * three_1) + offset;
				}
				else
				{
					// D zero
					if (q < 0) u = Math.pow(-q * .5, three_1);
					else u = -Math.pow( q * .5, three_1);
					solution[0] = 2 * u + offset;
					solution[1] = -u + offset;
				}
				return solution;
			}
			else
			{
				// a = 0, then actually a 2nd degree equation:
				// form : ax2 + bx + c = 0;
				a = b;
				b = c;
				c = d;
				if (Math.abs(a) <= zeroMax)
				{
					if (Math.abs(b) <= zeroMax) return null;
					else 
					{
						solution[0] = -c / b;
						return solution;
					}
				}
				else
				{
					D = b*b - 4 * a * c;
					// D negative
					if (D <= - zeroMax) return null;
					else
					{
						if (D > zeroMax)
						{
							// D positive
							D = Math.sqrt(D);
							solution[0] = ( -b - D) / (2 * a);
							solution[1] = ( -b + D) / (2 * a);
						}
						else 
						{
							// D zero
							solution[0] = -b / (2 * a);
						}
						return solution;
					}
				}
			}
		}
		
		
		/**
		 * 
		 * 计算二次贝塞尔曲线长度。<br>
		 * 二次贝塞尔曲线有三个点，起始点，终止点以及控制点。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 终止点。
		 * @param $ctrl:Point 控制点。
		 * 
		 * @return Number 曲线长度。
		 * 
		 */
		public static function getCurveLength($start:Point, $end:Point, $ctrl:Point):Number
		{ 
			const PRECISION:Number = 1e-10;
			const csX:Number = $end.x - $start.x;
			const csY:Number = $end.y - $start.y;
			const nvX:Number = $ctrl.x - $end.x - csX;
			const nvY:Number = $ctrl.y - $end.y - csY;
			const c0:Number = 4 * (csX * csX + csY * csY);
			const c1:Number = 8 * (csX * nvX + csY * nvY);
			const c2:Number = 4 * (nvX * nvX + nvY * nvY);
			var ft:Number, f0:Number;
			if (c2 == 0)
			{
				if (c1 == 0)
				{
					ft = Math.sqrt(c0);
					return ft;
				}
				else
				{
					ft = (2 / 3) * (c1 + c0) * Math.sqrt(c1 + c0) / c1;
					f0 = (2 / 3) * c0 * Math.sqrt(c0) / c1;
					return (ft-f0);
				}
			}
			else
			{ 
				const sqrt_0:Number = Math.sqrt(c2 + c1 + c0);
				const sqrt_c0:Number = Math.sqrt(c0);
				const sqrt_c2:Number = Math.sqrt(c2);
				const vsqr:Number = sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
				ft = 0.25 * (2 * c2 + c1) * sqrt_0 / c2;
				f0 = 0.25 * (c1) * sqrt_c0 / c2;
				if ((0.5 * c1 + c2) / sqrt_c2 + sqrt_0 >= PRECISION)
					ft += 0.5 * Math.log((0.5 * c1 + c2) / sqrt_c2 + sqrt_0) / vsqr;
				if ((0.5 * c1) / sqrt_c2 + sqrt_c0 >= PRECISION)
					f0 += 0.5 * Math.log((0.5 * c1) / sqrt_c2 + sqrt_c0) / vsqr;
				return ft - f0;
			}
		}
		
		
		/**
		 * 
		 * 获取二次贝塞尔曲线上的某个点，包含起始点与结束点。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 结束点。
		 * @param $ctrl:Point 控制点。
		 * @param $per:Number 百分比，0到1之间的数，为0时，恰好为$start，为1时，恰好为$end。
		 * 
		 * @return Vector.<Point> 曲线上的点集。
		 * 
		 */
		public static function getCurvePoint($start:Point, $end:Point, $ctrl:Point, $per:Number):Point
		{
			return Point.interpolate(Point.interpolate($end, $ctrl, $per), Point.interpolate($ctrl, $start, $per), $per);
		}
		
		
		/**
		 * 
		 * 获取二次贝塞尔曲线上的点，但不包含起始点与结束点。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 结束点。
		 * @param $ctrl:Point 控制点。
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点集越多，越接近曲线。
		 * @param $side:Boolean (default =false) 是否包含起始点与结束点。
		 * 
		 * @return Vector.<Point> 曲线上的点集。
		 * 
		 */
		
		public static function getCurvePoints($start:Point, $end:Point, $ctrl:Point, $seg:Number = .1, $side:Boolean = false):Vector.<Point>
		{
			if ($start && $end && $ctrl)
			{
				var result:Vector.<Point> = new Vector.<Point>;
				for (var t:Number = $seg; t <= 1; t += $seg)
				{
					//二次Bz曲线的公式
					var x:Number = (1 - t) * (1 - t) * $start.x + 2 * t * (1 - t) * $ctrl.x + t * t * $end.x;
					var y:Number = (1 - t) * (1 - t) * $start.y + 2 * t * (1 - t) * $ctrl.y + t * t * $end.y;              
					result[result.length] = new Point(x, y);
				}
				if ($side) 
				{
					ArrayUtil.unshift(result, $start);
					ArrayUtil.push(result, $end);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 获取贝塞尔曲线点集。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 结束点。
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点集越多，越接近曲线。
		 * @param $side:Boolean (default = false) 返回的点集是否包含两端的端点。
		 * @param $args 控制点集合，每一个参数都必须是Point实例，否则会引发ArgumentError异常。
		 * 
		 * @return Vector.<Point> 曲线上的点集。
		 * 
		 */
		public static function getBezierPoints($start:Point, $end:Point, $seg:Number = .1, $side:Boolean = false, ...$args):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>;
			ArrayUtil.unshift($args, points, $start);
			ArrayUtil.push($args, $end);
			ArrayUtil.push.apply(null, $args);
			ArrayUtil.normalize(points);
			var result:Vector.<Point> = new Vector.<Point>;
			for (var t:Number = $seg; t <= 1; t += $seg)
			{
				ArrayUtil.push(result, resolvePoints(points, t));
			}
			if ($side) 
			{
				ArrayUtil.unshift(result, $start);
				ArrayUtil.push(result, $end);
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function resolvePoints($points:Vector.<Point>, $per:Number):Point
		{
			var temp:Vector.<Point>, i:int = 0, l:int;
			while ($points.length > 1)
			{
				temp = new Vector.<Point>;
				i = 0, l = $points.length - 1;
				while (i < l)
				{
					temp[i] = Point.interpolate($points[i + 1], $points[i], $per); 
					i += 1;
				}
				$points = temp;
			}
			return $points[0];
		}
		
		
		/**
		 * 
		 * 获取三维贝塞尔曲线点集。
		 * 
		 * @param $start:Vector3D 起始点。
		 * @param $end:Vector3D 结束点。
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点集越多，越接近曲线。
		 * @param $side:Boolean (default = false) 返回的点集是否包含两端的端点。
		 * @param $args 控制点集合，每一个参数都必须是Point实例，否则会引发ArgumentError异常。
		 * 
		 * @return Vector.<Vector3D> 曲线上的点集。
		 * 
		 */
		public static function getBezierVector3Ds($start:Vector3D, $end:Vector3D, $seg:Number = .1, $side:Boolean = false, ...$args):Vector.<Vector3D>
		{
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			ArrayUtil.unshift($args, points, $start);
			ArrayUtil.push($args, $end);
			ArrayUtil.push.apply(null, $args);
			var result:Vector.<Vector3D> = new Vector.<Vector3D>;
			for (var t:Number = $seg; t <= 1; t += $seg)
			{
				ArrayUtil.push(result, resolveVector3Ds(points, t));
			}
			if ($side) 
			{
				ArrayUtil.unshift(result, $start);
				ArrayUtil.push(result, $end);
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function resolveVector3Ds($points:Vector.<Vector3D>, $per:Number):Vector3D
		{
			var temp:Vector.<Vector3D>, i:int = 0, l:int;
			while ($points.length > 1)
			{
				temp = new Vector.<Vector3D>;
				i = 0, l = $points.length - 1;
				while (i < l)
				{
					temp[i] = Vector3DUtil.interpolate($points[i + 1], $points[i], $per); 
					i += 1;
				}
				$points = temp;
			}
			return $points[0];
		}
		
		private static var zeroMax:Number = 0.0000001;
		
		private static var solution:Array = [];
		
	}
}