package cn.vision.utils.math
{
	import cn.vision.core.NoInstance;
	
	import flash.geom.Point;
	
	/**
	 * 定义了一些向量函数。
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
		 * 向量的角度(与X轴的夹角)，以弧度表示。
		 * 
		 * @param $vector:Point 向量。
		 * 
		 * @return Number 向量角度。
		 * 
		 */
		public static function angle($vector:Point):Number
		{
			return  Math.atan2($vector.y, $vector.x);
		}
		
		/**
		 * 两向量的夹角。
		 * 
		 * @param $v1:Point 向量1。
		 * @param $v2:Point 向量2。
		 * 
		 */
		public static function intersectionAngle($v1:Point, $v2:Point):Number
		{
			return Math.atan2($v2.y, $v2.x) - Math.atan2($v1.y, $v1.x);
		}
		
	}
}