package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	
	import flash.text.Font;
	
	/**
	 * FontUtil定义了一些字体常用函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class FontUtil extends NoInstance
	{
		
		/**
		 * 检测是否包含字体。
		 * 
		 * @param $font:String
		 * 
		 * @return Boolean
		 * 
		 */
		
		public static function containsFont($font:String):Boolean
		{
			if ($font)
			{
				var result:Boolean = FONTS[$font];
				if(!result)
				{
					var fonts:Array = Font.enumerateFonts(false);
					for each (var font:Font in fonts)
					{
						FONTS[font.fontName] = true;
						result = (font.fontName == $font);
						if (result) break;
					}
				}
			}
			return result;
		}
		
		
		/**
		 * @private
		 */
		private static const FONTS:Object = {};
		
	}
}