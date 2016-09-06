package cn.vision.utils
{
	
	/**
	 * 
	 * 正则表达式工具。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	
	public final class RegexpUtil extends NoInstance
	{
		
		/**
		 * 
		 * 替换字符串中使用大括号引用变量的部分为实际值。
		 * 
		 * @param $target:String 需要替换的字符串。
		 * @param $meta:Object 查找的对象。
		 * 
		 * @return String 替换后的字符串。
		 * 
		 */
		
		public static function replaceTag($target:*, $meta:* = null):String
		{
			if ($target && $meta)
			{
				$target = $target.toString();
				var r:RegExp = /(\{\$?\w+\W*\})/g;
				var a:* = $target.match(r);
				for each (var i:String in a)
				{
					var p:String = removeBrace(i);
					if (p == "$self")
					{
						$target = $target.replace(i, $meta.toString());
					}
					else
					{
						var rep:String = DebugUtil.execute(getTag, false, $meta, p);
						if (rep) $target = $target.replace(i, rep);
					}
				}
			}
			return $target;
		}
		
		
		/**
		 * @private
		 */
		private static function getTag($meta:*, $key:String):String
		{
			return String($meta[$key]);
		}
		
		/**
		 * @private
		 */
		private static function removeBrace($value:String):String
		{
			return $value.slice(1, -1);
		}
		
	}
}