package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ArrayUtil</code>定义了一些数组常用函数，也适用于Vector。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.utils.describeType;
	
	
	public final class ArrayUtil extends NoInstance
	{
		
		/**
		 * 
		 * 删除数组中未定义的元素，不会构建新数组。
		 * 
		 * @param $array:* Array或Vector。
		 * 
		 */
		
		public static function normalize($array:*):void
		{
			if (validate($array))
			{
				var flag:uint = 0;
				while (flag < $array.length)
				{
					if ($array[flag] == undefined)
						$array.splice(flag, 1);
					else flag++;
				}
			}
		}
		
		
		/**
		 * 
		 * 移动数组内某个元素设置新的索引位置。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $current:uint 当前要移动的索引。
		 * @param $target:uint 目标索引。
		 * 
		 */
		
		public static function order($array:*, $current:uint, $target:uint):void
		{
			if (validate($array))
			{
				var len:uint = $array.length - 1;
				$current = Math.min($current, len);
				$target  = Math.min($target , len);
				var dir:String = $current < $target ? "negative"
					: ($target < $current ? "positive" : "");
				ArrayUtil[dir] && ArrayUtil[dir]($array, $current, $target);
			}
		}
		
		
		/**
		 * 
		 * 将一个或多个元素添加到数组的结尾，并返回该数组的新长度。 <br>
		 * 此方法比传统的Array.push更快。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $args 要追加到数组中的一个或多个值。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		
		public static function push($array:*, ...$args):uint
		{
			if (validate($array))
			{
				if ($args)
				{
					var l:uint = $args.length;
					if (l)
					{
						for (var i:int = 0; i < l; i++)
							$array[$array.length] = $args[i];
					}
				}
				var result:uint = $array.length;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除数组的一个或多个元素。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $args 要删除的元素。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		
		public static function remove($array:*, ...$args):uint
		{
			if (validate($array))
			{
				for each (var item:* in $args)
				{
					var index:int = $array.indexOf(item);
					if (index > -1) $array.splice(index, 1);
				}
				var result:uint = $array.length;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除数组中第一个元素，并返回该元素。其余数组元素将从其原始位置 i 移至 i-1。 <br>
		 * 此方法比传统的Array.shift更快。
		 * 
		 * @param $array:* Array或Vector。
		 * 
		 * @return * 数组中的第一个元素（可以是任意数据类型）。
		 * 
		 */
		
		public static function shift($array:*):*
		{
			if (validate($array))
			{
				var i:int = $array.length - 1;
				if (i >= 0)
				{
					$array.reverse();
					var result:* = $array[i];
					$array.length = i;
					$array.reverse();
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 删除数组中相同的元素，确保唯一性，并返回新的数组。
		 * 
		 * @param $array:* Array或Vector。
		 * 
		 * @return Array 新的数组。
		 * 
		 */
		
		public static function unique($array:*):Array
		{
			if (validate($array))
			{
				if ($array.length)
				{
					var result:Array = [];
					var a:Object = {};
					for each (var item:uint in $array) 
					{
						if(!a[item]) 
						{
							a[item] = true;
							result[result.length] = item;
						}
					}
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 将一个或多个元素添加到数组的开头，并返回该数组的新长度。
		 * 数组中的其他元素从其原始位置 i 移到 i+1。<br>
		 * 此方法比传统的Array.unshfit更快。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $args 一个或多个要插入到数组开头的数字、元素或变量。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		
		public static function unshift($array:*, ...$args):uint
		{
			if (validate($array))
			{
				if ($args)
				{
					var l:uint = $args.length;
					if (l)
					{
						$array.reverse();
						for (var i:int = l - 1; i >= 0; i--)
							$array[$array.length] = $args[i];
						$array.reverse();
					}
				}
				var result:uint = $array.length;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 验证是否为数组类型Array或Vector。
		 * 
		 * @param $value:* 需要验证的实例。
		 * 
		 * @return Boolean 布尔类型。
		 * 
		 */
		
		public static function validate($value:*):Boolean 
		{
			if ($value)
			{
				var result:Boolean = $value is Array;
				if(!result)
				{
					var type:String = ClassUtil.getClassName($value);
					result = (type.length > 18 && type.slice(0, 19) == "__AS3__.vec::Vector");
				}
			}
			return result;
		} 
		
		
		/**
		 * @private
		 */
		private static function negative($array:*, $current:uint, $target:uint):void
		{
			var t:* = $array[$current];
			for (var i:int = $current; i < $target; i++)
				$array[i] = $array[i + 1];
			$array[$target] = t;
		}
		
		/**
		 * @private
		 */
		private static function positive($array:*, $current:uint, $target:uint):void
		{
			var t:* = $array[$current];
			for (var i:int = $current; i > $target; i--)
				$array[i] = $array[i - 1];
			$array[$target] = t;
		}
		
	}
}