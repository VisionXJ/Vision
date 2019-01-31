package cn.vision.utils.math
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.geom.Vector2D;
	import cn.vision.utils.geom.Geom2DUtil;
	
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
		
		/**
		 * 缩放矩形，并返回一个新的缩放后的矩形。
		 * 
		 * @param $target:Rectangle 目标矩形。
		 * @param $scaleX:Number X轴缩放。
		 * @param $scaleY:Number Y轴缩放。
		 * @param $center:Point (default = null)。
		 * 
		 * @return Point 缩放后的矩形。
		 * 
		 */
		public static function scale($target:Rectangle, $scaleX:Number, $scaleY:Number, $center:Point = null):Rectangle
		{
			$center = $center || getCenter($target);
			var vtl:Point = $target.topLeft.subtract($center);
			vtl.x *= $scaleX;
			vtl.y *= $scaleY;
			vtl = vtl.add($center);
			var vbr:Point = $target.bottomRight.subtract($center);
			vbr.x *= $scaleX;
			vbr.y *= $scaleY;
			vbr = vbr.add($center);
			return new Rectangle(vtl.x, vtl.y, vbr.x - vtl.x, vbr.y - vtl.y);
		}
		
	}
}