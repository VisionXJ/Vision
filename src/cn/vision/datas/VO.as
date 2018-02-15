package cn.vision.datas
{
	
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.ObjectUtil;
	
	
	[Bindable]
	
	/**
	 * 
	 * 数据结构类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class VO extends VSObject
	{
		
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VO($data:Object = null, $name:String = "vo")
		{
			super();
			
			initialize($data, $name);
		}
		
		
		/**
		 * 
		 * 解析转换数据。
		 * 
		 * @param $data:Object 需要解析的数据。
		 * @param $cover:Boolean 是否覆盖原始数据。
		 * 
		 */
		
		public function parse($data:Object, $cover:Boolean = true):void
		{
			if ($cover)
			{
				if ($data)
				{
					vs::raw = $data;
					data = ObjectUtil.convert($data, Object);
				}
				else data = {};
			}
			else
			{
				ObjectUtil.mapping($data, data = data || {});
			}
		}
		
		
		/**
		 * 
		 * XML格式缓存数据。
		 * 
		 */
		
		public function toXML():String
		{
			return ObjectUtil.convert(data, XML, rootName).toString();
		}
		
		
		/**
		 * 
		 * json格式缓存数据。
		 * 
		 */
		
		public function toJSON():String
		{
			return JSON.stringify(data);
		}
		
		
		/**
		 * 
		 * 返回数据Object。
		 * 
		 */
		
		public function toJSONObject():Object
		{
			return ObjectUtil.clone(data);
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize($data:Object, $name:String):void
		{
			vs::rootName = $name;
			disc = {};
			parse($data);
		}
		
		
		/**
		 * 获取属性。
		 * 
		 * @param $name:String 属性名称。
		 * @param $type:Class 数据类型。
		 * @param $args 其他参数，会根据$type值不同而不同。
		 * 
		 * @return * 属性值。
		 * 
		 */
		protected function getProperty($name:String, $type:Class = null, ...$args):*
		{
			if (disc[$name] == undefined)
			{
				ArrayUtil.unshift($args, data[$name], $type);
				disc[$name] = ObjectUtil.convert.apply(null, $args);
			}
			return disc[$name];
		}
		
		
		/**
		 * 
		 * 设置属性。
		 * 
		 * @param $name:String 属性名称。
		 * @param $value:* 属性值。
		 * 
		 */
		
		protected function setProperty($name:String, $value:*):void
		{
			data[$name] = $value;
			delete disc[$name];
		}
		
		
		/**
		 * 
		 * id
		 * 
		 */
		
		public function get id():String
		{
			return getProperty("id");
		}
		
		/**
		 * @private
		 */
		public function set id($id:String):void
		{
			setProperty("id", $id);
		}
		
		
		/**
		 * 
		 * 根节点名称。
		 * 
		 */
		
		public function get rootName():String
		{
			return vs::rootName;
		}
		
		
		/**
		 * 原始数据。
		 */
		public function get raw():*
		{
			return vs::raw;
		}
		
		
		/**
		 * 存储原始数据。
		 */
		protected var data:Object;
		
		
		/**
		 * 存储转换后的数据。
		 */
		protected var disc:Object;
		
		
		/**
		 * 存储关联数据结构。
		 * @private
		 */
		private var rela:Object;
		
		
		/**
		 * @private
		 */
		vs var raw:*;
		
		/**
		 * @private
		 */
		vs var rootName:String = "vo";
		
	}
}