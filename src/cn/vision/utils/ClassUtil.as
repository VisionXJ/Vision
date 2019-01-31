package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ClassUtil</code> 定义了一些常用类操作函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	
	public final class ClassUtil extends NoInstance
	{
		
		/**
		 * 获取类的实例，类构造函数最多支持20个参数。
		 * 
		 * @param $class:Class 要创建实例的类。
		 * @param ...$args 相关参数。
		 * 
		 * @return * 返回相关实例。
		 * 
		 */
		public static function construct($class:Class, ...$args):*
		{
			var result:*, l:int;
			try
			{
				l = $args.length;
				if ($args && l > 0)
				{
					switch(l)
					{
						case 1 : result = new $class($args[0]); break;
						case 2 : result = new $class($args[0], $args[1]); break;
						case 3 : result = new $class($args[0], $args[1], $args[2]); break;
						case 4 : result = new $class($args[0], $args[1], 
							$args[2], $args[3]); break;
						case 5 : result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4]); break;
						case 6 : result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5]); break;
						case 7 : result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6]); break;
						case 8 : result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7]); break;
						case 9 : result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7], $args[8]); break;
						case 10: result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7], 
							$args[8], $args[9]); break;
						case 11: result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7], 
							$args[8], $args[9], $args[10]); break;
						case 12: result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7], 
							$args[8], $args[9], $args[10], $args[11]); break;
						case 13: result = new $class($args[0], $args[1], 
							$args[2], $args[3], $args[4], $args[5], $args[6], $args[7], 
							$args[8], $args[9], $args[10], $args[11], $args[12]); break;
						case 14: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13]); break;
						case 15: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], $args[14]); break;
						case 16: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], 
							$args[14], $args[15]); break;
						case 17: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], 
							$args[14], $args[15], $args[16]); break;
						case 18: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], 
							$args[14], $args[15], $args[16], $args[17]); break;
						case 19: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], 
							$args[14], $args[15], $args[16], $args[17], $args[18]); break;
						case 20: result = new $class($args[0], $args[1], 
							$args[2 ], $args[3 ], $args[4 ], $args[5 ], $args[6 ], $args[7 ], 
							$args[8 ], $args[9 ], $args[10], $args[11], $args[12], $args[13], 
							$args[14], $args[15], $args[16], $args[17], $args[18], $args[19]); break;
					}
				} else result = new $class;
			} catch (e:Error) { }
			
			return result;
		}
		
		
		/**
		 * 获取对象的类。
		 * 
		 * @param $value 需要返回类的对象。
		 * 
		 * @return Class
		 * 
		 */
		public static function getClass($value:*):Class
		{
			return getClassByName(getClassName($value));
		}
		
		
		/**
		 * 根据完全限定名获取对象的类。
		 * 
		 * @param $qualifiedName:String 完全限定名。
		 * 
		 * @return Class
		 * 
		 */
		public static function getClassByName($qualifiedName:String):Class
		{
			if ($qualifiedName) 
			{
				CLASS_DIC[$qualifiedName] = 
					CLASS_DIC[$qualifiedName] || getDefinitionByName($qualifiedName);
			}
			return CLASS_DIC[$qualifiedName];
		}
		
		
		/**
		 * 获取对象的类名称。
		 * 
		 * @param $value 需要类名称的对象。
		 * @param $qualified(default = true) 是否返回完全限定类名，默认为true。
		 * 
		 * @return String
		 * 
		 */
		public static function getClassName($value:*, $qualified:Boolean = true):String
		{
			if ($value != null)
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
			}
			
			return $qualified ? q : n;
		}
		
		
		/**
		 * 获取实例属性对应的类。
		 * 
		 * @param $value:* 需要获取
		 * 
		 * @return String
		 * 
		 */
		public static function getPropertyClass($value:*, $property:String):Class
		{
			return vs::getPropertyClassByInfo(obtainInfomation($value), $property);
		}
		
		
		/**
		 * 返回函数名。<br>
		 * 注：该方法只在debugger模式下可用。
		 * 
		 * @param $value:Function 需要名称的函数对象。
		 * 
		 * @return String
		 * 
		 */
		public static function getFunctionName($value:Function):String
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
			return result;
		}
		
		
		/**
		 * 
		 * 返回对象的父类名。
		 * 改方法会根据层级返回父类名，并将所有父类名以数组的方式返回。
		 * 
		 * @param $value:* 需要返回父类名的对象。
		 * @param $qualified:Boolean (default = false) 是否要返回完全限定类名，默认为false。
		 * @param $level:uint (default = 1) 父级类名层级，默认为1级。如果level = 0，不会限制父级层级，
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
				v[v.length] = (i == -1 ? n : n.substr(i + 2));
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
		 * 获取实例的信息。
		 * 
		 * @param $value:* 需要获取信息的实例。
		 * 
		 * @return Object 获取的信息。
		 * 
		 */
		
		public static function obtainInfomation($value:*):Object
		{
			return $value ? ObjectUtil.convert(describeType($value), Object) : null;
		}
		
		
		/**
		 * 检测某个值是否为元数据类型，而不是对象引用。
		 * 
		 * @param $value:* 要检测的对象。
		 * 
		 * @return Boolean true为元数据类型，false为非元数据。
		 * 
		 */
		public static function validateMetadata($value:*):Boolean
		{
			return METADATA[getClassName($value)];
		}
		
		
		/**
		 * 根据类名检测某个类型是否为元数据类型，而不是对象引用。
		 * 
		 * @param $className:String 要检测的对象。
		 * 
		 * @return Boolean true为元数据类型，false为非元数据。
		 * 
		 */
		public static function validateMetadataByClassName($className:String):Boolean
		{
			return METADATA[$className];
		}
		
		
		/**
		 * 检测某个类是否为另一类的子类。
		 * 
		 * @param $value 要检测的对象。
		 * @param $superClass 要检测是否为子类对象的父类。
		 * 
		 * @return Boolean true是子类，false不是子类。
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
				var f:String = getClassName($super);
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
		
		
		vs static function getPropertyClassByInfo($info:Object, $property:String):Class
		{
			var item:Object;
			if ($info.variable)
			{
				if (ArrayUtil.validate($info.variable))
				{
					for each (item in $info.variable)
					{
						if (item.name == $property)
							return ClassUtil.getClassByName(item.type);
					}
				}
				else
				{
					item = $info.variable;
					if (item.name == $property)
						return ClassUtil.getClassByName(item.type);
				}
			}
			if ($info.accessor)
			{
				if (ArrayUtil.validate($info.accessor))
				{
					for each (item in $info.accessor)
					{
						if (item.access != "readonly" && item.name == $property) 
							return ClassUtil.getClassByName(item.type);
					}
				}
				else
				{
					item = $info.accessor;
					if (item.access != "readonly" && item.name == $property) 
						return ClassUtil.getClassByName(item.type);
				}
			}
			return null;
		}
		
		
		/**
		 * @private
		 */
		private static const METADATA:Object = 
		{
			"int"       : true,
			"uint"      : true,
			"null"      : true,
			"Number"    : true,
			"String"    : true,
			"Boolean"   : true,
			"undefined" : true
		};
		
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
		
		/**
		 * @private
		 */
		private static const INFO_DIC:Object = {};
		
	}
}