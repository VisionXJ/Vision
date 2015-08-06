package cn.vision.utils
{
	
	/**
	 * 
	 * <code>BitmapUtil</code>定义了一些位图常用函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	public final class BitmapUtil extends NoInstance
	{
		
		/**
		 * 
		 * 截图。
		 * 
		 * @param $source:DisplayObject 需要截取的显示对象。
		 * @param $width:Number (default = NaN) 返回的BitmapData的宽度，值大于0，小等于0或NaN则默认为源显示对象宽度。
		 * @param $height:Number (default = NaN) 返回的BitmapData的高度，值大于0，小等于0或NaN则默认为源显示对象高度。
		 * @param $transparent:Boolean (default = true) 是否为透明。
		 * @param $fillColor:uint (default = 0) 填充颜色。
		 * @param $matrix:Matrix (default = null) 转换矩阵。
		 * @param $colorTransform:ColorTransform (default = null) 颜色通道。
		 * @param $blendMode:String (default = null) 位图模式。
		 * @param $clipRect:Rectange (default = null) 截取的区域。
		 * @param $smooth:String 是否平滑。
		 * 
		 */
		
		public static function draw($source:DisplayObject,
									$width:Number = NaN,
									$height:Number = NaN,
									$transparent:Boolean = true,
									$fillColor:uint = 0,
									$matrix:Matrix = null,
									$colorTransform:ColorTransform = null,
									$blendMode:String = null,
									$clipRect:Rectangle = null,
									$smoothing:Boolean = false):BitmapData
		{
			if (!($width  > 0)) $width  = $source.width;
			if (!($height > 0)) $height = $source.height;
			var bmd:BitmapData = new BitmapData($width, $height, $transparent, $fillColor);
			bmd.draw($source, $matrix, $colorTransform, $blendMode, $clipRect, $smoothing);
			return bmd;
		}
		
	}
}