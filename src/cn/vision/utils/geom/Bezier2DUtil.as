package cn.vision.utils.geom
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
	public final class Bezier2DUtil extends NoInstance
	{
		
		/**
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
		public static function getPoints($start:Point, $end:Point, $seg:Number = .1, $side:Boolean = false, ...$args):Array
		{
			var points:Array = [], result:Array = [];
			ArrayUtil.unshift($args, points, $start);
			ArrayUtil.push($args, $end);
			ArrayUtil.push.apply(null, $args);
			ArrayUtil.normalize(points);
			for (var t:Number = $seg; t <= 1; t += $seg)
			{
				ArrayUtil.push(result, resolvePoint(points, t));
			}
			if ($side) 
			{
				ArrayUtil.unshift(result, $start);
				ArrayUtil.push(result, $end);
			}
			return result;
		}
		
		
		/**
		 * 根据百分比获取曲线上的一点。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 终止点。
		 * @param $per:Number 百分比(0-1之间的数值，0为起始点，1为终止点)。
		 * @param ...$args 控制点集。
		 * 
		 */
		public static function getPoint($start:Point, $end:Point, $per:Number, ...$args):Point
		{
			var points:Array = [], result:Array = [];
			ArrayUtil.unshift($args, points, $start);
			ArrayUtil.push($args, $end);
			ArrayUtil.push.apply(null, $args);
			ArrayUtil.normalize(points);
			$per = MathUtil.clamp($per, 0, 1);
			return resolvePoint(points, $per);
		}
		
		/**
		 * @private
		 */
		private static function resolvePoint($points:Array, $per:Number):Point
		{
			var temp:Array, i:int = 0, l:int;
			while ($points.length > 1)
			{
				temp = [];
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
		
	}
}