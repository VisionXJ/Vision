package cn.vision.utils.string
{
	import cn.vision.core.NoInstance;
	import cn.vision.errors.ArgumentNotNullError;
	import cn.vision.errors.ArgumentStringLengthError;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.StringUtil;
	
	import flash.utils.ByteArray;
	
	/**
	 * 中文处理工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class CNUtil extends NoInstance
	{
		
		/**
		 * 获取一串中文的拼音首字母。
		 * 
		 * @param chinese Unicode格式的中文字符串。
		 * 
		 * @return String
		 * 
		 */
		public static function convert(chinese:String):String
		{
			var len:int = chinese.length;
			var ret:String = "";
			for (var i:int = 0;i < len;i++)
				ret += char(chinese.charAt(i));
			return ret;
		}
		
		
		/**
		 * 获取中文第一个字的拼音首字母。
		 * 
		 * @param chineseChar
		 * @return String
		 * 
		 */
		public static function char($char:String):String
		{
			if(!StringUtil.empty($char))
			{
				if ($char.length == 1)
				{
					var n:int = getUnicode($char);
					if (inRange(n))
					{
						if (MathUtil.between(n, 0xB0A1, 0xB0C4)) return "A";
						if (MathUtil.between(n, 0XB0C5, 0XB2C0)) return "B";
						if (MathUtil.between(n, 0xB2C1, 0xB4ED)) return "C";
						if (MathUtil.between(n, 0xB4EE, 0xB6E9)) return "D";
						if (MathUtil.between(n, 0xB6EA, 0xB7A1)) return "E";
						if (MathUtil.between(n, 0xB7A2, 0xB8c0)) return "F";
						if (MathUtil.between(n, 0xB8C1, 0xB9FD)) return "G";
						if (MathUtil.between(n, 0xB9FE, 0xBBF6)) return "H";
						if (MathUtil.between(n, 0xBBF7, 0xBFA5)) return "J";
						if (MathUtil.between(n, 0xBFA6, 0xC0AB)) return "K";
						if (MathUtil.between(n, 0xC0AC, 0xC2E7)) return "L";
						if (MathUtil.between(n, 0xC2E8, 0xC4C2)) return "M";
						if (MathUtil.between(n, 0xC4C3, 0xC5B5)) return "N";
						if (MathUtil.between(n, 0xC5B6, 0xC5BD)) return "O";
						if (MathUtil.between(n, 0xC5BE, 0xC6D9)) return "P";
						if (MathUtil.between(n, 0xC6DA, 0xC8BA)) return "Q";
						if (MathUtil.between(n, 0xC8BB, 0xC8F5)) return "R";
						if (MathUtil.between(n, 0xC8F6, 0xCBF0)) return "S";
						if (MathUtil.between(n, 0xCBFA, 0xCDD9)) return "T";
						if (MathUtil.between(n, 0xCDDA, 0xCEF3)) return "W";
						if (MathUtil.between(n, 0xCEF4, 0xD188)) return "X";
						if (MathUtil.between(n, 0xD1B9, 0xD4D0)) return "Y";
						if (MathUtil.between(n, 0xD4D1, 0xD7F9)) return "Z";
					}
					return $char.toUpperCase();
				} else throw new ArgumentStringLengthError;
			} else throw new ArgumentNotNullError("$char");
		}
		
		
		/** 
		 * 是否为中文 
		 * @param $char:String 中文字符。 
		 * @return Boolean
		 * 
		 */   
		public static function isCN($char:String):Boolean 
		{
			if(!StringUtil.empty($char))
			{
				if ($char.length == 1)
					return inRange(getUnicode($char));
				else
					throw new ArgumentStringLengthError;
			}
			else
				throw new ArgumentNotNullError("$char");
		}
		
		/**
		 * @private
		 */
		private static function getUnicode($char:String):int
		{
			var bytes:ByteArray = new ByteArray;
			bytes.writeMultiByte($char.charAt(0), "cn-gb");
			var n:int = bytes[0] << 8;
			return n + bytes[1];
		}
		
		/**
		 * @private
		 */
		private static function inRange($code:int):Boolean
		{
			return MathUtil.between($code, 0xB0A1, 0xD7F9);
		}
		
		
		/** 
		 * 中文排序
		 * @param arr 列表数组
		 * @param key 键名(键值数组时使用)
		 * 
		 * @return 
		 * 
		 */   
		public static function sort(arr:Array, key:String = ""):Array 
		{
			var byte:ByteArray = new ByteArray, sorted:Array = [];
			var item:*, len:int, i:int, obj:Object;
			for each (item in arr) 
			{
				item = String(key == "" ? item : item[key]).charAt(0);
				byte.writeMultiByte(item, "gb2312");
			}
			byte.position = 0;
			for (i = 0, len = byte.length >> 1; i < len; i++) 
			{
				sorted[sorted.length] = {a: byte[i * 2], b: byte[i * 2 + 1], c: arr[i]};
			}
			sorted.sortOn(["a", "b"], [Array.DESCENDING | Array.NUMERIC]);
			return sorted;
		}
		
	}
}