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
	
	
	import cn.vision.consts.state.CommandStateConsts;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.StateEvent;
	import cn.vision.events.pattern.CommandEvent;
	import cn.vision.interfaces.IState;
	import cn.vision.pattern.data.Store;
	import cn.vision.states.pattern.core.command.*;
	import cn.vision.utils.StateUtil;
	
	
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
		 * 构造函数。
		 * 
		 */
		
		public function Command()
		{
			super();
			
			initialize();
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
		 * 变量初始化。
		 * 
		 */
		
		protected function initializeVariables():void
		{
			vs::state = CommandStateConsts.INITIALIZE;
			
			stateStore = new Store;
		}
		
		
		/**
		 * 
		 * 状态初始化。
		 * 
		 */
		
		protected function initializeStates():void
		{
			stateStore.registData(CommandStateConsts.INITIALIZE, new CommandInitializeState);
			stateStore.registData(CommandStateConsts.IDLE      , new CommandIdleState);
			stateStore.registData(CommandStateConsts.RUNNING   , new CommandRunningState);
			stateStore.registData(CommandStateConsts.FINISHED  , new CommandFinishedState);
		}
		
		
		/**
		 * 
		 * 初始化完毕。
		 * 
		 */
		
		protected function initializeComplete():void
		{
			state = CommandStateConsts.IDLE;
		}
		
		
		/**
		 * 
		 * 命令开始，发送命令开始事件。
		 * 
		 */
		
		protected function commandStart():void
		{
			vs::executing = true;
			state = CommandStateConsts.RUNNING;
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
			state = CommandStateConsts.FINISHED;
			dispatchEvent(new CommandEvent(CommandEvent.COMMAND_END, this));
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			initializeVariables();
			
			initializeStates();
			
			initializeComplete();
		}
		
		
		/**
		 * 
		 * 是否在执行中。
		 * 
		 */
		
		public function get executing():Boolean
		{
			return vs::executing as Boolean;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get lastState():String
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
		
		public function get state():String
		{
			return vs::state;
		}
		
		/**
		 * @private
		 */
		public function set state($value:String):void
		{
			if ($value != vs::state)
			{
				vs::lastState = vs::state;
				vs::state = $value;
				
				//冻结上一个状态并激活当前状态
				StateUtil.vs::changeState(lastState, state, stateStore);
				
				dispatchEvent(new StateEvent(StateEvent.STATE_CHANGE, vs::lastState, vs::state));
			}
		}
		
		
		/**
		 * @private
		 */
		protected var stateStore:Store;
		
		
		/**
		 * @private
		 */
		vs var executing:Boolean;
		
		/**
		 * @private
		 */
		vs var lastState:String;
		
		/**
		 * @private
		 */
		vs var state:String;
		
		/**
		 * @private
		 */
		vs var priority:uint;
		
	}
}