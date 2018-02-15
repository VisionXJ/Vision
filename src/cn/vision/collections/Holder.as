package cn.vision.collections
{
	
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentNotNullError;
	import cn.vision.errors.DestroyNotEmptiedError;
	import cn.vision.utils.ArrayUtil;
	
	
	/**
	 * 数据存储器，根据索引存储数据，索引必须保持唯一。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Holder extends VSObject
	{
		
		/**
		 * 构造函数。
		 */
		public function Holder()
		{
			super();
			
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			holder = {};
			vs::keys = new Vector.<String>;
		}
		
		
		/**
		 * 清空数据。
		 */
		public function clear():void
		{
			holder = {};
			vs::keys.length = 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			holder = null;
			vs::keys = null;
		}
		
		
		/**
		 * 注册数据。
		 * 
		 * @param $key:String 索引。
		 * @param $data:* 注册的数据。
		 * 
		 * @return Boolean true为注册成功，false为失败，可能$key
		 * 或$data不合法，或该索引下已经有数据被注册。
		 * 
		 */
		public function registData($key:String, $data:*):Boolean
		{
			var result:Boolean = $key != null || $data == null;
			if (result)
			{
				result = holder[$key] == null;
				if (result) 
				{
					holder[$key] = $data;
					ArrayUtil.push(vs::keys, $key);
					vs::length += 1;
				}
			}
			else throw new ArgumentNotNullError("$key", "$data");
			
			return result;
		}
		
		
		/**
		 * 移除数据。
		 * 
		 * @param $key:String 索引。
		 * 
		 * @return Boolean true为移除成功，false为失败，可能$key
		 * 不合法，或该索引下没有注册数据。
		 * 
		 */
		public function removeData($key:String):Boolean
		{
			var result:Boolean = $key != null;
			if (result)
			{
				result = holder[$key] != null;
				if (result)
				{
					holder[$key] = null;
					ArrayUtil.remove(vs::keys, false, $key);
					vs::length -= 1;
				}
			}
			else throw new ArgumentNotNullError("$key");
			
			return result;
		}
		
		
		/**
		 * 获取数据。
		 * 
		 * @param $key:String 索引。
		 * 
		 * @return * 获取该索引下已注册的数据，如$key不合法或该索引
		 * 下未注册数据，返回null。
		 * 
		 */
		public function retrieveData($key:String):*
		{
			var result:* = $key != null;
			if (result) result = holder[$key];
			else throw new ArgumentNotNullError("$key");
			
			return result;
		}
		
		
		
		/**
		 * 该存储器已注册的数据量。
		 */
		public function get length():uint
		{
			return vs::length;
		}
		
		/**
		 * 获取当前已注册的索引数组，获取到的数组指示一个副本。
		 */
		public function get keys():Vector.<String>
		{
			return vs::keys.concat();
		}
		
		
		/**
		 * @private
		 */
		private var holder:Object;
		
		
		/**
		 * @private
		 */
		vs var length:uint;
		
		/**
		 * @private
		 */
		vs var keys:Vector.<String>;
		
	}
}