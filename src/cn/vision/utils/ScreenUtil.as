package cn.vision.utils
{
	
	/**
	 * 
	 * 屏幕工具类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	
	public final class ScreenUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取虚拟桌面的矩形范围。
		 * 
		 * @return Rectangle 虚拟桌面的矩形范围。
		 * 
		 */
		
		public static function getScreensBounds():Rectangle
		{
			var xs:Array = [];
			var ys:Array = [];
			
			for each (var screen:Screen in Screen.screens)
			{
				var rect:Rectangle = screen.bounds;
				ArrayUtil.push(xs, rect.left, rect.right);
				ArrayUtil.push(ys, rect.top, rect.bottom);
			}
			
			var l:Number = Math.min.apply(null, xs);
			var r:Number = Math.max.apply(null, xs);
			var t:Number = Math.min.apply(null, ys);
			var b:Number = Math.max.apply(null, ys);
			
			return new Rectangle(l, t, r - l, b - t);
		}
		
		
		/**
		 * 
		 * 获取主屏幕矩形范围。
		 * 
		 * @return Rectangle 主屏幕的矩形范围。
		 * 
		 */
		
		public static function getMainScreenBounds():Rectangle
		{
			return Screen.mainScreen.bounds;
		}
		
	}
}