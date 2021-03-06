package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.geom.Vector2D;
	import cn.vision.utils.ArrayUtil;
	
	import flash.geom.Point;
	
	/**
	 * 2D向量工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Vector2DUtil extends NoInstance
	{
		
		/**
		 * 向量2至向量1的夹角，弧度为单位。
		 * 
		 * @param $v1:Point 向量1。
		 * @param $v2:Point 向量2。
		 * 
		 */
		public static function angle($v1:Vector2D, $v2:Vector2D):Number
		{
			return $v2.angle - $v1.angle;
		}
		
		
		/**
		 * 两向量叉积。
		 * 
		 * @param $v1:Vector2D 向量1。
		 * @param $v2:Vector2D 向量2。
		 * 
		 * @return Number 向量叉积。
		 * 
		 */
		public static function crossProduct($v1:Vector2D, $v2:Vector2D):Number
		{
			return $v1.u * $v2.v - $v2.u * $v1.v;
		}
		
		
		/**
		 * 点到向量的距离。
		 * 
		 * @param $vector:Vector2D 向量。
		 * @param $point:Point 点。
		 * @param $signed:Boolean (default = false) 是否带符号，符号与点在向量所在直线的哪一侧有关。
		 * 
		 * @return Number
		 * 
		 * @see cn.vision.utils.geom.Line2DUtil.side()
		 * 
		 */
		public static function distance(
			$vector:Vector2D, 
			$point:Point, 
			$signed:Boolean = false):Number
		{
			var sign:int = $signed ? Line2DUtil.nexusPoint($vector, $point) : 1;
			return Point.distance(nearest($vector, $point), $point) * sign;
		}
		
		
		/**
		 * 两向量点积，如果两向量垂直，则点积为0。
		 * 
		 * @param $v1:Vector2D 向量1。
		 * @param $v2:Vector2D 向量2。
		 * 
		 * @return Number 向量点积。
		 * 
		 */
		public static function dotProduct($v1:Vector2D, $v2:Vector2D):Number
		{
			return $v1.u * $v2.u + $v1.v * $v2.v;
		}
		
		
		/**
		 * 获取向量的一组线段点集。
		 * 
		 * @param $vector:Vector2D
		 * @param $seg:Number 分段，为0到1之间的数，数值越小，获得的点越多。
		 * 
		 */
		public static function getPoints(
			$vector:Vector2D, 
			$seg:Number, 
			$front:Number = 0, 
			$back:Number = 0):Array
		{
			var start:Point = $vector.start, end:Point = $vector.end;
			var dis:Number = $vector.length;
			var points:Array = [], ratio:Number;
			if (dis > $front + $back)
			{
				const fro:Number = $front / dis;
				const bac:Number = (1 - $back / dis);
				const per:Number = $seg;
				if (0 < per && per <= 1)
				{
					for (ratio = fro; ratio < bac; ratio += per)
					{
						var temp:Point = Point.interpolate(end, start, ratio);
						ArrayUtil.push(points, temp);
					}
					var over:Point = Point.interpolate(end, start, bac)
					if(!over.equals(temp)) ArrayUtil.push(points, over);
				}
			}
			else
			{
				ArrayUtil.push(points, dis <= 0 ? start : 
					Point.interpolate(end, start, $front / ($front + $back)));
			}
			return points;
		}
		
		
		/**
		 * 两向量的交点，如不相交或重合返回null。
		 * 
		 * @param $v1:Vector2D 向量1。
		 * @param $v2:Vector2D 向量2。
		 * 
		 * @return Point 向量的交点。
		 * 
		 */
		public static function intersect($v1:Vector2D, $v2:Vector2D):Point
		{
			var p:Point = Line2DUtil.intersect($v1, $v2);
			if (p && 
				Point2DUtil.between(p, $v1.start, $v1.end) && 
				Point2DUtil.between(p, $v2.start, $v2.end)) return p;
			return null;
		}
		
		
		/**
		 * 向量上到指定点距离最近的点。
		 * 
		 * @param $vector:Vector2D 向量。
		 * @param $point:Point 指定的点。
		 * 
		 * @return Point
		 * 
		 */
		public static function nearest($vector:Vector2D, $point:Point):Point
		{
			return Point2DUtil.clamp(Line2DUtil.nearest($vector, $point), $vector.start, $vector.end);
		}
		
		
		/**
		 * 两向量的位置关系。
		 * -1：不相交，0：重合，1：相交。
		 * 
		 * @param $v1:Vector2D 向量1。
		 * @param $v2:Vector2D 向量2。
		 * 
		 * @return Boolean true为相交，false为不相交。
		 * 
		 */
		public static function nexus($v1:Vector2D, $v2:Vector2D):int
		{
			var n1:int =     Line2DUtil.nexusSegment($v1, $v2.start, $v2.end);
			return n1 == 1 ? Line2DUtil.nexusSegment($v2, $v1.start, $v1.end) : n1;
		}
		
		
		/**
		 * 原向量在目标向量的投影。
		 * 
		 * @param $origin:Vector2D 原向量。
		 * @param $target:Vector2D 目标向量。
		 * 
		 * @return Vector2D 投影向量。
		 * 
		 */
		public static function project($origin:Vector2D, $target:Vector2D):Vector2D
		{
			const a2b2:Number = Line2DUtil.vs::caculateA2_B2($target);
			const pls1:Number = vs::calculateBX_AY($target, $origin.start);
			const pls2:Number = vs::calculateBX_AY($target, $origin.end);
			const mtac:Number = $target.A * $target.C;
			const mtbc:Number = $target.B * $target.C;
			return new Vector2D(
				($target.B * pls1 - mtac) / a2b2, (-$target.A * pls1 - mtbc) / a2b2, 
				($target.B * pls2 - mtac) / a2b2, (-$target.A * pls2 - mtbc) / a2b2);
		}
		
		
		/**
		 * 将向量转换为单位向量。
		 * 
		 * @param $vector:Vector2D 要转换的向量。
		 * 
		 */
		public static function unit($vector:Vector2D):void
		{
			var translate:Point = $vector.start;
			Geom2DUtil.move($vector, -translate.x, -translate.y);
			$vector.length = 1;
		}
		
		
		/**
		 * @private
		 */
		vs static function calculateBX_AY($v:Vector2D, $p:Point):Number
		{
			return $v.B * $p.x - $v.A * $p.y;
		}
		
	}
}