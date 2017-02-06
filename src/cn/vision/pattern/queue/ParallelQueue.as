package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * 并行命令队列，可同时执行多个命令。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.consts.CommandPriorityConsts;
	import cn.vision.core.vs;
	import cn.vision.events.pattern.CommandEvent;
	import cn.vision.pattern.core.Command;
	import cn.vision.utils.ArrayUtil;
	
	
	public class ParallelQueue extends Queue
	{
		
		/**
		 * 
		 * <code>ParallelQueue</code>构造函数。
		 * 
		 */
		
		public function ParallelQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function clear():void
		{
			close();
			commandsIdle.length = 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function close():void
		{
			if (executing)
			{
				executor.close();
				vs::executing = false;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function delay($command:Command):Boolean
		{
			if ($command)
			{
				var index:int = indexOf($command);
				var result:Boolean = index > -1 && index < commandsIdle.length - 1;
				if (result) ArrayUtil.order(commandsIdle, index, commandsIdle.length - 1);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 添加，执行命令。
		 * 
		 * @param $command:Command (default = null) 需要加入执行的命令实例。
		 * 
		 */
		
		override public function execute($command:Command = null):void
		{
			if(!vs::executing)
			{
				vs::executing = true;
				queueStart();
			}
			
			if ($command)
			{
				(FUNC[$command.priority] ? 
					FUNC[$command.priority] :
					FUNC[CommandPriorityConsts.NORMAL])($command);
			}
			else
			{
				executeCommand();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function exist($command:Command):Boolean
		{
			return executor.exist($command) || indexOf($command) >= 0;
		}
		
		
		/**
		 * 
		 * 查询命令在队列中的索引，如不存在返回-1，如该命令正在执行，则返回-2。
		 * 
		 * @param $command:Command 需要查找的Command。
		 * 
		 */
		
		override public function indexOf($command:Command):int
		{
			return executor.exist($command) ? -2 : commandsIdle.indexOf($command);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function push($command:Command):void
		{
			if ($command)
			{
				(FUNC[$command.priority] ? 
					FUNC[$command.priority] :
					FUNC[CommandPriorityConsts.NORMAL])($command, false);
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function remove($command:Command):Boolean
		{
			var result:Boolean = true;
			if (executor.exist($command))
			{
				executor.remove($command);
			}
			else
			{
				var index:int = indexOf($command);
				if (index >= 0) commandsIdle.splice(index, 1);
				else result = false;
			}
			if (lave + num == 0) vs::executing = false;
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		
		override public function shift($command:Command, $close:Boolean = false):Boolean
		{
			if(!$command.executing)
			{
				var index:int = indexOf($command);
				var result:Boolean = index > 0;
				if (result)
				{
					ArrayUtil.order(commandsIdle, index, 0);
					if ($close)
					{
						for each (var command:Command in executor.commands)
						{
							command.close();
							ArrayUtil.unshift(commandsIdle, command);
							break;
						}
					}
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 抽取闲置命令队列的命令执行。
		 * 
		 */
		
		protected function executeCommand():void
		{
			if (vs::executing)
			{
				if (commandsIdle.length)
				{
					while (executor.acceptable && commandsIdle.length)
					{
						//闲置队列中还有命令，检测Executor能否接受新命令执行。
						//可接受新命令，抽取并执行。
						executor.execute(ArrayUtil.shift(commandsIdle));
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
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			commandsIdle = new Vector.<Command>;
			
			executor = new Executor;
			executor.addEventListener(CommandEvent.COMMAND_END, executeEndHandler, false, 0, true);
			executor.addEventListener(CommandEvent.COMMAND_START, executeStartHandler, false, 0, true);
			executor.limit = 3;
			
			FUNC[CommandPriorityConsts.NORMAL ] = callNormal;
			FUNC[CommandPriorityConsts.HIGH   ] = callHigh;
			FUNC[CommandPriorityConsts.HIGHEST] = callHighest;
		}
		
		/**
		 * 普通优先级会放在闲置队列末尾。
		 * @private
		 */
		private function callNormal($command:Command, $exec:Boolean = true):void
		{
			ArrayUtil.push(commandsIdle, $command);
			if ($exec) executeCommand();
		}
		
		/**
		 * 高优先级会放在闲置队列起始位置。
		 * @private
		 */
		private function callHigh($command:Command, $exec:Boolean = true):void
		{
			ArrayUtil.unshift(commandsIdle, $command);
			if ($exec) executeCommand();
		}
		
		/**
		 * 最高优先级，直接使用Executor执行。 
		 * @private
		 */
		private function callHighest($command:Command, $exec:Boolean = true):void
		{
			if ($exec)
				executor.execute($command);
			else
				ArrayUtil.unshift(commandsIdle, $command);
		}
		
		
		/**
		 * 命令结束处理。
		 * @private
		 */
		private function executeEndHandler($e:CommandEvent):void
		{
			stepEnd($e.command);
			executeCommand();
		}
		
		/**
		 * 开始执行命令回调。
		 */
		private function executeStartHandler($e:CommandEvent):void
		{
			stepStart($e.command);
		}
		
		
		/**
		 * 
		 * 正在执行的命令列表。
		 * 
		 */
		
		public function get executingCommands():Map
		{
			return executor.commands;
		}
		
		
		/**
		 * 
		 * 剩余需要执行的任务个数，不包含当前正在执行的任务。
		 * 
		 */
		
		public function get lave():uint
		{
			return commandsIdle.length;
		}
		
		
		/**
		 * 
		 * 最多同时执行线程的个数。
		 * 
		 */
		
		public function get limit():uint
		{
			return executor.limit;
		}
		
		/**
		 * @private
		 */
		public function set limit($value:uint):void
		{
			executor.limit = $value;
		}
		
		
		/**
		 * 
		 * 正在执行的命令个数。
		 * 
		 */
		
		public function get num():uint
		{
			return executor.num;
		}
		
		
		/**
		 * 
		 * 当前正在执行命令的<code>Executor</code>。
		 * 
		 */
		
		protected var executor:Executor;
		
		
		/**
		 * 
		 * 闲置命令队列。
		 * 
		 */
		
		public var commandsIdle:Vector.<Command>;
		
		
		/**
		 * @private
		 */
		vs var executing:Boolean;
		
		
		/**
		 * @private
		 */
		private const FUNC:Object = {};
		
	}
}