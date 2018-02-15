package cn.vision.utils.math
{
	
	import cn.vision.core.NoInstance;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * 定义一些矩形常用功能函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class RectangleUtil extends NoInstance
	{
		/**
		 * 获取矩形的中心点。
		 * 
		 * @param $rectangle:Rectangle 需要获取中心点的矩形。
		 * 
		 * @return Point 矩形的中心点。
		 * 
		 */
		public static function getCenter($rectangle:Rectangle):Point
		{
			return Point.interpolate($rectangle.topLeft, $rectangle.bottomRight, .5);
		}
		
	}
}