package cn.vision.events
{
	
	import cn.vision.core.VSEvent;
	import cn.vision.core.vs;
	
	/**
	 * 超时事件。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class TimeoutEvent extends VSEvent
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 StateEvent.type 访问。
		 * @param $text:String 事件相关消息。
		 * @param $bubbles:Boolean (default = false) 确定 StateEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 StateEvent 对象。默认值为 false。
		 * 
		 */
		public function TimeoutEvent($type:String, $text:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			initialize($text);
		}
		
		/**
		 * 内部初始化。
		 * @private
		 */
		private function initialize($text:String):void
		{
			vs::text = $text;
		}
		
		
		/**
		 * 事件的相关信息。
		 */
		public function get text():String
		{
			return vs::text;
		}
		
		
		/**
		 * @private
		 */
		vs var text:String;
		
		
		/**
		 * 超时发送。<br>
		 * TIMEOUT常量定义TIMEOUT事件的<code>type</code>属性值。
		 * 
		 * @default timeout
		 * 
		 */
		public static const TIMEOUT:String = "timeout";
		
	}
}