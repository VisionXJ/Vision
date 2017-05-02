package cn.vision.utils
{
	
	/**
	 * 
	 * 正则表达式工具。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
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
		 * @param ...$args 需要查找的对象，可以是多个，优先使用前面的。
		 * 
		 * @return String 替换后的字符串。
		 * 
		 */
		
		public static function replaceTag($target:*, ...$args):String
		{
			if ($target && $args && $args.length)
			{
				$target = $target.toString();
				var flag:uint = 0;
				var l:uint = $args.length;
				var r:RegExp = /(\{\$?\w+\W*\})/g;
				while (flag < l)
				{
					var $meta:* = $args[flag];
					var a:* = $target.match(r);     //匹配出所有的{...}
					for each (var i:String in a)
					{
						var p:String = removeBrace(i);    //删除两端括号
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
					flag++;
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