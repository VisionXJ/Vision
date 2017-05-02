package cn.vision.managers
{
	
	/**
	 * 
	 * Object 缓存管理。
	 * 
	 */
	
	import cn.vision.collections.Map;
	import cn.vision.utils.ClassUtil;
	
	
	public final class ObjectManager extends Manager
	{
		
		/**
		 * 
		 * 借出一个实例。如果管理器中不存在该类的实例，会新生成一个实例返回。
		 * 该方法不支持构造函数带有必须输入参数的类，如果传入的类有必须输入的
		 * 参数，且管理器中不存在该类的实例，则会返回null。
		 * 
		 * @param $value:Class 要借出实例的类。
		 * 
		 * @return * 返回的实例。
		 * 
		 */
		
		public static function borrow($type:Class):*
		{
			if ($type)
			{
				var n:String = ClassUtil.getClassName($type, true);
				var p:Map = MAP[n];
				if (p && p.length)
				{
					var t:* = p[p.length - 1];
					delete p[p.length - 1];
				}
				else
				{
					try
					{
						t = new $type();
					} catch (e:Error) { }
				}
			}
			return t;
		}
		
		
		public static function getLength($type:Class = null):uint
		{
			if ($type)
			{
				var n:String = ClassUtil.getClassName($type, true);
				var l:uint = MAP[n] ? MAP[n].length : 0;
			}
			else
			{
				l = length;
			}
			return l;
		}
		
		
		/**
		 * 
		 * 归还一个实例。在要缓存该实例之前，请确保该实例不存在除当前引用外的
		 * 其他引用，并在归还后把当前引用赋值为空。
		 * 
		 * @param $value:* 归还的实例。
		 * 
		 */
		
		public static function remand($value:*):void
		{
			if ($value)
			{
				length++;
				var n:String = ($value.hasOwnProperty("className")) 
					? $value.className 
					: ClassUtil.getClassName($value, true);
				
				var p:Map = MAP[n];
				if(!p) MAP[n] = p = new Map;
				
				if(!p.contains($value))
					p[p.length] = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		private static var length:uint = 0;
		
		/**
		 * @private
		 */
		private static const MAP:Object = {};
		
	}
}