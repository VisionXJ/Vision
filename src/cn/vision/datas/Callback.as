package cn.vision.datas
{
	
	import cn.vision.core.VSObject;
	import cn.vision.interfaces.IAvailable;
	
	
	/**
	 * 函数回调类，存储一个函数以及相关参数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Callback extends VSObject implements IAvailable
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $callback:Function 回调函数。
		 * @param $args:Array 相关参数。
		 * 
		 */
		
		public function Callback($callback:Function = null, $args:Array = null)
		{
			super();
			
			initialize($callback, $args);
		}
		
		/**
		 * @private
		 */
		private function initialize($callback:Function, $args:Array):void
		{
			callback = $callback;
			args = $args;
		}
		
		
		/**
		 * 调用函数。
		 * 
		 * @return * 回调函数执行后返回的值。
		 * 
		 */
		public function call():*
		{
			return callback.apply(null, args);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get available():Boolean
		{
			return Boolean(callback);
		}
		
		
		/**
		 * 回掉函数。
		 */
		public var callback:Function;
		
		
		/**
		 * 相关参数。
		 */
		public var args:Array;
		
	}
}