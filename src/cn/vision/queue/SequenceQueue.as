package cn.vision.queue
{
	
	import cn.vision.core.vs;
	import cn.vision.core.Command;
	
	
	/**
	 * 单步命令执行队列。同一时刻只会执行一个命令。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class SequenceQueue extends ParallelQueue
	{
		
		/**
		 * 构造函数。
		 */
		public function SequenceQueue()
		{
			super();
			
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			executor.limit = 1;
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
		 * 单线程的最多同时执行线程的个数永远是1。
		 */
		override public function get limit():uint { return 1; }
		
		/**
		 * @private
		 */
		override public function set limit($value:uint):void { }
		
	}
}