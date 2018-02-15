package cn.vision.events
{
	
	import cn.vision.core.VSEvent;
	import cn.vision.core.vs;
	import cn.vision.core.Command;
	
	import flash.events.Event;

	
	/**
	 * 命令事件，在命令开始或结束时都会触发。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class CommandEvent extends VSEvent
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 CommandEvent.type 访问。
		 * @param $command:Command 命令事件的发送者。
		 * @param $bubbles:Boolean (default = false) 确定 CommandEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 CommandEvent 对象。默认值为 false。
		 * 
		 */
		public function CommandEvent($type:String, $command:Command, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			initialize($command);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CommandEvent(type, command, bubbles, cancelable);
		}
		
		
		/**
		 * 内部初始化。
		 * @private
		 */
		private function initialize($command:Command):void
		{
			vs::command = $command;
		}
		
		
		/**
		 * 命令事件的发送者。 
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
		 * 命令开始执行。<br>
		 * COMMAND_START常量定义COMMAND_START事件的<code>type</code>属性值。
		 * 
		 * @default executeStart
		 * 
		 */
		public static const COMMAND_START:String = "commandStart";
		
		
		/**
		 * 命令结束执行。<br>
		 * COMMAND_END常量定义COMMAND_END事件的<code>type</code>属性值。
		 * 
		 * @default executeEnd
		 * 
		 */
		public static const COMMAND_END:String = "commandEnd";
		
	}
}