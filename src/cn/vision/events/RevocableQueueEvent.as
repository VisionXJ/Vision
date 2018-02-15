package cn.vision.events
{
	
	import cn.vision.core.Command;
	
	
	/**
	 * 撤销重做队列事件。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class RevocableQueueEvent extends QueueEvent
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 CommandEvent.type 访问。
		 * @param $command:RevocableCommand 命令事件的发送者。
		 * @param $bubbles:Boolean (default = false) 确定 CommandEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 CommandEvent 对象。默认值为 false。
		 * 
		 */
		public function RevocableQueueEvent($type:String, $command:Command, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $command, $bubbles, $cancelable);
		}
		
		
		/**
		 * 撤销开始。<br>
		 * UNDO_START常量定义UNDO_START事件的<code>type</code>属性值。
		 * 
		 * @default undoStart
		 * 
		 */
		public static const UNDO_START:String = "undoStart";
		
		
		/**
		 * 撤销结束。<br>
		 * UNDO_END常量定义UNDO_END事件的<code>type</code>属性值。
		 * 
		 * @default undoEnd
		 * 
		 */
		public static const UNDO_END:String = "undoEnd";
		
		
		/**
		 * 重做开始。<br>
		 * REDO_START常量定义REDO_START事件的<code>type</code>属性值。
		 * 
		 * @default redoStart
		 * 
		 */
		public static const REDO_START:String = "redoStart";
		
		
		/**
		 * 重做结束。<br>
		 * REDO_END常量定义REDO_END事件的<code>type</code>属性值。
		 * 
		 * @default redoEnd
		 * 
		 */
		public static const REDO_END:String = "redoEnd";
		
	}
}