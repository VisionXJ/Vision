package cn.vision.utils
{
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.ClassUtil;
	
	
	/**
	 * 定义了一些常用字符串操作函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class StringUtil extends NoInstance
	{
		
		/**
		 * 比较两个字符串的大小，会将字符串的数字与非数字部分拆分进行比较。
		 * 
		 * @parap $a:String 字符串a。
		 * 
		 * @param $b:String
		 * 
		 */
		public static function compare($a:String, $b:String):int
		{
			return compareString($a, $b);
		}
		
		/**
		 * @private
		 */
		private static function compareString($a:String, $b:String, $ba:uint = 0, $bb:uint = 0):int
		{
			const ea:uint = getSplitIndex($a, $ba);
			const eb:uint = getSplitIndex($b, $bb);
			var sa:* = $a.substr($ba, ea - $ba);
			var sb:* = $b.substr($bb, eb - $bb);
			const na:Number = Number(sa);
			const nb:Number = sb == "" ? NaN : Number(sb);
			sa = isNaN(na) ? sa : na;
			sb = isNaN(nb) ? sb : nb;
			
			if (sa < sb)
			{
				return -1;
			}
			else if (sa > sb)
			{
				return 1;
			}
			else
			{
				if (ea < $a.length || eb < $b.length)
					return compareString($a, $b, ea, eb);
				else
					return 0;
			}
		}
		
		/**
		 * @private
		 * 获取下一个分割点的起始位置。该分割方式会将字符串中的字符与数字隔开，如abc123def会分割为abc，123，def。
		 * 
		 * @param $value:String 要分割的字符串。
		 * @param $start:uint (default = 0) 从$start开始计算。
		 * 
		 * @return uint
		 */
		private static function getSplitIndex($value:String, $start:uint = 0):uint
		{
			const l:int = $value.length;
			if ($start <= l)
			{
				const f:Boolean = isNaN(Number($value.charAt($start++)));
				while($start < l) 
				{
					if (f != isNaN(Number($value.charAt($start)))) 
						break;
					else
						$start++;
				}
			}
			return $start;
		}
		
		
		/**
		 * 验证字符串是否为空。
		 * 
		 * @param $value:String 要验证的字符串。
		 * @param $undefined:Boolean (default = false) 是否将undefined字符串当做undefined未定义变量处理。
		 * 
		 * @return Boolean true为空，false为非空。
		 * 
		 */
		public static function empty($value:String, $undefined:Boolean = false):Boolean
		{
			return $value == null || $value =="" || ($undefined && $value == "undefined");
		}
		
		
		/**
		 * 格式化uint，如果长度不足，会在前面补0。
		 * 
		 * @param $value:uint 要格式化的数值。
		 * @param $length:uint (default = 1) 格式化长度，最多支持10位。
		 * 
		 * @return String 格式化数值字符串。
		 * 
		 */
		public static function formatUint($value:uint, $length:uint = 1):String
		{
			$length = MathUtil.clamp($length, 1, 10);
			var result:String = $value.toString();
			while(result.length < $length) result = "0" + result;
			return result;
		}
		
		
		/**
		 * 字符串如果是英文，转换首字母为大写或小写。
		 * 
		 * @param $value 要转换的字符串
		 * @param $lower (default = true) true为转小写，false为转大写，默认为true。
		 * 
		 */
		public static function lowercaseInitials($value:String, $lower:Boolean = true):String
		{
			var f:String = $value.charAt(0);
			return ($lower ? f.toLowerCase() : f.toUpperCase()) + $value.substr(1);
		}
		
		
		/**
		 * 替换字符串中的某个字符为其他字符。
		 * 
		 * @param $value:String 要操作的字符串。
		 * @param $origin:String 需要替换的部分。
		 * @param $replace:String 替代的字符串。
		 * 
		 * @return String 替换后的字符串。
		 * 
		 */
		public static function replace($value:String, $origin:String, $replace:String):String
		{
			if ($value!= null && $origin!= null && $replace!= null)
				$value = $value.split($origin).join($replace);
			return $value;
		}
		
		
		/**
		 * 转换任意Object为String。
		 * 
		 * @param $value:Object 要转换的Object。
		 * 
		 * @return String 转换后的String。
		 * 
		 */
		public static function toString($value:Object):String
		{
			return $value ? $value.toString() : null;
		}
		
		
		/**
		 * 去除字符串首尾两端的空格。
		 * 
		 * @param $value:String 要操作的字符串。
		 * @param $begin:String 是否去除字符串前端的空格。
		 * @param $end:String 是否去除字符串尾端的空格。
		 * 
		 * @return String 操作后的字符串。
		 * 
		 */
		public static function trim($value:String, $begin:Boolean = true, $end:Boolean = true):String
		{
			if ($value)
			{
				if ($begin) $value = $value.replace(TRIM_B, "");
				if ($end  ) $value = $value.replace(TRIM_E, "");
			}
			return $value;
		}
		
		
		
		/**
		 * 获取换行符，不同的操作系统换行符不同。
		 * 
		 * @return String 换行符。
		 * 
		 */
		public static function get lineEnding():String
		{
			if(!lineEndingSymbol)
			{
				var fileClass:Class = ClassUtil.getClassByName("flash.filesystem.File");
				lineEndingSymbol = fileClass ? fileClass.lineEnding : "\n";
			}
			return lineEndingSymbol;
		}
		
		
		/**
		 * @private
		 */
		private static var lineEndingSymbol:String;
		
		
		/**
		 * @private
		 */
		private static const TRIM_B:RegExp = /^\s*/;
		
		/**
		 * @private
		 */
		private static const TRIM_E:RegExp = /\s*$/;
		
	}
}