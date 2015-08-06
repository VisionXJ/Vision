package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * <code>Quene</code>是所有队列的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.events.pattern.QueueEvent;
	import cn.vision.pattern.core.Command;
	import cn.vision.utils.LogUtil;
	
	
	/**
	 * 
	 * 队列结束执行时派发。
	 * 
	 */
	
	[Event(name="queueEnd"  , type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 队列开始执行时派发。
	 * 
	 */
	
	[Event(name="queueStart", type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令结束时派发。
	 * 
	 */
	
	[Event(name="stepEnd"   , type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令开始时派发。
	 * 
	 */
	
	[Event(name="stepStart" , type="cn.vision.events.pattern.QueueEvent")]
	
	
	public class Queue extends VSEventDispatcher
	{
		
		/**
		 * 
		 * <code>Quene</code>构造函数。
		 * 
		 */
		
		public function Queue()
		{
			super();
		}
		
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		public function execute($command:Command = null):void
		{
			
		}
		
		
		/**
		 * 
		 * 提前某个命令。
		 * 
		 * @param $command:Command 需要提前的命令实例。
		 * @param $close:Boolean 是否关闭当前正在运行的命令实例。
		 * 
		 */
		
		public function shift($command:Command, $close:Boolean = false):Boolean
		{
			return false;
		}
		
		
		/**
		 * 
		 * 滞后某个命令。
		 * 
		 */
		
		public function delay($command:Command):Boolean
		{
			return false;
		}
		
		
		/**
		 * 
		 * 管理器结束执行任务时调用此方法发送事件。
		 * 
		 */
		
		protected function queueEnd():void
		{
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_END));
		}
		
		
		/**
		 * 
		 * 管理器开始执行任务时调用此方法发送事件。
		 * 
		 */
		
		protected function queueStart():void
		{
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_START));
		}
		
		
		/**
		 * 
		 * 单步命令结束时调用此方法发送事件。
		 * 
		 */
		
		protected function stepEnd($command:Command):void
		{
			dispatchEvent(new QueueEvent(QueueEvent.STEP_END, $command));
		}
		
		
		/**
		 * 
		 * 单步命令开始时调用此方法发送事件。
		 * 
		 */
		
		protected function stepStart($command:Command):void
		{
			dispatchEvent(new QueueEvent(QueueEvent.STEP_START, $command));
		}
		
	}
}