package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * 颜色通道工具类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ColorTransfomUtil extends NoInstance
	{
		
		/**
		 * 改变一个DisplayObject的通道颜色。
		 * 
		 * @param $target:DisplayObject 要改变通道颜色的目标DisplayObject。
		 * @param $color:uint (default = 0) 颜色值。
		 * 
		 */
		public static function change($target:DisplayObject, $color:uint = 0):void
		{
			if ($target)
			{
				var color:ColorTransform = new ColorTransform;
				color.color = $color;
				$target.transform.colorTransform = color;
			}
		}
		
		/**
		 * 重置DisplayObject的颜色通道。
		 * 
		 * @param $target:DisplayObject 要重置颜色通道的目标DisplayObject。
		 * 
		 */
		public static function reset($target:DisplayObject):void
		{
			if ($target) $target.transform.colorTransform = new ColorTransform;
		}
	}
}