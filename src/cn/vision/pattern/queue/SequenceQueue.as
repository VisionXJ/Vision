package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * 单步命令执行队列。同一时刻只会执行一个命令。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	import cn.vision.pattern.core.Command;
	
	
	public class SequenceQueue extends ParallelQueue
	{
		
		/**
		 * 
		 * <code>SequenceQueue</code>构造函数。
		 * 
		 */
		
		public function SequenceQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute($command:Command = null):void
		{
			if(!vs::executing)
			{
				vs::executing = true;
				queueStart();
			}
			
			commandsIdle[commandsIdle.length] = $command;
			
			executeCommand();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			executor.limit = 1;
		}
		
		
		/**
		 * 
		 * 单线程的最多同时执行线程的个数永远是1。
		 * 
		 */
		
		override public function get limit():uint { return 1; }
		
		/**
		 * @private
		 */
		override public function set limit($value:uint):void { }
		
	}
}