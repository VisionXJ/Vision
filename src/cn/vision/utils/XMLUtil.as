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
	
	
	import cn.vision.consts.Consts;
	import cn.vision.core.NoInstance;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	
	public final class XMLUtil extends NoInstance
	{
		
		/**
		 * 
		 * XML或XMLList类型转换。
		 * 
		 * @param $value:* 要转换的XML或XMLList。
		 * @param $type:Class (default = String) 目标类型。
		 * @param $args 其他附加参数。
		 * 
		 * @return 返回目标类型。
		 * 
		 */
		
		public static function convert($value:*, $type:Class = null, ...$args):*
		{
			initializeFuncs();
			$type = $type || String;
			$args.unshift($value);
			return ($type) ? ((FUNCS[$type] == undefined) ? $type($value) : FUNCS[$type].apply(null, $args)) : null;
		}
		
		
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
								? $vo[name] = convert(item, ClassUtil.getClass(type.accessor[name].type))
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
		
		
		/**
		 * @private
		 */
		private static function convertBoolean($value:*):Boolean
		{
			return!($value == "0" || 
					($value == "false") || 
					($value == "False") || 
					($value == 0) || 
					($value == false) || 
					($value == undefined));
		}
		
		/**
		 * @private
		 */
		private static function convertObject($value:*):*
		{
			if ($value is XMLList)
			{
				var r:* = [];
				for each (var i:* in $value)
					r[r.length] = convertObject(i);
			}
			else if ($value is XML)
			{
				var ls:XMLList = $value.children();
				var at:XMLList = $value.attributes();
				var l1:uint = ls.length();
				
				if (l1 < 1 && at.length() == 0)
				{
					r = String($value);
				}
				else
				{
					r = {};
					for each (i in at)
						r["@" + i.name()]= i.toString();
					
					for each(i in ls) 
					{
						var n:String = i.name();
						var o:* = (i.children().length() <= 1) ? i.toString() : convertObject(i);
						var t:* = r[n];
						t ? (t is Array ? t[t.length] = o : r[n] = [t,o]) : r[n] = o;
					}
				}
			}
			return r;
		}
		
		/**
		 * @private
		 */
		private static function convertString($value:*):String
		{
			return $value == undefined ? null : String($value);
		}
		
		/**
		 * @private
		 */
		private static function convertXML($value:*, $name:String = "root"):XML
		{
			if ($value)
			{
				if ($value is XMLList)
				{
					var l:uint = $value.length();
					if (l == 1)
					{
						var xml:XML = $value[0];
					}
					else if (l > 1)
					{
						xml = new XML("<" + $name + "/>");
						for each (var item:XML in $value) xml.appendChild(item);
					}
				}
				else if ($value is XML)
				{
					xml = $value;
				}
				else if ($value is String)
				{
					try {
						xml = XML($value);
					} catch (e:Error) { }
				}
				else
				{
					xml = new XML("<" + $name + "/>");
					for (var key:String in $value) 
					{
						if (ClassUtil.validateMetadata($value[key])) xml[key] = $value[key];
					}
				}
			}
			return xml;
		}
		
		/**
		 * @private
		 */
		private static function initializeFuncs():void
		{
			if(!FUNCS[Consts.INIT])
			{
				FUNCS[Consts.INIT] = true;
				FUNCS[Boolean] = convertBoolean;
				FUNCS[Object ] = convertObject;
				FUNCS[String ] = convertString;
				FUNCS[XML    ] = convertXML;
			}
		}
		
		
		/**
		 * @private
		 */
		private static const FUNCS:Dictionary = new Dictionary;
		
	}
}