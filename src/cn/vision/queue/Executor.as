package cn.vision.queue
{
	
	import cn.vision.collections.Map;
	import cn.vision.consts.CommandPriorityConsts;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.CommandEvent;
	import cn.vision.core.Command;
	
	import flash.events.Event;
	
	
	/**
	 * 开始执行一个命令时派发。
	 * 
	 */
	[Event(name="commandStart", type="cn.vision.events.CommandEvent")]
	
	
	/**
	 * 结束执行一个命令时派发。
	 * 
	 */
	[Event(name="commandEnd"  , type="cn.vision.events.CommandEvent")]
	
	
	/**
	 * 命令执行器，可同时执行多个命令。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	internal final class Executor extends VSEventDispatcher
	{
		
		/**
		 * 构造函数。
		 */
		public function Executor()
		{
			super();
			
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			vs::commands = new Map;
			vs::limit = 5;
		}
		
		
		/**
		 * 停止执行所有正在执行的命令。
		 */
		public function close():void
		{
			if (commands.length)
			{
				for each (var command:Command in commands)
				{
					command.removeEventListener(CommandEvent.COMMAND_START, handlerCommandExecuteStart);
					command.removeEventListener(CommandEvent.COMMAND_END  , handlerCommandExecuteEnd);
					command.close();
				}
				commands.clear();
				
				vs::num = 0;
			}
		}
		
		
		/**
		 * 执行一个命令，只要未达到最大限制。
		 * 
		 * @param $command:Command 执行的命令。
		 * 
		 * @return Boolean 是否被执行。
		 * 
		 */
		public function execute($command:Command):Boolean
		{
			var result:Boolean = acceptable || ($command.priority == CommandPriorityConsts.HIGHEST);
			if (result)
			{
				commands[$command.vid] = $command;
				$command.addEventListener(CommandEvent.COMMAND_START, handlerCommandExecuteStart);
				$command.addEventListener(CommandEvent.COMMAND_END  , handlerCommandExecuteEnd);
				$command.execute();
			}
			return result;
		}
		
		
		/**
		 * 判断某个命令是否在执行中。
		 * 
		 * @param $command:Command 执行的命令。
		 * 
		 * @return Boolean 是否存在该命令。
		 * 
		 */
		public function exist($command:Command):Boolean
		{
			for each (var command:Command in commands)
			{
				if (command == $command) return true;
			}
			return false;
		}
		
		
		/**
		 * 移除某个正在执行的命令，移除后，该命令会被关闭执行。
		 * 
		 * @param $command:Command 移除的命令。
		 * 
		 */
		public function remove($command:Command):void
		{
			if (commands[$command.vid])
			{
				$command.removeEventListener(CommandEvent.COMMAND_START, handlerCommandExecuteStart);
				$command.removeEventListener(CommandEvent.COMMAND_END  , handlerCommandExecuteEnd);
				$command.close();
				delete commands[$command.vid];
				vs::num -= 1;
			}
		}
		
		
		/**
		 * @private
		 */
		private function handlerCommandExecuteStart($e:CommandEvent):void
		{
			$e.command.removeEventListener(CommandEvent.COMMAND_START, handlerCommandExecuteStart);
			vs::num += 1;
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerCommandExecuteEnd($e:CommandEvent):void
		{
			$e.command.removeEventListener(CommandEvent.COMMAND_END, handlerCommandExecuteEnd);
			delete commands[$e.command.vid];
			vs::num = vs::num ? vs::num - 1 : 0;
			dispatchEvent($e.clone());
		}
		
		
		/**
		 * 是否能加入新命令执行。
		 */
		public function get acceptable():Boolean
		{
			return num < limit;
		}
		
		
		/**
		 * 命令列表。
		 */
		public function get commands():Map
		{
			return vs::commands;
		}
		
		
		/**
		 * 可同时执行的任务最大个数，最高优先级的任务不在此限制之内；<br>
		 * 当限制个数由大到小变化时，正在执行的任务不会被删除。
		 * 
		 */
		public function get limit():uint
		{
			return vs::limit;
		}
		
		/**
		 * @private
		 */
		public function set limit($value:uint):void
		{
			vs::limit = $value;
		}
		
		
		/**
		 * 正在执行的命令个数。
		 */
		
		public function get num():uint
		{
			return vs::num;
		}
		
		
		/**
		 * @private
		 */
		vs var limit:uint;
		
		/**
		 * @private
		 */
		vs var num:uint;
		
		/**
		 * @private
		 */
		vs var commands:Map;
		
	}
}