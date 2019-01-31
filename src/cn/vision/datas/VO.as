package cn.vision.datas
{
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.interfaces.IClone;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.ClassUtil;
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
	public class VO extends VSObject implements IClone
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $data:Object (default = null) 数据源。
		 * @param $name:String (default = "root") 转换为XML时的根节点名称。
		 * 
		 */
		public function VO($data:Object = null, $name:String = "root")
		{
			super();
			
			initialize($data, $name);
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize($data:Object, $name:String):void
		{
			vs::rootName = $name;
			parse($data);
		}
		
		
		/**
		 * 克隆一个自身的实例。
		 * 如果VO的子类定义了非property机制的属性，且需要将这种类型的属性复制，
		 * 请覆盖受保护的cloneAttributes方法。
		 * 
		 * @return * 
		 * 
		 * @see cn.vision.datas.VO#cloneAttributes()
		 * 
		 */
		public function clone():*
		{
			return cloneAttributes(new (ClassUtil.getClass(this)));
		}
		
		
		/**
		 * 复制实例时，对属性的复制，子类如果定义了不是通过getProperty和setProperty实现的属性，
		 * 如果这类属性也要复制，请覆盖该方法，并实现这类属性的复制。<br>
		 * 具体做法为：<br>
		 * 1. 重写该方法；<br>
		 * 2. 调用父级的cloneAttributes方法；<br>
		 * 3. 实现子类属性的复制；<br>
		 * 4. 将该方法的$target参数返回。
		 * 
		 * @param $target:* 复制出的新实例。
		 * 
		 * @return * 复制的新实例，该实例会在clone方法中作为返回值返回。
		 * 
		 * @see cn.vision.datas.VO#clone()
		 * 
		 */
		protected function cloneAttributes($target:*):*
		{
			$target.data = ObjectUtil.clone(data);
			$target.vs::raw = vs::raw;
			$target.vs::rootName = vs::rootName;
			//清空属性缓存
			$target.temp = {};
			return $target;
		}
		
		
		/**
		 * 解析数据。
		 * 
		 * @param $data:Object 需要解析的数据。
		 * @param $cover:Boolean 是否覆盖原始数据。<br>
		 * 如果$cover属性为true，会替换原始的raw数据，如：
		 * 原始的raw数据为{label:"vo1", type:"type1"}，新传入的解析数据为{label:"vo2"}，则会丢失type属性。
		 * 
		 */
		public function parse($data:Object, $cover:Boolean = true):void
		{
			if ($cover)
			{
				if ($data)
				{
					vs::raw = $data;
					if((data = ObjectUtil.convert($data, Object)) == vs::raw)
						data = ObjectUtil.clone(vs::raw);
				}
				else data = {};
			}
			else ObjectUtil.mapping($data, data = data || {});
			//清空属性缓存
			temp = {};
		}
		
		
		/**
		 * 导出XML格式数据。
		 */
		public function toXML():String
		{
			return ObjectUtil.convert(toJSONObject(), XML, rootName).toString();
		}
		
		
		/**
		 * 导出json格式数据。
		 */
		public function toJSON():String
		{
			return JSON.stringify(toJSONObject(), null, "  ");
		}
		
		
		/**
		 * 导出数据Object。
		 */
		public function toJSONObject():Object
		{
			return ObjectUtil.clone(data);
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
			if (temp[$name] == undefined)
			{
				ArrayUtil.unshift($args, data[$name], $type);
				temp[$name] = ObjectUtil.convert.apply(null, $args);
			}
			return temp[$name];
		}
		
		
		/**
		 * 设置属性。
		 * 
		 * @param $name:String 属性名称。
		 * @param $value:* 属性值。
		 * 
		 */
		protected function setProperty($name:String, $value:*):void
		{
			if (data[$name]!= $value)
			{
				data[$name] = $value;
				delete temp[$name];
			}
		}
		
		
		/**
		 * 删除属性。
		 * 
		 * @param $name:String 属性名称。
		 * 
		 */
		protected function delProperty($name:String):void
		{
			if (temp[$name]!= undefined) delete temp[$name];
			if (data[$name]!= undefined) delete data[$name];
		}
		
		
		/**
		 * id
		 */
		public function get id():String { return getProperty("id"); }
		public function set id($id:String):void
		{
			setProperty("id", $id);
		}
		
		
		/**
		 * 根节点名称。
		 */
		public function get rootName():String { return vs::rootName; }
		
		
		/**
		 * 原始数据引用。
		 */
		public function get raw():* { return vs::raw; }
		
		
		/**
		 * 属性值字典，数据经过parse，setProperty方法后，会使用该字典记录，并清空对应的临时属性值缓存。
		 */
		protected var data:Object;
		
		
		/**
		 * 属性值缓存。
		 */
		protected var temp:Object;
		
		
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