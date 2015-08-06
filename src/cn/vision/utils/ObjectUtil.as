package cn.vision.utils
{
	
	/**
	 * 
	 * <code>ObjectUtil</code>定义了一些关于<code>Object</code>的操作。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	public final class ObjectUtil extends NoInstance
	{
		
		/**
		 * 
		 * 复制一个对象。<br>
		 * 注意：该方法只能复制$source的类型，和Boolean, Number, uint, int, String元数据类型，
		 * 如果$source的属性中包含其他不属于Object类型的属性，会把属性转换为Object类型；
		 * 如果$source是显示对象，只会复制当前显示对象，不会复制该显示对象的绘图与子元素。
		 * 
		 * @param $value:* 要复制的对象。
		 * 
		 * @return * 与$value相同的类型的实例。
		 * 
		 */
		
		public static function clone($value:*):*
		{
			var result:*;
			if ($value)
			{
				//获取全名
				var typeName:String = getQualifiedClassName($value);
				//切出包名
				var packageName:String = typeName.split("::")[0];
				//获取Class
				var type:Class = getDefinitionByName(typeName) as Class;
				//注册Class
				registerClassAlias(packageName, type);
				//复制对象
				var copier:ByteArray = new ByteArray;
				copier.writeObject($value);
				copier.position = 0;
				result = copier.readObject();
			}
			return result;
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
			if ($value)
			{
				var obj:Object = {};
				var xml:XML = describeType($value);
				var accessor:Object = obj.accessor = {};
				for each (var item:XML in xml.accessor)
				{
					var name:String = item.@name;
					accessor[name] = {};
					accessor[name].type   = item.@type  .toString();
					accessor[name].access = item.@access.toString();
				}
			}
			return obj;
		}
		
	}
}