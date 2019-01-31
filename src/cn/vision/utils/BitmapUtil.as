package cn.vision.utils
{
	
	/**
	 * 
	 * <code>BitmapUtil</code>定义了一些位图常用函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	
	public final class BitmapUtil extends NoInstance
	{
		
		/**
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
		 * @return BitmapData 返回位图数据。
		 * 
		 */
		public static function draw($source:IBitmapDrawable,
									$width:Number = NaN,
									$height:Number = NaN,
									$transparent:Boolean = true,
									$smoothing:Boolean = false,
									$fillColor:uint = 0,
									$matrix:Matrix = null,
									$colorTransform:ColorTransform = null,
									$blendMode:String = null,
									$clipRect:Rectangle = null):BitmapData
		{
			var source:Object = ($source as Object);
			if (!($width  > 0)) $width  = source.width;
			if (!($height > 0)) $height = source.height;
			var bmd:BitmapData = new BitmapData($width, $height, $transparent, $fillColor);
			bmd.draw($source, $matrix, $colorTransform, $blendMode, $clipRect, $smoothing);
			return bmd;
		}
		
		
		/**
		 * 生成透明通道贴图，透明度为0会转换为黑色，透明度为1会转换为白色。
		 * 
		 * @param $bmd:BitmapData 要转换的位图。
		 * 
		 * @return BitmapData 透明通道BitmapData。
		 * 
		 */
		public static function generateTransparentChannel($bmd:BitmapData):BitmapData
		{
			var result:BitmapData = new BitmapData($bmd.width, $bmd.height, false, 0);
			var rect:Rectangle = new Rectangle(0, 0, $bmd.width, $bmd.height);
			var pixels:Vector.<uint> = $bmd.getVector(rect);
			for (var i:int = 0, l:int = pixels.length; i < l; i++)
			{
				var alpha:uint = ColorUtil.getAlpha(pixels[i]);
				pixels[i] = ColorUtil.join(alpha, alpha, alpha);
			}
			result.setVector(rect, pixels);
			return result;
		}
		
		
		/**
		 * 编码jpg二进制字节流。
		 * 
		 * @param $bitmapData:BitmapData 需要转换的位图。
		 * @param $quality:Number (default = 80) 图片质量，0-100之间的数值。
		 * 
		 * @return ByteArray
		 * 
		 */
		//低版本sdk没有JPEGEncoderOptions，暂时注释掉 - by kim.wu
		/*public static function encodeJPG($bitmapData:BitmapData, $quality:Number = 80):ByteArray
		{
			if ($bitmapData)
			{
				$quality = isNaN($quality) ? 80 : $quality;
				$quality = MathUtil.clamp($quality, 0, 100);
				const options:JPEGEncoderOptions = new JPEGEncoderOptions($quality);
				var bytes:ByteArray = $bitmapData.encode($bitmapData.rect, options);
				bytes.position = 0;
			}
			return bytes;
		}*/
		
	}
}