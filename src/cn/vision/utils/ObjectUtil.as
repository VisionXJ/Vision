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
	
	
	public final class ObjectUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 清空一个Object。<br>
		 * 
		 * @param $value:* 要清空的对象。
		 * 
		 */
		
		public static function clear($value:Object):void
		{
			for (var key:String in $value) delete $value[key];
		}
		
		
		/**
		 * 
		 * 复制一个对象。<br>
		 * 注意：该方法只能复制$value的类型，和Boolean, Number, uint, int, String元数据类型，
		 * 如果$value的属性中包含其他不属于Object类型的属性，会把属性转换为Object类型；
		 * 如果$value是显示对象，只会复制当前显示对象，不会复制该显示对象的绘图与子元素。
		 * 
		 * @param $value:* 要复制的对象。
		 * 
		 * @return * 与$value相同的类型的实例。
		 * 
		 */
		
		public static function clone($value:*):*
		{
			if ($value != null)
			{
				//获取全名
				const typeName:String = ClassUtil.getClassName($value);
				//切出包名
				const packageName:String = typeName.split("::")[0];
				//获取Class
				const type:Class = ClassUtil.getClassByName(typeName);
				//注册Class
				registerClassAlias(packageName, type);
				//复制对象
				const copier:ByteArray = new ByteArray;
				copier.writeObject($value);
				copier.position = 0;
				var result:* = copier.readObject();
			}
			return result;
		}
		
		
		/**
		 * 
		 * 转换数据为另一类型，数据类型的互转，支持int，uint，Number，String，XML，XMLList，Object，Date之间的互相转换，支持JSON字符串转Object。
		 * 
		 * @param $value:* 需要转换的值。
		 * @param $type:Class 要转换成的类型。
		 * $args 附加参数。
		 * 
		 */
		
		public static function convert($value:*, $type:Class = null, ...$args):*
		{
			$type = $type || String;
			if ($value != null && convertableMetadata($value, $type))
			{
				var convertFunc:Function = retrieveConvertFunction(
					ClassUtil.getClassName($value, false), 
					ClassUtil.getClassName($type , false));
				if (convertFunc != null)
				{
					ArrayUtil.unshift($args, $value);
					var result:* = convertFunc.apply(null, $args);
				}
				else
				{
					result = ($value is $type) ? clone($value) : $type($value);
				}
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
		
		
		/**
		 * @private
		 */
		private static function convertableMetadata($value:*, $type:Class):Boolean
		{
			var fr:String = ClassUtil.getClassName($value, false);
			var to:String = ClassUtil.getClassName($type , false);
			return CONVERTABLE[fr] && CONVERTABLE[to];
		}
		
		/**
		 * @private
		 */
		private static function retrieveConvertFunction($fr:String, $to:String):Function
		{
			var result:Function;
			
			if ($to == "Boolean" || $to == "Number")
				result = ObjectUtil["convertObject2" + $to];
			else if ($fr == "XMLList" && $to == "Object")
				result = convertXMLList2Array;
			else
				result = ObjectUtil["convert" + $fr + "2" + $to];
			
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertObject2Boolean($value:*):Boolean
		{
			return!($value == "" || ($value == "0") || 
					($value == "false") || ($value == "False") || 
					($value == 0) || ($value == false) || ($value == undefined));
		}
		
		/**
		 * @private
		 */
		private static function convertObject2Number($value:*):Number
		{
			var r:Number = Number($value);
			return isNaN(r) ? 0 : r;
		}
		
		/**
		 * @private
		 */
		private static function convertObject2XML($value:Object, $name:String = "root"):XML
		{
			var xml:XML = new XML("<" + $name + "/>");
			for (var key:String in $value) 
			{
				var type:String = ClassUtil.getClassName($value[key]);
				switch (type)
				{
					case "Array":
						for each (var i:* in $value[key])
						xml.appendChild(convertObject2XML(i, key));
						break;
					case "Object":
						xml.appendChild(convertObject2XML($value[key], key));
						break;
					default:
						xml[key] = $value[key];
				}
			}
			return xml;
		}
		
		/**
		 * @private
		 */
		private static function convertDate2String($date:Date, $formater:String = "YYYY-MM-DD HH12:MI:SS:MS", $zeroize:Boolean = true):String
		{
			const regExpYear:RegExp = /YY{1,3}/;
			const vectorYear:Array = $formater.match(regExpYear);
			if (vectorYear && vectorYear.length)
			{
				const formatYear:String = vectorYear[0];
				var stringYear:String = String($date.fullYear);
				if(formatYear == "YY") stringYear = stringYear.substr(2);
				$formater = $formater.replace(regExpYear, stringYear);
			}
			
			const regExpHour:RegExp = /HH(24|12)?/;
			const vectorHour:Array = $formater.match(regExpHour);
			if (vectorHour && vectorHour.length)
			{
				const formatHour:String = vectorHour[0];
				const endfix:String = formatHour == "HH12" ?($date.hours < 12 ? " a.m." : " p.m."): "";
				const numberHour:Number = formatHour == "HH12" ?($date.hours < 12 ? $date.hours : $date.hours - 12): $date.hours;
				const stringHour:String = ($zeroize ? StringUtil.formatUint(numberHour, 2) : numberHour) + endfix;
				$formater = $formater.replace(regExpHour, stringHour);
			}
			
			const stringMonth:String = $zeroize 
				? StringUtil.formatUint($date.month + 1, 2) 
				: String($date.month + 1);
			const stringDate:String = $zeroize 
				? StringUtil.formatUint($date.date, 2) 
				: String($date.date);
			const stringMinutes:String = $zeroize
				? StringUtil.formatUint($date.minutes, 2)
				: String($date.minutes);
			const stringSeconds:String = $zeroize
				? StringUtil.formatUint($date.seconds, 2)
				: String($date.seconds);
			const stringMilliseconds:String = $zeroize
				? StringUtil.formatUint($date.milliseconds, 3)
				: String($date.milliseconds);
			
			return $formater.replace(/MM/, stringMonth)
				.replace(/DD/, stringDate)
				.replace(/MI/, stringMinutes)
				.replace(/SS/, stringSeconds)
				.replace(/MS/, stringMilliseconds);
		}
		
		/**
		 * @private
		 */
		private static function convertString2Date($value:String, $formater:String = "YYYY-MM-DD HH12:MI:SS:MS"):Date
		{
			/*$value = StringUtil.trim($value);
			var date:Date = new Date, index:int, value:Number;
			index = $formater.search("YYYY");
			if (index!= -1) 
			{
			value = Number($value.substr(index, 4));
			}
			index = $formater.search("MM");
			if (index!= -1) date.month = Number($value.substr(index, 4));
			*/
			return new Date($value);
		}
		
		/**
		 * @private
		 */
		private static function convertString2uint($value:String):uint
		{
			if ($value && $value.charAt(0) == "#") $value = "0x" + $value.substr(1);
			return uint($value);
		}
		
		/**
		 * @private
		 */
		private static function convertuint2String($value:uint, $radix:uint = 16, $prefix:String = "0x"):String
		{
			$prefix = ($prefix=="#") ? "#" : "0x";
			$prefix = $radix == 16 ? $prefix : "";
			return $prefix + $value.toString($radix);
		}
		
		/**
		 * @private
		 */
		private static function convertString2Object($value:String):Object
		{
			$value = StringUtil.trim($value);
			if (JSONUtil.validate($value))
			{
				try {
					var result:Object = JSON.parse($value);
				} catch(e:Error) {}
			}
			else if (XMLUtil.validate($value))
			{
				try {
					result = convertXML2Object(XML($value));
				} catch(e:Error) {}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertString2XML($value:String):XML
		{
			$value = StringUtil.trim($value);
			if (XMLUtil.validate($value))
			{
				try
				{
					var result:XML = XML($value);
				} catch(e:Error) {}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertXML2Object($value:XML):Object
		{
			var ls:XMLList = $value.children();
			var at:XMLList = $value.attributes();
			var l1:uint = ls.length();
			
			if (l1 < 1 && at.length() == 0)
			{
				var result:Object = String($value);
			}
			else
			{
				result = {};
				for each (var i:* in at)
				result[i.name()]= i.toString();
				
				for each(i in ls) 
				{
					var n:String = i.name();
					var o:* = (i.children().length() <= 1) ? i.toString() : convertXML2Object(i);
					var t:* = result[n];
					t ? (t is Array ? t[t.length] = o : result[n] = [t,o]) : result[n] = o;
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertXMLList2Array($value:XMLList):Array
		{
			var result:Array = [];
			var l1:uint = $value.length();
			for each(var i:XML in $value) 
			result[result.length] = convertXML2Object(i);
			return result;
		}
		
		
		/**
		 * @private
		 */
		private static const CONVERTABLE:Object = 
		{
			"Date": true,
			"String": true, 
			"Boolean": true, 
			"uint": true, 
			"int": true, 
			"Number": true, 
			"XML" : true, 
			"XMLList": true, 
			"Object": true
		}
		
	}
}