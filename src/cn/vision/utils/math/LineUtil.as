package cn.vision.utils.math
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.geom.geom2d.Line2D;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		 * 求线段斜率。
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
		 * 检测点在直线向量的哪一侧，左返回-1，右返回1，直线上返回0。
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