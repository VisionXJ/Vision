package cn.vision.utils.math
{
	import cn.vision.core.NoInstance;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * 定义了一些多边形函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class PolygonUtil extends NoInstance
	{
		
		/**
		 * 求多边形的面积。
		 * 
		 * @param $polygon:Vector.<Point> 顺时针或逆时针点集。
		 * 
		 * @return Number 多边形面积。
		 * 
		 */
		public static function acreage($polygon:Vector.<Point>):Number
		{
			return Math.abs(clockAcreage($polygon));
		}
		
		
		/**
		 * 判断多边形点集是否按顺时针排列。
		 * 
		 * @param $polygon:Vector.<Point> 多边形顺时针或逆时针点集。
		 * 
		 * @return Boolean true 为顺时针。
		 * 
		 */
		public static function clockwise($polygon:Vector.<Point>):Boolean
		{
			return clockAcreage($polygon) > 0;
		}
		
		
		/**
		 * 检测2个多边形的关系，目前支持四种：<br>
		 * 0：不相交；1：相交；2：a包含b；3：b包含a。
		 * 
		 * @param $a:Vector.<Point> 第一个多边形的顺时针点集。
		 * @param $b:Vector.<Point> 第二个多边形的顺时针点集。
		 * 
		 * @return int 关系数值。
		 * 
		 */
		public static function collision($a:Vector.<Point>, $b:Vector.<Point>):int
		{
			var la:int = $a.length, lb:int = $b.length;
			var ia:int, ja:int = la - 1, ib:int, jb:int = lb - 1;
			for (ia, ja; ia < la; ja = ia++)
			{
				for (ib, jb; ib < lb; jb = ib++)
					if (LineUtil.collision($a[ia], $a[ja], $b[ib], $b[jb])) return 1;
			}
			if (containsPoint($a, $b[0])) return 2;
			else if (containsPoint($b, $a[0])) return 3;
			return 0;
		}
		
		
		/**
		 * 判断点是否在多边形内部。
		 * 原理：从当前点往任意方向发出一条射线，判断射线与多边形的边相交的次数，如果是奇数，则表示在多边形内部。
		 * 
		 * @param $polygon:Vector.<Point> 多边形顺时针或逆时针点集。
		 * 
		 * @return Boolean true 为包含。
		 * 
		 */
		public static function containsPoint($polygon:Vector.<Point>, $point:Point):Boolean
		{
			var i:int, j:int, crossing:int, l:int = $polygon.length;
			for (i = 0, j = l - 1; i < l; j = i++)
			{
				//x[j] < x < x[i] && y0 >= y
				if (($polygon[i].x >= $point.x) != ($polygon[j].x >= $point.x) && 
					($point.y <= LineUtil.slope($polygon[i], $polygon[j]) * ($point.x - $polygon[i].x) + $polygon[i].y)) crossing++;
			}
			return !MathUtil.even(crossing);
		}
		
		
		/**
		 * @private
		 */
		private static function clockAcreage($polygon:Vector.<Point>):Number
		{
			var i:int = 1, l:int = $polygon.length;
			var area:Number = $polygon[0].y * ($polygon[l - 1].x - $polygon[1].x);
			for(i; i < l; i++) area += $polygon[i].y * ($polygon[i - 1].x - $polygon[(i + 1) % l].x);
			return .5 * area;
		}
		
	}
}