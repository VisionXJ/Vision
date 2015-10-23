package cn.vision.utils.math
{
	
	/**
	 * 
	 * <code>AdvancedMathUtil</code>定义了一些常用数学函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.Vector3DUtil;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	public final class BezierUtil extends NoInstance
	{
		
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
		
		public static function getCurveLength($start:Point,$end:Point,$ctrl:Point):Number
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
		 * 获取N次贝塞尔曲线点集。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 结束点。
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点集越多，越接近曲线。
		 * @param $args 控制点集合，每一个参数都必须是Point实例，否则会引发ArgumentError异常。
		 * 
		 * @return Vector.<Point> 曲线上的点集。
		 * 
		 */
		
		public static function getBezierPoints($start:Point, $end:Point, $seg:Number = .1, $side:Boolean = false, ...$args):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>;
			ArrayUtil.push(points, $start);
			for each (var item:* in $args) 
			{
				if (!(item is Point))
					throw new ArgumentError("参数必须是Point类型实例！", 3002);
				else
					ArrayUtil.push(points, item);
			}
			ArrayUtil.push(points, $end);
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
		 * 
		 * 获取三维N次贝塞尔曲线点集。
		 * 
		 * @param $start:Vector3D 起始点。
		 * @param $end:Vector3D 结束点。
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点集越多，越接近曲线。
		 * @param $args 控制点集合，每一个参数都必须是Point实例，否则会引发ArgumentError异常。
		 * 
		 * @return Vector.<Vector3D> 曲线上的点集。
		 * 
		 */
		
		public static function getBezierVector3Ds($start:Vector3D, $end:Vector3D, $seg:Number = .1, $side:Boolean = false, ...$args):Vector.<Vector3D>
		{
			const points:Vector.<Vector3D> = new Vector.<Vector3D>;
			ArrayUtil.push(points, $start);
			for each (var item:* in $args) 
			{
				if (!(item is Vector3D))
					throw new ArgumentError("参数必须是Point类型实例！", 3002);
				else
					ArrayUtil.push(points, item);
			}
			ArrayUtil.push(points, $end);
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
		private static function resolvePoints($points:Vector.<Point>, $per:Number):Point
		{
			while ($points.length > 1)
			{
				var temp:Vector.<Point> = new Vector.<Point>;
				var i:uint = 0;
				const l:int = $points.length - 1;
				while (i < l)
				{
					temp[i] = Point.interpolate($points[i + 1], $points[i], $per);
					i++;
				}
				$points = temp;
			}
			return $points[0];
		}
		
		/**
		 * @private
		 */
		private static function resolveVector3Ds($points:Vector.<Vector3D>, $per:Number):Vector3D
		{
			while ($points.length > 1)
			{
				var temp:Vector.<Vector3D> = new Vector.<Vector3D>;
				var i:uint = 0;
				const l:int = $points.length - 1;
				while (i < l)
				{
					temp[i] = Vector3DUtil.interpolate($points[i + 1], $points[i], $per);
					i++;
				}
				$points = temp;
			}
			return $points[0];
		}
		
	}
}