package cn.vision.managers
{
	
	import cn.vision.collections.Map;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.ClassUtil;
	
	/**
	 * Object 缓存管理。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ObjectManager extends Manager
	{
		
		/**
		 * 借出一个实例。如果管理器中不存在该类的实例，会新生成一个实例返回。
		 * 该方法不支持构造函数带有必须输入参数的类，如果传入的类有必须输入的
		 * 参数，且管理器中不存在该类的实例，则会返回null。
		 * 
		 * @param $value:Class 要借出实例的类。
		 * @param $key:String (default = null) 关键字索引。
		 * @param ...$args 构造该类实例所需的参数，如果是从缓存中取出一个该类的实例，参数无效。
		 * 
		 * @return * 返回的实例。
		 * 
		 */
		public static function borrow($type:Class, $key:String = null, ...$args):*
		{
			if ($type)
			{
				$key = $key || ClassUtil.getClassName($type, true);
				var p:Map = MAP[$key];
				if (p && p.length)
				{
					var t:* = p[p.length - 1];
					delete p[p.length - 1];
				}
				else
				{
					try
					{
						ArrayUtil.unshift($args, $type);
						t = ClassUtil.construct.apply(null, $args);
					} catch (e:Error) { }
				}
			}
			return t;
		}
		
		
		/**
		 * 缓存的长度。
		 * 
		 * @param $type:Class (default = null) 某个类型的缓存。
		 * @param $key:String (default = null) 关键字索引。
		 * 
		 * @return uint
		 * 
		 */
		public static function length($type:Class = null, $key:String = null):uint
		{
			if ($type)
			{
				$key = $key || ClassUtil.getClassName($type, true);
				var l:uint = MAP[$key] ? MAP[$key].length : 0;
			}
			else
			{
				l = unsigned;
			}
			return l;
		}
		
		
		/**
		 * 归还一个实例。在要缓存该实例之前，请确保该实例不存在除当前引用外的
		 * 其他引用，并在归还后把当前引用赋值为空。
		 * 
		 * @param $value:* 归还的实例。
		 * 
		 */
		public static function remand($value:*, $key:String = null):void
		{
			if ($value)
			{
				unsigned++;
				$key = $key || ClassUtil.getClassName($value, true);
				
				var p:Map = MAP[$key];
				if(!p) MAP[$key] = p = new Map;
				
				if(!p.contains($value))
					p[p.length] = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		private static var unsigned:uint = 0;
		
		/**
		 * @private
		 */
		private static const MAP:Object = {};
		
	}
}