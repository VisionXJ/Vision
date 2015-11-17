package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * 命令执行器，可同时执行多个命令。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.consts.CommandPriorityConsts;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.pattern.CommandEvent;
	import cn.vision.pattern.core.Command;
	
	import flash.events.Event;
	
	
	/**
	 * 
	 * 开始执行一个命令时派发。
	 * 
	 */
	
	[Event(name="commandStart", type="cn.vision.events.pattern.CommandEvent")]
	
	
	/**
	 * 
	 * 结束执行一个命令时派发。
	 * 
	 */
	
	[Event(name="commandEnd"  , type="cn.vision.events.pattern.CommandEvent")]
	
	
	internal final class Executor extends VSEventDispatcher
	{
		
		/**
		 * 
		 * <code>Executor</code>构造函数。
		 * 
		 */
		
		public function Executor()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 执行一个命令，只要未达到最大限制。
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
		 * @private
		 */
		private function initialize():void
		{
			vs::commands = new Map;
			vs::limit = 5;
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
		 * 
		 * 是否能加入新命令执行。
		 * 
		 */
		
		public function get acceptable():Boolean
		{
			return num < limit;
		}
		
		
		/**
		 * 
		 * 命令列表。
		 * 
		 */
		
		public function get commands():Map
		{
			return vs::commands;
		}
		
		
		/**
		 * 
		 * 可同时执行的任务最大个数，最高优先级的任务不在此限制之内；
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
		 * 
		 * 正在执行的命令个数。
		 * 
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