package cn.vision.events
{
	
	import cn.vision.core.VSEvent;
	import cn.vision.core.vs;
	import cn.vision.core.State;
	
	
	/**
	 * 状态事件，当状态改变时发送。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class StateEvent extends VSEvent
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 StateEvent.type 访问。
		 * @param $stateOld:State 历史所处状态。
		 * @param $stateNew:State 当下所处状态。
		 * @param $bubbles:Boolean (default = false) 确定 StateEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 StateEvent 对象。默认值为 false。
		 * 
		 */
		public function StateEvent($type:String, $stateOld:String, $stateNew:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			initialize($stateOld, $stateNew);
		}
		
		/**
		 * @private
		 */
		private function initialize($stateOld:String, $stateNew:String):void
		{
			vs::stateOld = $stateOld;
			vs::stateNew = $stateNew;
		}
		
		
		/**
		 * 状态改变后，历史所处状态。
		 */
		public function get stateOld():String
		{
			return vs::stateOld;
		}
		
		/**
		 * 状态改变后，当下所处状态。
		 */
		public function get stateNew():String
		{
			return vs::stateNew;
		}
		
		
		/**
		 * @private
		 */
		vs var stateOld:String;
		
		/**
		 * @private
		 */
		vs var stateNew:String;
		
		
		/**
		 * 状态改变是发送。<br>
		 * STATE_CHANGE常量定义STATE_CHANGE事件的<code>type</code>属性值。
		 * 
		 * @default stateChange
		 * 
		 */
		public static const STATE_CHANGE:String = "stateChange";
		
	}
}