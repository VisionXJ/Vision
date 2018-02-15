package cn.vision.utils.math
{
	import cn.vision.core.NoInstance;
	
	import flash.geom.Point;
	
	/**
	 * 定义了一些点函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class PointUtil extends NoInstance
	{
		
		/**
		 * $point绕$origin旋转$radian之后的新坐标。
		 * 
		 * @param $point:Point
		 * @param $origin:Point
		 * @param $radian:Number
		 * 
		 * @return Point 得到的新坐标
		 * 
		 */
		public static function rotateAround($point:Point, $origin:Point = null, $radian:Number = 0):Point
		{
			$origin = $origin || new Point;
			const cos:Number = Math.cos($radian);
			const sin:Number = Math.sin($radian);
			const sbx:Number = $point.x - $origin.x;
			const sby:Number = $point.y - $origin.y;
			return new Point(
				sbx * cos - sby * sin + $origin.x, 
				sbx * sin + sby * cos + $origin.y);
		}
		
	}
}