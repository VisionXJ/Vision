package cn.vision.pattern.data
{
	
	/**
	 * 
	 * 数据存储器，根据索引存储数据，索引必须保持唯一。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	
	
	public class Holder extends VSObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Holder()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 清空数据。
		 * 
		 */
		
		public function clear():void
		{
			holder.clear();
		}
		
		
		/**
		 * 
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
			var result:Boolean = $key && $data;
			if (result)
			{
				result = ! holder[$key];
				if (result)holder[$key] = $data;
			}
			return result;
		}
		
		
		/**
		 * 
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
			var result:Boolean = holder[$key];
			if (result) delete holder[$key];
			return result;
		}
		
		
		/**
		 * 
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
			return holder[$key] ? holder[$key] : null;
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			holder = new Map;
		}
		
		
		/**
		 * 
		 * 该存储器已注册的数据量。
		 * 
		 */
		
		public function get length():uint
		{
			return holder.length;
		}
		
		
		/**
		 * @private
		 */
		private var holder:Map;
		
	}
}