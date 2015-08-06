package cn.vision.utils
{
	
	/**
	 * 
	 * FontUtil定义了一些字体常用函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.text.Font;
	
	
	public final class FontUtil extends NoInstance
	{
		
		/**
		 * 
		 * 检测是否包含字体。
		 * 
		 */
		
		public static function containsFont($value:String):Boolean
		{
			if ($value)
			{
				var result:Boolean = FONTS[$value];
				if(!result)
				{
					var fonts:Array = Font.enumerateFonts(false);
					for each (var font:Font in fonts)
					{
						FONTS[font.fontName] = true;
						result = (font.fontName == $value);
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