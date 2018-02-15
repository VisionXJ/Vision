package cn.vision.queue
{
	
	import cn.vision.commands.RevokableCommand;
	import cn.vision.core.Command;
	import cn.vision.core.vs;
	import cn.vision.events.CommandEvent;
	import cn.vision.events.RevocableCommandEvent;
	import cn.vision.events.RevocableQueueEvent;
	import cn.vision.utils.ArrayUtil;
	
	
	/**
	 * 
	 * 撤销开始时派发此事件。
	 * 
	 */
	
	[Event(name="undoStart", type="cn.vision.events.RevocableQueueEvent")]
	
	
	/**
	 * 
	 * 撤销结束时派发此事件。
	 * 
	 */
	
	[Event(name="undoEnd", type="cn.vision.events.RevocableQueueEvent")]
	
	
	/**
	 * 
	 * 重做开始时派发此事件。
	 * 
	 */
	
	[Event(name="redoStart", type="cn.vision.events.RevocableQueueEvent")]
	
	
	/**
	 * 
	 * 重做结束时派发此事件。
	 * 
	 */
	
	[Event(name="redoEnd", type="cn.vision.events.RevocableQueueEvent")]
	
	
	/**
	 * 撤销机制命令队列。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class RevokableCommandQueue extends SequenceQueue
	{
		
		/**
		 * 构造函数。
		 */
		public function RevokableCommandQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			commandsUndo = new Vector.<RevokableCommand>;
			commandsRedo = new Vector.<RevokableCommand>;
		}
		
		
		/**
		 * 撤销上一个命令。
		 */
		public function undo():void
		{
			if(!executing && undoable)
			{
				vs::executing = true;
				var command:RevokableCommand = ArrayUtil.shift(commandsUndo);
				command.addEventListener(CommandEvent.COMMAND_START, command_undoStartHandler);
				command.addEventListener(CommandEvent.COMMAND_END, command_undoEndHandler);
				command.undo();
			}
		}
		
		
		/**
		 * 重做上一个撤销的命令。
		 */
		public function redo():void
		{
			if(!executing && redoable)
			{
				vs::executing = true;
				var command:RevokableCommand = commandsRedo.pop();
				command.addEventListener(CommandEvent.COMMAND_START, command_redoStartHandler);
				command.addEventListener(CommandEvent.COMMAND_END, command_redoEndHandler);
				command.redo();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function executeCommand():void
		{
			if (commandsIdle.length)
			{
				//闲置队列中还有命令，检测Executor能否接受新命令执行。
				if (executor.acceptable)
				{
					//可接受新命令，抽取并执行。
					var command:Command = ArrayUtil.shift(commandsIdle);
					//判断是否为可撤销命令
					var revoke:RevokableCommand = command as RevokableCommand;
					if (revoke && revoke.revokable)
					{
						//添加事件回调。
						command.addEventListener(CommandEvent.COMMAND_END, command_executeHandler);
						//清空重做队列。
						commandsRedo.length = 0;
					}
					executor.execute(command);
				}
			}
			else
			{
				if(!executor.num)
				{
					//队列中的命令已执行完毕，判断当前是否还有任务在执行。
					vs::executing = false;
					queueEnd();
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function pushCommandToUndos($command:RevokableCommand):void
		{
			if ($command.revokable)
			{
				if (maxHistoryLength && commandsUndo.length >= maxHistoryLength) commandsUndo.pop();
				ArrayUtil.unshift(commandsUndo, $command);
			}
		}
		
		/**
		 * @private
		 */
		private function pushCommandToRedos($command:RevokableCommand):void
		{
			ArrayUtil.push(commandsRedo, $command);
		}
		
		
		/**
		 * @private
		 */
		private function command_executeHandler($e:CommandEvent):void
		{
			var command:RevokableCommand = $e.command as RevokableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_executeHandler);
			//命令执行完毕，加入撤销队列。
			pushCommandToUndos(command);
		}
		
		/**
		 * @private
		 */
		private function command_undoStartHandler($e:CommandEvent):void
		{
			var command:RevokableCommand = $e.command as RevokableCommand;
			command.removeEventListener(CommandEvent.COMMAND_START, command_undoStartHandler);
			
			QUEUE_UNDO_START.vs::command = command;
			dispatchEvent(QUEUE_UNDO_START);
		}
		
		/**
		 * @private
		 */
		private function command_undoEndHandler($e:CommandEvent):void
		{
			vs::executing = false;
			var command:RevokableCommand = $e.command as RevokableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_undoEndHandler);
			//命令撤销完毕，加入可重做队列。
			pushCommandToRedos(command as RevokableCommand);
			
			QUEUE_UNDO_END.vs::command = command;
			dispatchEvent(QUEUE_UNDO_END);
		}
		
		/**
		 * @private
		 */
		private function command_redoStartHandler($e:CommandEvent):void
		{
			var command:RevokableCommand = $e.command as RevokableCommand;
			command.removeEventListener(CommandEvent.COMMAND_START, command_redoStartHandler);
			
			QUEUE_REDO_START.vs::command = command;
			dispatchEvent(QUEUE_REDO_START);
		}
		
		/**
		 * @private
		 */
		private function command_redoEndHandler($e:CommandEvent):void
		{
			vs::executing = false;
			var command:RevokableCommand = $e.command as RevokableCommand;
			command.removeEventListener(CommandEvent.COMMAND_END, command_redoEndHandler);
			//命令重做完毕，加入撤销队列。
			pushCommandToUndos(command);
			
			QUEUE_REDO_END.vs::command = command;
			dispatchEvent(QUEUE_REDO_END);
		}
		
		
		/**
		 * 可撤销队列历史长度。
		 * 
		 * @default 50
		 * 
		 */
		public function get maxHistoryLength():uint
		{
			return vs::maxHistoryLength;
		}
		
		/**
		 * @private
		 */
		public function set maxHistoryLength($value:uint):void
		{
			vs::maxHistoryLength = $value;
			//如果当前撤销队列数组的长度大于historyLength，则对撤销队列数组进行截断。
			if (maxHistoryLength && commandsUndo.length > maxHistoryLength) commandsUndo.length = maxHistoryLength;
		}
		
		
		/**
		 * 
		 * 撤销历史队列长度。
		 * 
		 */
		
		public function get undoHistoryLength():uint
		{
			return commandsUndo.length;
		}
		
		
		/**
		 * 
		 * 重做历史队列长度。
		 * 
		 */
		
		public function get redoHistoryLength():uint
		{
			return commandsRedo.length;
		}
		
		
		/**
		 * 
		 * 队列能否继续执行撤销。
		 * 
		 */
		
		public function get undoable():Boolean
		{
			return commandsUndo.length > 0;
		}
		
		
		/**
		 * 
		 * 队列能否继续执行重做。
		 * 
		 */
		
		public function get redoable():Boolean
		{
			return commandsRedo.length > 0;
		}
		
		
		/**
		 * 可撤销命令队列。
		 * @private
		 */
		public var commandsUndo:Vector.<RevokableCommand>;
		
		/**
		 * 可重做命令队列。
		 * @private
		 */
		public var commandsRedo:Vector.<RevokableCommand>;
		
		
		/**
		 * @private
		 */
		vs var maxHistoryLength:uint = 50;
		
		
		/**
		 * @private
		 */
		private static const QUEUE_REDO_START:RevocableQueueEvent = new RevocableQueueEvent(RevocableQueueEvent.REDO_START, null);
		
		/**
		 * @private
		 */
		private static const QUEUE_REDO_END:RevocableQueueEvent = new RevocableQueueEvent(RevocableQueueEvent.REDO_END, null);
		
		/**
		 * @private
		 */
		private static const QUEUE_UNDO_START:RevocableQueueEvent = new RevocableQueueEvent(RevocableQueueEvent.UNDO_START, null);
		
		/**
		 * @private
		 */
		private static const QUEUE_UNDO_END:RevocableQueueEvent = new RevocableQueueEvent(RevocableQueueEvent.UNDO_END, null);
		
	}
}