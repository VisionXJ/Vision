package cn.vision.pattern.core
{
	
	/**
	 * 
	 * 通常把一个或几个操作或函数写在一个集合称为<code>Command</code>。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.StateEvent;
	import cn.vision.events.pattern.CommandEvent;
	import cn.vision.interfaces.IState;
	import cn.vision.states.pattern.commands.*;
	
	
	/**
	 * 
	 * 命令开始执行时派发。
	 * 
	 */
	
	[Event(name="commandStart", type="cn.vision.events.pattern.CommandEvent")]
	
	
	/**
	 * 
	 * 命令结束执行时派发。
	 * 
	 */
	
	[Event(name="commandEnd"  , type="cn.vision.events.pattern.CommandEvent")]
	
	
	/**
	 * 
	 * 命令状态改变时派发。
	 * 
	 */
	
	[Event(name="stateChange" , type="cn.vision.events.StateEvent"  )]
	
	
	public class Command extends VSEventDispatcher implements IState
	{
		
		/**
		 * 
		 * <code>Command</<code>构造函数。
		 * 
		 */
		
		public function Command()
		{
			super();
			
			initializeStates();
		}
		
		
		/**
		 * 状态初始化。
		 */
		protected function initializeStates():void
		{
			commandStateIdle = new IdleCommandState;
			commandStateRun  = new RunCommandState;
			commandStateOff  = new OffCommandState;
			
			vs::state = commandStateIdle;
		}
		
		
		/**
		 * 
		 * 命令开始，发送命令开始事件。
		 * 
		 */
		
		protected function commandStart():void
		{
			vs::executing = true;
			state = commandStateRun;
			dispatchEvent(new CommandEvent(CommandEvent.COMMAND_START, this));
		}
		
		
		/**
		 * 
		 * 命令结束，发送命令结束事件。
		 * 
		 */
		
		protected function commandEnd():void
		{
			vs::executing = false;
			state = commandStateOff;
			dispatchEvent(new CommandEvent(CommandEvent.COMMAND_END, this));
		}
		
		
		/**
		 * 
		 * 结束正在执行的命令。
		 * 
		 */
		
		public function close():void
		{
			executing && commandEnd();
		}
		
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		public function execute():void
		{
			commandStart();
			
			commandEnd();
		}
		
		
		/**
		 * 
		 * 是否在执行中。
		 * 
		 */
		
		public function get executing():Boolean
		{
			return Boolean(vs::executing);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get lastState():State
		{
			return vs::lastState;
		}
		
		
		/**
		 * 
		 * 命令的优先级。
		 * 
		 */
		
		public function get priority():uint
		{
			return vs::priority;
		}
		
		/**
		 * @private
		 */
		public function set priority($value:uint):void
		{
			vs::priority = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get state():State
		{
			return vs::state;
		}
		
		/**
		 * @private
		 */
		public function set state($value:State):void
		{
			if (vs::state.title != $value.title)
			{
				vs::lastState = vs::state;
				vs::state = $value;
				
				if (vs::lastState) 
					vs::lastState.freeze();
				if (vs::state)
					vs::state.active();
				
				dispatchEvent(new StateEvent(StateEvent.STATE_CHANGE, vs::lastState, vs::state));
			}
		}
		
		
		/**
		 * 
		 * 命令闲置时的状态。
		 * 
		 */
		
		protected var commandStateIdle:State;
		
		
		/**
		 * 
		 * 命令运行时的状态。
		 * 
		 */
		
		protected var commandStateRun :State;
		
		
		/**
		 * 
		 * 命令运行完毕后的状态。
		 * 
		 */
		
		protected var commandStateOff :State;
		
		
		/**
		 * @private
		 */
		vs var executing:Boolean;
		
		/**
		 * @private
		 */
		vs var lastState:State;
		
		/**
		 * @private
		 */
		vs var state:State;
		
		/**
		 * @private
		 */
		vs var priority:uint;
		
	}
}