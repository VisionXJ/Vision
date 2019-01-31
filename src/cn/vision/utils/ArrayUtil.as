package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	
	import flash.utils.Dictionary;
	
	/**
	 * 定义了一些数组常用函数，也适用于Vector。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArrayUtil extends NoInstance
	{
		
		/**
		 * 删除数组中未定义的元素，不会构建新数组。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $empty:Boolean （default = false) 是否删除字符为空的元素。
		 * 
		 */
		public static function normalize($array:*, $empty:Boolean = false):void
		{
			var flag:uint = 0;
			while (flag < $array.length)
			{
				if ($array[flag] == undefined || 
					($empty && StringUtil.empty($array[flag], true)))
					$array.splice(flag, 1);
				else flag++;
			}
		}
		
		
		/**
		 * 移动数组内某个元素设置新的索引位置，会影响这2个元素之间的元素顺序。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $current:uint 当前要移动的索引。
		 * @param $target:uint 目标索引。
		 * 
		 */
		public static function move($array:*, $current:uint, $target:uint):void
		{
			var len:uint = $array.length - 1;
			$current = Math.min($current, len);
			$target  = Math.min($target , len);
			var dir:String = $current < $target ? "negative" 
				: ($target < $current ? "positive" : "");
			if (dir != "") ArrayUtil[dir]($array, $current, $target);
		}
		
		/**
		 * @private
		 * Up2Down
		 */
		private static function negative($array:*, $current:uint, $target:uint):void
		{
			var t:* = $array[$current];
			for (var i:int = $current; i < $target; i++) $array[i] = $array[i + 1];
			$array[$target] = t;
		}
		
		/**
		 * @private
		 * Down2Up
		 */
		private static function positive($array:*, $current:uint, $target:uint):void
		{		
			var t:* = $array[$current];
			for (var i:int = $current; i > $target; i--) $array[i] = $array[i - 1];
			$array[$target] = t;
		}
		
		
		/**
		 * 将一个或多个元素添加到数组的结尾，并返回该数组的新长度。 <br>
		 * 此方法比内置的API Array.push更快。
		 * 
		 * @param $array:* Array或Vector。
		 * @param $args 要追加到数组中的一个或多个值。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		public static function push($array:*, ...$args):uint
		{
			for each(var item:* in $args) $array[$array.length] = item;
			return $array.length;
		}
		
		
		/**
		 * 将给定数组添加到原数组的结尾，并返回该数组的新长度。 <br>
		 * 
		 * @param $array:* Array或Vector。
		 * @param $args 要追加到原数组中的一个数组。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		public static function concat($array:*, $args:*):uint
		{
			for each (var item:* in $args) $array[$array.length] = item;
			return $array.length;
		}
		
		
		/**
		 * 删除数组的一个或多个元素。<br>
		 * 
		 * @param $array:* Array或Vector。
		 * @param $lazy:Boolean (default = true) 如果数组中包含多个相同的元素，lazy为true时，只会删除第一个，否则会全部删除。
		 * @param $args 要删除的元素。
		 * 
		 * @return uint 一个整数，表示该数组的新长度。
		 * 
		 */
		public static function remove($array:*, $lazy:Boolean = true, ...$args):int
		{
			var result:int = -1;
			for each (var item:* in $args)
			{
				var index:int = $array.indexOf(item);
				while (index > -1)
				{
					$array.removeAt(index);
					if ($lazy) break;
					index = $array.indexOf(item);
				}
			}
			result = $array.length;
			return result;
		}
		
		
		/**
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
			var i:int = $array.length - 1;
			if (i >= 0)
			{
				$array.reverse();
				var result:* = $array[i];
				$array.length = i;
				$array.reverse();
			}
			return result;
		}
		
		
		/**
		 * 删除数组中相同的元素，确保唯一性，并返回新的数组。
		 * 
		 * @param $array:* Array或Vector。
		 * 
		 * @return Array 新的数组。
		 * 
		 */
		public static function unique($array:*):Array
		{
			var result:Array = [];
			if ($array.length)
			{
				var a:Dictionary = new Dictionary, item:*;
				for each (item in $array) 
				{
					if(!a[item])
					{
						a[item] = true;
						result[result.length] = item;
					}
				}
			}
			return result;
		}
		
		
		/**
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
			var l:uint = $args.length, i:int;
			if (l)
			{
				$array.reverse();
				for (i = l - 1; i >= 0; i--)
					$array[$array.length] = $args[i];
				$array.reverse();
			}
			return $array.length;
		}
		
		
		/**
		 * 验证是否为数组类型Array或Vector。
		 * 
		 * @param $value:* 需要验证的实例。
		 * 
		 * @return Boolean 布尔类型。
		 * 
		 */
		public static function validate($value:*):Boolean 
		{
			var result:Boolean = $value is Array;
			if(!result) result = validateVector($value);
			return  result;
		}
		
		
		/**
		 * 验证是否为数组类型Vector。
		 * 
		 * @param $value:* 需要验证的实例。
		 * 
		 * @return Boolean 布尔类型。
		 * 
		 */
		public static function validateVector($value:*):Boolean
		{
			var type:String = ClassUtil.getClassName($value);
			var result:Boolean = (type.length > 18 && type.slice(0, 19) == "__AS3__.vec::Vector");
			return  result;
		}
		
		
		/**
		 * 获取Vector数组变量的子元素类。
		 * 
		 * @param $value:* 需要获取子元素类的Vector数组。
		 * 
		 * @return Class 子元素类。
		 * 
		 */
		public static function getVectorItemClass($value:*):Class
		{
			const name:String = ClassUtil.obtainInfomation($value).name;
			return ClassUtil.getClassByName(name.slice(name.indexOf("<") + 1, name.indexOf(">")));
		}
		
		/**
		 * 将Vector转为Array。
		 * 
		 * @param $value:Vector 要转换的Vector。
		 * 
		 * @return Array 转换后的Array。
		 * 
		 */
		public static function vector2Array($value:*):Array
		{
			var result:Array = [];
			for (var i:int = 0, l:int = $value.length; i < l; i++) result[i] = $value[i];
			return result;
		}
		
	}
}