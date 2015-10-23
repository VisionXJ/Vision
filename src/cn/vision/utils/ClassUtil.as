package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ClassUtil</code> 定义了一些常用类操作函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.VSCache;
	import cn.vision.core.vs;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	
	public final class ClassUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取对象的类。
		 * 
		 * @param $value 需要返回类的对象。
		 * 
		 * @return <code>Class</code>
		 * 
		 */
		
		public static function getClass($value:*):Class
		{
			return getClassByName(getClassName($value));
		}
		
		
		/**
		 * 
		 * 根据完全限定名获取对象的类。
		 * 
		 * @param $qualifiedName:String 完全限定名。
		 * 
		 * @return <code>Class</code>
		 * 
		 */
		
		public static function getClassByName($qualifiedName:String):Class
		{
			return CLASS_DIC[$qualifiedName] = CLASS_DIC[$qualifiedName] || getDefinitionByName($qualifiedName);
		}
		
		
		/**
		 * 
		 * 获取对象的类名称。
		 * 
		 * @param $value 需要类名称的对象。
		 * @param $qualified(default = true) 是否返回完全限定类名，默认为true。
		 * 
		 * @return <code>String</code>
		 * 
		 */
		
		public static function getClassName($value:*, $qualified:Boolean = true):String
		{
			if (! ($value is Class) || ! NAME_DIC[$value])
			{
				var q:String = getQualifiedClassName($value);
				var i:int = q.search("::");
				var n:String = q.substr(i == -1 ? 0 : i + 2);
				if ($value is Class)
				{
					NAME_DIC[$value] = n;
					QUALIFIED_NAME_DIC[$value] = q;
				}
			}
			else
			{
				n = NAME_DIC[$value];
				q = QUALIFIED_NAME_DIC[$value];
			}
			return $qualified ? q : n;
		}
		
		
		/**
		 * 
		 * 返回函数名。
		 * 
		 * @param $value 需要名称的函数对象。
		 * 
		 * @return <code>String</code>
		 * 
		 */
		
		public static function getFunctionName($value:Function):String
		{
			if ($value is Function) 
			{
				try
				{
					NoInstance($value);
				}
				catch(error:Error)
				{
					var m:String = error.message;
					// start of first line
					var s:int = m.indexOf("/");
					// end of function name
					var e:int = m.indexOf("()");
					var result:String = m.substring(s + 1, e);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 返回对象的父类名。
		 * 改方法会根据层级返回父类名，并将所有父类名以数组的方式返回。
		 * 
		 * @param $value 需要返回父类名的对象。
		 * @param $qualified (default = false) 是否要返回完全限定类名，默认为false。
		 * @param $level (default = 1) 父级类名层级，默认为1级。如果level = 0，不会限制父级层级，
		 * 将遍历至基类Object；如果大于0，会遍历至限定的层级；如果限定层级大于该对象最大父级层级，
		 * 只会遍历至Object，默认为1。
		 * 
		 * @return * 如果是只有一级，直接返回父类的名称，如果是多级，返回一个父类名的集合Vector.<String>;
		 * 
		 */
		
		public static function getSuperClassNameArray($value:*, $qualified:Boolean = true, $level:uint = 1):*
		{
			var i:int = -1;
			var v:Vector.<String> = new Vector.<String>;
			var n:String = getQualifiedSuperclassName($value);
			while ($level >= 0 && n) 
			{
				if(!$qualified) i = n.indexOf("::");
				v.push((i == -1)
					? n
					: n.substr(i + 2));
				if ($level != 1) 
				{
					n = getQualifiedSuperclassName(getDefinitionByName(n));
					if ($level > 1) $level--;
				} else break;
			}
			return (v.length <= 1) ? (v[0] ? v[0] : null) : v;
		}
		
		
		/**
		 * 
		 * 检测某个值是否为元数据类型，而不是对象引用。
		 * 
		 * @param $value 要检测的对象。
		 * 
		 * @return <code>Boolean</code> true为元数据类型，false为非元数据。
		 * 
		 */
		
		public static function validateMetadata($value:*):Boolean
		{
			return $value is String || 
					$value is uint || 
					$value is int || 
					$value is Number || 
					$value is Boolean;
		}
		
		
		/**
		 * 
		 * 检测某个类是否为另一类的子类。
		 * 
		 * @param $value 要检测的对象。
		 * @param $superClass 要检测是否为子类对象的父类。
		 * 
		 * @return <code>Boolean</code> true是子类，false不是子类。
		 * 
		 */
		
		public static function validateSubclass($value:Class, $super:Class):Boolean
		{
			if ($super == Object)
			{
				return true;
			}
			else
			{
				var n:String = getQualifiedSuperclassName($value);
				var f:String = getQualifiedClassName($super);
				while ( n && n != "Object")
				{
					if( n == f)
						return true;
					else
						n = getQualifiedSuperclassName(getDefinitionByName(n));
				}
				return false;
			}
		}
		
		
		/**
		 * @private
		 */
		private static const NAME_DIC:Dictionary = new Dictionary;
		
		/**
		 * @private
		 */
		private static const QUALIFIED_NAME_DIC:Dictionary = new Dictionary;
		
		/**
		 * @private
		 */
		private static const CLASS_DIC:Object = {};
		
	}
}