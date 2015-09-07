package cn.vision.utils.math
{
	
	/**
	 * 
	 * 直线工具。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.Vector3DUtil;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	public final class LineUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取直线上的点集合。
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
		
		public static function getLinePoints($start:Point, $end:Point, $seg:Number, $front:Number = 0, $back:Number = 0):Vector.<Point>
		{
			var dis:Number = Point.distance($start, $end);
			var per:Number = $seg / (dis - $front - $back);
			var fro:Number = $front / dis;
			var bac:Number = (1 - $back / dis);
			var points:Vector.<Point> = new Vector.<Point>;
			if (0 < per && per <= 1)
			{
				for (var tmp:Number = fro; tmp < bac; tmp += per)
				{
					ArrayUtil.push(points, Point.interpolate($end, $start, tmp));
				}
			}
			return points;
		}
		
		
		/**
		 * 
		 * 获取直线上的点集合。
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
		
		public static function getLineVector3Ds($start:Vector3D, $end:Vector3D, $seg:Number, $front:Number = 0, $back:Number = 0):Vector.<Vector3D>
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
		
	}
}