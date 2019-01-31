package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.datas.VO;
	import cn.vision.errors.ArgumentDateError;
	import cn.vision.errors.ArgumentNotNullError;
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	/**
	 * 定义了一些关于<code>Object</code>的操作。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ObjectUtil extends NoInstance
	{
		
		/**
		 * 清空一个Object。<br>
		 * 
		 * @param $value:* 要清空的对象。
		 * 
		 */
		public static function clear($value:Object):void
		{
			while (!empty($value)) for (var key:String in $value) delete $value[key];
		}
		
		
		/**
		 * 复制一个对象。<br>
		 * 注意：该方法只能复制$value的类型，和Boolean, Number, uint, int, String元数据类型，
		 * 如果$value的属性中包含其他不属于Object类型的属性，会把属性转换为Object类型；
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
				var type:Class = ClassUtil.getClassByName(typeName);
				//注册Class
				registerClassAlias(packageName, type);
				//复制对象
				var copier:ByteArray = new ByteArray;
				copier.writeObject($value);
				copier.position = 0;
				var result:* = copier.readObject();
				copier.clear();
				copier = null;
			}
			return result;
		}
		
		
		/**
		 * 判断Object中是否存储任何数据或引用。
		 * 
		 * @param $value:Object 要检测的Object。
		 * 
		 * @return Boolean
		 * 
		 */
		public static function empty($value:Object):Boolean
		{
			for (var key:String in $value) return false;
			return true;
		}
		
		
		/**
		 * 两个对象的比较。<br>
		 * 支持的类型为：uint,Number,int,Array,Object,Boolean和String。<br>
		 * 特别地，当参数之一存在null、undefined或者NaN之一时会返回false。
		 * 
		 * @param $a:* 需要比较的第一个Object。
		 * @param $b:* 需要比较的第二个Object。
		 * 
		 * @return Boolean 相同则返回为true。
		 * 
		 */
		public static function compare(a:*, b:*):Boolean
		{
			return compareInternal(a, b);
		}
		
		/**
		 * @private
		 */
		private static function compareInternal(a:*, b:*):Boolean
		{
			//基本类型不一致直接返回false。
			var ta:String = ClassUtil.getClassName(a);
			var result:Boolean = ta == ClassUtil.getClassName(b);
			if (result)
			{
				var cs:String = ta;
				if (cs.indexOf("Vector") > -1)
					if (ArrayUtil.validate(a)) cs = "Array";
				
				switch(cs)
				{
					case "int":
					case "uint":
					case "null":
					case "Number":
					case "String":
					case "Boolean":
					case "undefined":
						result = a == b; break;
					case "Array":
						result = compareArray(a, b); break;
					default:
						result = compareObject(a, b); break;
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function compareObject(a:Object, b:Object):Boolean
		{
			var result:Boolean = length(a) == length(b);
			if (result)
			{
				for (var key:String in a)
				{
					if(!compareInternal(a[key], b[key])) 
					{
						result = false; break;
					}
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function compareArray(a:Array, b:Array):Boolean
		{
			var l:uint = a.length, result:Boolean = l == b.length, i:int;
			if (result)
			{
				for (; i < l; i += 1)
				{
					if (!compareInternal(a[i], b[i])) result = false; break;
				}
			}
			return result;
		}
		
		
		/**
		 * 转换数据为另一类型，数据类型的互转，支持int，uint，Number，String，XML，XMLList，Object，Date之间的互相转换，支持JSON/XML字符串转自定义类型。
		 * 
		 * @param $value:* 需要转换的值。
		 * @param $type:Class 要转换成的类型。
		 * 
		 * $args 附加参数。
		 * 
		 */
		public static function convert($value:*, $type:Class = null, ...$args):*
		{
			$type = $type || String;
			var fr:String = ClassUtil.getClassName($value, false);
			var to:String = ClassUtil.getClassName($type , false);
			var result:* = $value;
			if (convertableMetadata(fr, to))
			{
				var convertFunc:Function = retrieveConvertFunction(fr, to);
				if (convertFunc != null)
				{
					ArrayUtil.unshift($args, $value, $type);
					result = convertFunc.apply(null, $args);
				}
				else
				{
					if ($value is $type)
					{
						result = clone($value);
					}
					else
					{
						if (ClassUtil.validateSubclass($type, VO))
						{
							result = ClassUtil.construct($type, $value);
						}
						else
						{
							if(!ClassUtil.validateMetadataByClassName(to))
							{
								result = new $type;
								internalMapping($value, result);
							}
							else
							{
								result = $type($value);
							}
						}
					}
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertableMetadata($fr:String, $to:String):Boolean
		{
			var result:Boolean = $fr != $to;
			if (result && $fr != "String" && $to!= "Number" && $to != "Boolean" && $fr != "Object") 
				result = (CONVERTABLE[$fr] && CONVERTABLE[$to]);
			return result;
		}
		
		/**
		 * @private
		 */
		private static const CONVERTABLE:Object = 
			{
				"int"       : true, "XML"       : true, "null"      : true, "void"      : true, "Date"      : true, 
				"uint"      : true, "Array"     : true, "Number"    : true, "String"    : true, "Object"    : true, 
				"XMLList"   : true, "Boolean"   : true, "undefined" : true
			}
			
		/**
		 * @private
		 */
		private static function retrieveConvertFunction($fr:String, $to:String):Function
		{
			var result:Function = ObjectUtil["convert" + $fr + "2" + $to];
			
			if ($to == "Boolean" || $to == "Number" || $to == "uint" || $to == "int" || $to == "String")
				result = result || ObjectUtil["convertComman2" + $to];
			else if ($fr == "void" || $fr == "null" || $fr == "undefined" || $fr == null)
				result = convertEmpty2Empty;
			else if ($fr == "XMLList" && $to == "Object")
				result = convertXMLList2Array;
			else if ($fr == "String")
				result = result || convertString2Comman;
				
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertEmpty2Empty($value:*, $type:Class, $default:* = null):*
		{
			return $default;
		}
		
		/**
		 * @private
		 */
		private static function convertComman2Boolean($value:*, $type:Class, $default:Boolean = false):Boolean
		{
			return  $value == undefined ? $default
				: !($value == 0   || $value == "0"   || 
					$value == ""  || $value == false || 
					String($value).toLowerCase() == "false");
		}
		
		/**
		 * @private
		 */
		private static function convertComman2int($value:*, $type:Class, $default:int = 0):int
		{
			var number:Number = Number($value);
			return isNaN(number) ? $default : int(number);
		}
		
		/**
		 * @private
		 */
		private static function convertComman2uint($value:*, $type:Class, $default:int = 0):int
		{
			$value = String($value);
			if (StringUtil.empty($value))
			{
				var result:uint = $default;
			}
			else
			{
				if ($value && $value.charAt(0) == "#") 
				{
					$value = "0x" + $value.substr(1);
					result = uint($value);
				}
				else
				{
					result = uint(convertComman2int($value, $type, $default))
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertComman2Number($value:*, $type:Class, $default:Number = NaN):Number
		{
			var number:Number = Number($value);
			return isNaN(number) ? $default : number;
		}
		
		/**
		 * @private
		 */
		private static function convertComman2String($value:*, $type:Class, $default:String = null, $undefined:Boolean = true):String
		{
			var string:String = $value ? $value.toString() : null;
			if (StringUtil.empty(string, $undefined)) string = $default;
			return string;
		}
		
		/**
		 * @private
		 */
		private static function convertObject2XML($value:Object, $type:Class, $name:String = "root"):XML
		{
			var result:XML = new XML("<" + $name + "/>");
			for (var key:String in $value) 
			{
				var type:String = ClassUtil.getClassName($value[key]);
				switch (type)
				{
					case "Array":
						for each (var i:* in $value[key]) result.appendChild(convertObject2XML(i, $type, key));
						break;
					case "Object":
						result.appendChild(convertObject2XML($value[key], $type, key));
						break;
					default:
						result[key] = $value[key];
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function convertObject2XMLList($value:Object, $type:Class, $node:String = "item"):XMLList
		{
			if ($value)
			{
				var result:XMLList = new XMLList;
				if ($value is Array)
				{
					for each (var item:* in $value) 
						result.appendChild(convertObject2XML(item, $type, $node));
				}
				else
				{
					result.appendChild(convertObject2XML($value, $type, $node));
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertDate2String($date:Date, $type:Class, $formater:String = "YYYY-MM-DD HH:MI:SS:MS", $zeroize:Boolean = true):String
		{
			if ($date)
			{
				if ($formater)
				{
					$formater = $formater.toUpperCase();
					const vectorYear:Array = $formater.match(REGEX_YEAR);
					if (vectorYear && vectorYear.length)
					{
						const formatYear:String = vectorYear[0];
						var stringYear:String = String($date.fullYear);
						if(formatYear == "YY") stringYear = stringYear.substr(2);
						$formater = $formater.replace(REGEX_YEAR, stringYear);
					}
					
					const vectorHour:Array = $formater.match(REGEX_HOUR);
					if (vectorHour && vectorHour.length)
					{
						const formatHour:String = vectorHour[0];
						const endfix:String = formatHour == "HH12" ?($date.hours < 12 ? "a.m." : "p.m."): "";
						const numberHour:Number = formatHour == "HH12" ?($date.hours < 12 ? $date.hours : $date.hours - 12): $date.hours;
						const stringHour:String = ($zeroize ? StringUtil.formatUint(numberHour, 2) : numberHour) + endfix;
						$formater = $formater.replace(REGEX_HOUR, stringHour);
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
					
					$formater = $formater.replace(/MM/, stringMonth)
						.replace(/DD/, stringDate)
						.replace(/MI/, stringMinutes)
						.replace(/SS/, stringSeconds)
						.replace(/MS/, stringMilliseconds);
				}
				else $formater = $date.toString();
			}
			else
			{
				throw new ArgumentNotNullError("$date");
			}
			return $formater;
		}
		
		/**
		 * @private
		 */
		private static const REGEX_YEAR:RegExp = /YY{1,3}/;
		
		/**
		 * @private
		 */
		private static const REGEX_HOUR:RegExp = /HH(24|12)?/;
		
		/**
		 * @private
		 */
		private static const REGEX_DATES:Array = ["YYYY", "MM", "DD", "HH", "MI", "SS", "MS"];
		
		/**
		 * @private
		 */
		private static function convertString2Comman($value:String, $type:Class):*
		{
			var result:*, temp:Object;
			$value = StringUtil.trim($value);
			if (JSONUtil.validate($value))
			{
				try {
					temp = JSON.parse($value);
				} catch(e:Error) {}
			}
			else if (XMLUtil.validate($value))
			{
				try {
					temp = convertXML2Object(XML($value), $type);
				} catch(e:Error) {}
			}
			
			if (temp)
			{
				if (ClassUtil.validateSubclass($type, VO))
				{
					result = ClassUtil.construct($type, temp);
				}
				else
				{
					result = ClassUtil.construct($type);
					if (result) internalMapping(temp, result);
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertString2Date($value:String, $type:Class, $formater:String = "YYYY-MM-DD HH:MI:SS:MS"):Date
		{
			var result:Date;
			if ($value == "null") return null;
			if ($value)
			{
				$value = StringUtil.trim($value);
				$formater = $formater || "YYYY-MM-DD HH:MI:SS:MS";
				$formater = StringUtil.trim($formater.toUpperCase());
				
				if ($formater == "MS")
				{
					var temp:Number = Number($value);
					if (isNaN(temp)) throw new ArgumentDateError;
					else result = new Date(Number($value));
				}
				else
				{
					var params:Array = [];
					for (var i:uint = 0; i < 7; i++)
					{
						var exp:String = REGEX_DATES[i];
						var index:int = $formater.indexOf(exp);
						if (index != -1)
						{
							var value:Number = Number($value.substr(index, exp.length));
							if (isNaN(value))
							{
								params[i] = null;
							}
							else
							{
								params[i] = uint(MathUtil.abs(value));
								if (exp == "MM") params[i]-= 1;
							}
						}
					}
					result = ClassUtil.construct(Date, params);
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertString2XML($value:String, $type:Class):XML
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
		private static function convertuint2String($value:uint, $type:Class, $radix:uint = 16, $prefix:String = "0x"):String
		{
			return ($radix == 16 ? (($prefix=="#") ? "#" : "0x") : "") + $value.toString($radix);
		}
		
		/**
		 * @private
		 */
		private static function convertXML2Object($value:XML, $type:Class):Object
		{
			var ls:XMLList = $value.children();
			var at:XMLList = $value.attributes();
			var l1:uint = ls.length();
			
			if (l1 < 1 && at.length() == 0)
			{
				var result:Object = $value.toString();
			}
			else
			{
				result = {};
				for each(var i:* in at) result[String(i.name())]= i.toString();
				for each(i in ls) 
				{
					var n:String = i.name();
					var c1:* = i.children()[0];
					if (c1)
					{
						var c2:* = c1.children();
						var o:* = c1 ? (c2.length() == 0 ? i.toString() : convertXML2Object(i, $type)) : i.toString();
					}
					else
					{
						o = convertXML2Object(i, $type);
					}
					
					push(result, n, o, false);
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertXMLList2Array($value:XMLList, $type:Class):Array
		{
			var result:Array = [];
			for each(var i:XML in $value)
				result[result.length] = convertXML2Object(i, $type);
			return result;
		}
		
		
		/**
		 * 从字典中获取除某些元素外的其他元素。
		 * 
		 * @param $dic:Object 要遍历的字典。
		 * @param $args 要排除的元素。
		 * 
		 */
		public static function except($dic:Object, ...$args):Array
		{
			var result:Array = [], item:*;
			for each (item in $dic) 
			{
				if ($args && $args.indexOf(item) == -1) 
					ArrayUtil.push(result, item);
			}
			return result;
		}
		
		
		/**
		 * 获得Object子项个数。<br>
		 * 
		 * @return uint。
		 * 
		 */
		public static function length(o:Object):uint
		{
			var i:uint, k:String;
			for (k in o) i++;
			return i;
		}
		
		
		/**
		 * 将源对象实例的数据映射至目标对象实例。
		 * 
		 * @param $source:Object 源对象实例。
		 * @param $target:* 目标对象实例。
		 * 
		 */
		public static function mapping($source:Object, $target:*):void
		{
			if ($source && $target) internalMapping($source, $target);
		}
		
		/**
		 * @private
		 */
		private static function internalMapping($source:Object, $target:*):void
		{
			var info:Object = ClassUtil.obtainInfomation($target);
			$source = convertXMLSource($source);
			info.isDynamic == "true"
				? dynamicMapping($source, $target, info)
				: staticMapping ($source, $target, info);
		}
		
		/**
		 * @private
		 */
		private static function convertXMLSource($source:*):*
		{
			if ($source is XML)
				$source = convertXML2Object($source, Object);
			else if ($source is XMLList)
				$source = convertXMLList2Array($source, Array);
			return $source;
		}
		
		/**
		 * @private
		 */
		private static function dynamicMapping($source:Object, $target:Object, info:Object):void
		{
			var sourceType:Class, targetType:Class, key:String;
			if (ArrayUtil.validateVector($target))
			{
				targetType = ArrayUtil.getVectorItemClass($target);
				for (key in $source)
					setVectorValue($source, $target, targetType, key);
			}
			else
			{
				for (key in $source)
				{
					sourceType = ClassUtil.getClass($source[key]);
					if (sourceType != null)
					{
						targetType = ClassUtil.vs::getPropertyClassByInfo(info, key) || sourceType;
						setDynamicValue($source, $target, targetType, key);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private static function setVectorValue($source:*, $target:*, $type:Class, $key:String):void
		{
			if (ClassUtil.validateMetadata($type))
			{
				$target[$key] = convert($source[$key], $type);
			}
			else
			{
				var i:Number = Number($key);
				if (MathUtil.integer(i))
				{
					if ($target.length <= i)
					{
						$target[$key] = ClassUtil.construct($type);
						if  ($target[$key] != null) internalMapping($source[$key], $target[$key]);
					}
				}
				else
				{
					$target[$key] = $target[$key] || ClassUtil.construct($type);
					if  ($target[$key] != null) internalMapping($source[$key], $target[$key]);
				}
			}
		}
		
		/**
		 * @private
		 */
		private static function setDynamicValue($source:*, $target:*, $type:Class, $key:String):void
		{
			if (ClassUtil.validateMetadata($type))
			{
				$target[$key] = convert($source[$key], $type);
			}
			else
			{
				$target[$key] = $target[$key] || ClassUtil.construct($type);
				if  ($target[$key] != null) internalMapping($source[$key], $target[$key]);
			}
		}
		
		/**
		 * @private
		 */
		private static function staticMapping($source:Object, $target:*, info:Object):void
		{
			var key:String, type:Class, data:*;
			if (info.variable != null)
			{
				if (ArrayUtil.validate(info.variable))
					for each (var item:* in info.variable) setStaticValue($source, $target, item);
				else
					setStaticValue($source, $target, info.variable);
			}
			if (info.accessor != null)
			{
				if (ArrayUtil.validate(info.accessor))
				{
					for each (item in info.accessor)
					{
						if (item.access != "readonly") 
							setStaticValue($source, $target, item);
					}
				}
				else
				{
					if (info.accessor.access != "readonly") 
						setStaticValue($source, $target, info.accessor);
				}
			}
		}
		
		/**
		 * @private
		 */
		private static function setStaticValue($source:*, $target:*, $item:* = null):void
		{
			var type:Class = ClassUtil.getClassByName($item.type);
			var key:String = $item.name;
			if ($source[key] != undefined)
			{
				if (ClassUtil.validateMetadata(type))
				{
					$target[key] = convert($source[key], type);
				}
				else
				{
					if ($source[key] != null)
					{
						$target[key] = $target[key] || ClassUtil.construct(type);
						if ($target[key]) internalMapping($source[key], $target[key]);
					}
				}
			}
		}
		
		
		/**
		 * 将数据按照索引使用$object存储，如果$object中$key已被占用，会将$object[key]修改为一个数组存储。
		 * 
		 * @param $object:Object 存储值的object对象。
		 * @param $key:* 索引。
		 * @param $value:* 要存储的值。
		 * @param $unique:Boolean (default = true) 是否保证数据的唯一性，默认false。
		 * @param $null:Boolean (default = false) 是否允许空值，默认为false。
		 * 
		 */
		public static function push($object:Object, $key:*, $value:*, $unique:Boolean = true, $null:Boolean = false):void
		{
			if ($null || (!$null && $value != null))
			{
				var item:* = $object[$key];
				if (item)
				{
					if (item is Array)
					{
						if (!$unique || ($unique && item.indexOf($value) == -1))
							item[item.length] = $value;
					}
					else
					{
						if (!$unique || ($unique && item!= $value))
							$object[$key] = [item, $value];
					}
				}
				else $object[$key] = $value;
			}
		}
		
		
		/**
		 * 从动态Object中删除索引为$key的元素，并将该元素返回。
		 * 
		 * @param $o:Object 要操作的Object。
		 * @param $key:String 键值索引。
		 * 
		 * @return 删除的元素。
		 * 
		 */
		public static function remove($o:Object, $key:String):*
		{
			var result:Object = $o[$key];
			delete $o[$key];
			return result;
		}
		
		
		/**
		 * 赋值操作。
		 * 
		 * @param $o:Object 要存储数据的Object。
		 * @param $key:String 索引。
		 * @param $value:* 值。
		 * @param $default:* (default = null) 默认值，如果$value为undefined，则会设为该值。
		 * 
		 */
		public static function value($o:Object, $key:String, $value:*, $default:* = null):void
		{
			$value != undefined ? $o[$key] = $value : ($default != null ? $o[$key] = $default : void);
		}
		
	}
}