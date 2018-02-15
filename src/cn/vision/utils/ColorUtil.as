package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ColorUtil</code>字符串与uint颜色值转换工具类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	
	public final class ColorUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 转换颜色字符串为uint。
		 * 
		 * @param $value:String
		 * 
		 * @return uint
		 * 
		 */
		
		public static function colorString2uint($value:String):uint
		{
			if ($value.charAt(0) == "#") 
				$value = "0x" + $value.substr(1);
			return uint($value);
		}
		
		
		/**
		 * 
		 * 转换uint为颜色字符串。
		 * 
		 * @param $value
		 * @param $prefix (default = "0x") 前缀可以为 "0x" 或 "#" 。
		 * 
		 * @return String
		 * 
		 */
		
		public static function colorUint2String($value:uint, $prefix:String = "0x"):String
		{
			$prefix = ($prefix=="#") ? "#" : "0x";
			return $prefix + $value.toString(16);
		}
		
		
		/**
		 * 
		 * 拆分ARGB颜色，返回包含R，G，B，A通道值的数组。
		 * 
		 * @param $color:uint 颜色值。
		 * 
		 * @return Array 包含R，G，B，A的数组。
		 * 
		 */
		
		public static function color2argb($color:uint):Array
		{
			var a:uint = $color >> 24 & 0xFF;
			var r:uint = $color >> 16 & 0xFF;
			var g:uint = $color >> 8 & 0XFF;
			var b:uint = $color & 0xFF;
			return [r, g, b, a];
		}
		
		
		/**
		 * 
		 * 合并A，R，G，B通道。
		 * 
		 * @param $r:uint 红色通道。
		 * @param $g:uint 绿色通道。
		 * @param $b:uint 蓝色通道。
		 * @param $a:uint (default = 255) 透明通道。
		 * 
		 * @return uint 合并后的颜色值。
		 * 
		 */
		
		public static function argb2Color($r:uint, $g:uint, $b:uint, $a:uint = 255):uint
		{
			var a:uint = $a << 24;  
			var r:uint = $r << 16;  
			var g:uint = $g << 8;
			return a | r | g | $b;  
		}
		
		
		/**
		 * 
		 * 计算颜色的反色。
		 * 
		 * @param $color:uint 取反的颜色。
		 * 
		 * @return uint 相对的反色。
		 * 
		 */
		
		public static function inverseColor($color:uint):uint
		{
			var rgba:Array = color2argb($color);
			var r:uint = 255 - rgba[0];
			var g:uint = 255 - rgba[1];
			var b:uint = 255 - rgba[2];
			var a:uint = rgba[3];
			return argb2Color(r, g, b, a);
		}
		
		
		/**
		 * 
		 * 获取颜色深浅度，0-1之间的一个数值，值越小，颜色越深。
		 * 
		 * @param $color:uint 取反的颜色。
		 * 
		 * @return Number 颜色深浅系数。
		 * 
		 */
		
		public static function getColorDepth($color:uint):Number
		{
			var rgba:Array = color2argb($color);
			return (rgba[0] * 0.299 + rgba[1] * 0.587 + rgba[2] * 0.114) * MathConsts.vs::COLOR_MOD;
		}
		
		
		/**
		 * 
		 * 设置高亮颜色通道。
		 * 
		 * @param $target:DisplayObject 设置colorTransform的显示对象。
		 * @param $color:uint (default = 0) 要改变的颜色.
		 * @param $offset:Number 颜色深度,0-1之间的一个值,1为完全影响。
		 * 
		 */
		
		public static function changeColorTransform($target:DisplayObject, $color:uint = 0):void
		{
			if ($target)
			{
				var color:ColorTransform = new ColorTransform;
				color.color = $color;
				$target.transform.colorTransform = color;
			}
		}
		
		
		/**
		 * 
		 * 取消颜色通道。
		 * 
		 * @param $displayObject:DisplayObject 显示对象。
		 * 
		 */
		
		public static function resetColorTransform($displayObject:DisplayObject):void
		{
			if ($displayObject)
				$displayObject.transform.colorTransform = new ColorTransform;
		}
		
	}
}