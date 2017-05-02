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
	import flash.utils.getQualifiedClassName;
	
	
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
		 * 两个对象的比较。<br>
		 * 支持的类型为：uint,Number,int,Array,Object,Boolean和String。<br>
		 * 特别地，当参数之一存在null、undefined或者NaN之一时会返回false。
		 * @return 相同则返回为true。
		 * 
		 */
		
		public static function compare(a:Object, b:Object):Boolean
		{
			//基本类型不一致直接返回false。
			var result:Boolean = typeof(a) == typeof(b); 
			
			if (result && DIC[typeof(a)])
			{
				switch(typeof(a))
				{
					//非基本类型需要特别比较。
					case "object":   
					{
						result = judgeObject(a, b);
						break;
					}
					//基本类型可以直接比较。
					default:
					{
						result = a == b;
						break;
					}
				}
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
			var fr:String = ClassUtil.getClassName($value, false);
			var to:String = ClassUtil.getClassName($type , false);
			if (convertableMetadata(fr, to))
			{
				var convertFunc:Function = retrieveConvertFunction(fr, to);
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
		 * 从字典中获取除某些元素外的其他元素。
		 * 
		 * @param $dic:Object 要遍历的字典。
		 * @param $args 要排除的元素。
		 * 
		 */
		
		public static function getItems($dic:Object, ...$args):Array
		{
			var result:Array, item:*;
			for each (item in $dic) 
			{
				if (!($args && $args.indexOf(item) >= 0))
				{
					result = result || [];
					ArrayUtil.push(result, item);
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
					var name:String = item.@name;   //读取 XML中的类的属性
					accessor[name] = {};
					accessor[name].type   = item.@type  .toString();
					accessor[name].access = item.@access.toString();
				}
			}
			return obj;
		}
		
		
		/**
		 * 
		 * 获得Object数组的长度。<br>
		 * 特别地，该方法不可以获取其它诸如Array等类型的长度。
		 * @return 该Object数组的长度。
		 * 
		 */
		
		public static function getObjArrLength(o:Object):uint
		{
			var i:uint = 0;
			
			if (ClassUtil.getClassName(o, false) == "Object")
			{
				for (var s:String in o) i++;
			}
			
			return i;
		}
		
		/**
		 * @private
		 */
		private static function convertableMetadata($fr:String, $to:String):Boolean
		{
			return ($to == "Number" || $to == "Boolean") ? true : (CONVERTABLE[$fr] && CONVERTABLE[$to]);
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
		private static function convertvoid2String($value:*):String
		{
			return "";
		}
		
		/**
		 * @private
		 */
		private static function convertObject2Boolean($value:*, $default:Boolean = false):Boolean
		{
			return $value == undefined ? $default
				: !($value == "" || $value == "0" || 
					$value == "false" || $value == "False" || 
					$value == 0 || $value == false);
		}
		
		/**
		 * @private
		 */
		private static function convertObject2Number($value:*, $default:Number = NaN):Number
		{
			var r:Number = Number($value);
			return isNaN(r) ? $default : r;
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
		private static function convertDate2String($date:Date, $formater:String = "YYYY-MM-DD HH:MI:SS:MS", $zeroize:Boolean = true):String
		{
			if ($date)
			{
				if ($formater)
				{
					$formater = $formater.toUpperCase();
					const vectorYear:Array = $formater.match(regExpYear);
					if (vectorYear && vectorYear.length)
					{
						const formatYear:String = vectorYear[0];
						var stringYear:String = String($date.fullYear);
						if(formatYear == "YY") stringYear = stringYear.substr(2);
						$formater = $formater.replace(regExpYear, stringYear);
					}
					
					const vectorHour:Array = $formater.match(regExpHour);
					if (vectorHour && vectorHour.length)
					{
						const formatHour:String = vectorHour[0];
						const endfix:String = formatHour == "HH12" ?($date.hours < 12 ? "a.m." : "p.m."): "";
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
					
					$formater = $formater.replace(/MM/, stringMonth)
						.replace(/DD/, stringDate)
						.replace(/MI/, stringMinutes)
						.replace(/SS/, stringSeconds)
						.replace(/MS/, stringMilliseconds);
				}
				else
				{
					$formater = $date.toString();
				}
			}
			else
			{
				throw new ArgumentError("参数 $date 不能为空", 6001);
			}
			return $formater;
		}
		
		/**
		 * @private
		 */
		private static function convertString2Date($value:String, $formater:String = "YYYY-MM-DD HH:MI:SS:MS"):Date
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
					if (isNaN(temp))
						throw new ArgumentError("参数 $value 不合法，必须是正整数", 6002);
					else
						result = new Date(Number($value));
				}
				else
				{
					var params:Array = [null, null, null, null, null, null, null];
					for (var i:uint = 0; i < 7; i++)
					{
						var exp:String = DATE_REGEXPS[i]
						var index:int = $formater.indexOf(exp);
						if (index != -1)
						{
							var value:* = Number($value.substr(index, exp.length));
							if (isNaN(value) || value == null) 
							{
								value = null;
							}
							else
							{
								value = uint(MathUtil.abs(value));
								if (exp == "MM") value-= 1;
							}
							params[i] = value;
						}
					}
					result = new Date(params[0], params[1], params[2], 
						params[3], params[4], params[5], params[6]);
				}
			}
			else
			{
				throw new ArgumentError("参数 $value 不能为空", 6001);
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private static function convertString2uint($value:String):uint
		{
			if ($value && $value.charAt(0) == "#") $value = "0x" + $value.substr(1);
			return uint($value);
		}
		
		private static function convertString2Number($value:String, $default:Number = NaN):Number
		{
			var result:Number = Number($value);
			if (isNaN(result) && !isNaN($default)) result = $default;
			return result;
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
				for each (var i:* in at) result[String(i.name())]= i;
					
				for each(i in ls) 
				{
					var n:String = i.name();
					var c1:* = i.children()[0];
					if (c1)
					{
						var c2:* = c1.children();
						var o:* = c1 ? ((c2.length() == 0) ? i.toString() : convertXML2Object(i)) : i.toString();
					}
					else
					{
						o = convertXML2Object(i);
					}
					
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
		 * 
		 * 判断传入的对象为哪种非基本类型。
		 * 
		 */
		
		private static function judgeObject(a:Object, b:Object):Boolean
		{
			//类不同直接返回 false。
			var result:Boolean = ClassUtil.getClassName(a, false) == ClassUtil.getClassName(b, false);
			
			if (result)
			{
				if (a is Array)
				{
					result = compareArray(a as Array, b as Array);
				}
				else if (a is Object)
				{
					result = compareObject(a, b);
				}
				else
				{
					//对于非基本类型暂时只支持 Array和 Object的判定。
					result = false;
				}
			}
			
			return result;
		}
		
		
		/**
		 * 
		 * Object类型比较。
		 * 
		 */
		
		private static function compareObject(a:Object, b:Object):Boolean
		{
			var result:Boolean = getObjArrLength(a) == getObjArrLength(b);
			
			if (result)
			{
				for (var sa:String in a)
				{
					if (a[sa] != b[sa])
					{
						result = b[sa] && compare(a[sa], b[sa]);
						
						if (!result) break;
					}
				}
			}
			
			return result;
		}
		
	
		/**
		 * 
		 * 数组类型比较。
		 * 
		 */
		
		private static function compareArray(a:Array, b:Array):Boolean
		{
			var result:Boolean = a.length == b.length;
			var i:uint = 0;
			
			while (result && i < a.length)
			{
				if (a[i] != b[i])
				{
					result = compare(a[i], b[i]);
				}
				
				i++;
			}
			return result;
		}
		
		
		private static const DIC:Object = {
			"object"  : true,
			"uint"    : true,
			"int"     : true,
			"number"  : true,
			"boolean" : true,
			"string"  : true
		};
		
		
		/**
		 * @private
		 */
		private static const CONVERTABLE:Object = 
		{
			"null": true, 
			"void": true, 
			"Date": true,
			"String": true, 
			"Boolean": true, 
			"uint": true, 
			"int": true, 
			"Number": true, 
			"XML" : true, 
			"XMLList": true, 
			"Object": true,
			"Array" : true
		}
		
		/**
		 * @private
		 */
		private static const regExpYear:RegExp = /YY{1,3}/;
		
		/**
		 * @private
		 */
		private static const regExpHour:RegExp = /HH(24|12)?/;
		
		/**
		 * @private
		 */
		private static const DATE_REGEXPS:Array = ["YYYY", "MM", "DD", "HH", "MI", "SS", "MS"];
		
	}
}