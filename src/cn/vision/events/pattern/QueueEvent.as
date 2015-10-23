package cn.vision.events.pattern
{
	
	/**
	 * 
	 * <code>QueueEvent</code>定义了Queue所派发的事件以及事件类型。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEvent;
	import cn.vision.core.vs;
	import cn.vision.pattern.core.Command;
	
	import flash.events.Event;
	
	
	public class QueueEvent extends VSEvent
	{
		
		/**
		 * 
		 * <code>QueueEvent</code>构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 QueueEvent.type 访问。
		 * @param $bubbles:Boolean (default = false) 确定 QueueEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 QueneEvent 对象。默认值为 false。
		 * 
		 */
		
		public function QueueEvent($type:String, $command:Command = null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			initialize($command);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function clone():Event
		{
			return new QueueEvent(type, command, bubbles, cancelable);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($command:Command):void
		{
			vs::command = $command;
		}
		
		
		/**
		 * 
		 * 相关的Command，只在STEP_END和STEP_START事件中有值。
		 * 
		 */
		
		public function get command():Command
		{
			return vs::command;
		}
		
		
		/**
		 * @private
		 */
		vs var command:Command;
		
		
		/**
		 * 
		 * 队列单步命令结束执行时触发，该事件类型只有单步型Manager发送，属于
		 * <code>StepManager</code>以及其子类。<br>
		 * STEP_END常量定义STEP_END事件的<code>type</code>属性值，
		 * 
		 * @default stepEnd
		 * 
		 */
		
		public static const STEP_END:String = "stepEnd";
		
		
		/**
		 * 
		 * 队列单步命令开始执行时触发，<br>
		 * STEP_START常量定义STEP_START事件的<code>type</code>属性值，
		 * 
		 * @default stepStart
		 * 
		 */
		
		public static const STEP_START:String = "stepStart";
		
		
		/**
		 * 
		 * 队列结束执行时触发。<br>
		 * QUENE_END常量定义QUENE_END事件的<code>type</code>属性值，
		 * 
		 * @default queneEnd
		 * 
		 */
		
		public static const QUEUE_END:String = "queueEnd";
		
		
		/**
		 * 
		 * 队列开始执行时触发。<br>
		 * QUENE_START常量定义QUENE_START事件的<code>type</code>属性值，
		 * 
		 * @default queneStart
		 * 
		 */
		
		public static const QUEUE_START:String = "queueStart";
		
	}
}