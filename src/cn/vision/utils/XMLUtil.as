package cn.vision.utils
{
	
	/**
	 * 
	 * <code>XMLUtil</code>定义了一些XML，XMLList操作函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	
	public final class XMLUtil extends NoInstance
	{
		
		/**
		 * 
		 * 将XML的数据映射至Object。
		 * 
		 * @param $xml:XML 映射源XML。
		 * @param $vo:Object 需要映射的Object。
		 * 
		 */
		
		public static function map($xml:XML, $vo:Object):void
		{
			if ($xml && $vo)
			{
				var list:XMLList = $xml.attributes();
				var type:Object = ObjectUtil.obtainInfomation($vo);
				if (list)
				{
					for each (var item:XML in list)
					{
						var name:String = item.name().toString();
						if (name) name = "@" + name;
						if ($vo.hasOwnProperty(name) && $vo[name] != undefined && 
							validateMetadataType(type.accessor[name].type)) $vo[name] = item;
					}
					list = $xml.children();
					for each (item in list)
					{
						name = item.name().toString();
						if ($vo.hasOwnProperty(name))
						{
							validateMetadataType(type.accessor[name].type)
								? $vo[name] = ObjectUtil.convert(item, ClassUtil.getClass(type.accessor[name].type))
								: map(item, $vo[name]);
						}
					}
				}
			}
		}
		
		
		/**
		 * 
		 * 验证是否为XML格式字符串。
		 * 
		 * @param $value:* 验证的字符串。
		 * 
		 * @return Boolean 是否为XML格式字符串。
		 * 
		 */
		
		public static function validate($value:String):Boolean
		{
			return $value.charAt(0) == "<";
		}
		
		
		/**
		 * @private
		 */
		private static function validateMetadataType($type:String):Boolean
		{
			return $type == "String" || 
					$type == "Boolean" || 
					$type == "uint" || 
					$type == "int" || 
					$type == "Number";
		}
		
	}
}