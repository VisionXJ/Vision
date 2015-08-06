package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * 撤销机制命令队列。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	import cn.vision.pattern.core.Command;
	
	
	public final class RevocableCommandQueue extends SequenceQueue
	{
		
		/**
		 * 
		 * <code>RevocableCommandQuene</code>构造函数。
		 * 
		 */
		
		public function RevocableCommandQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			commandsUndo = new Vector.<Command>;
			commandsRedo = new Vector.<Command>;
		}
		
		
		override public function execute($command:Command = null):void
		{
			super.execute($command);
		}
		
		
		/**
		 * 
		 * 撤销上一个命令。
		 * 
		 */
		
		public function undo():void
		{
			
		}
		
		
		/**
		 * 
		 * 重做上一个撤销的命令。
		 * 
		 */
		
		public function redo():void
		{
			
		}
		
		
		/**
		 * 
		 * 队列是否可执行撤销机制。
		 * 
		 */
		
		public function get revocable():Boolean
		{
			return Boolean(vs::revocable);
		}
		
		/**
		 * @private
		 */
		public function set revocable($value:Boolean):void
		{
			if ($value != vs::revocable)
			{
				vs::revocable = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		vs var revocable:Boolean;
		
		
		/**
		 * 可撤销命令队列。
		 */
		private var commandsUndo:Vector.<Command>;
		
		/**
		 * 可重做命令队列。
		 */
		private var commandsRedo:Vector.<Command>;
		
	}
}