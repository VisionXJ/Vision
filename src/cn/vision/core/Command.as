package cn.vision.core
{
	
	import cn.vision.collections.Holder;
	import cn.vision.consts.CommandStateConsts;
	import cn.vision.errors.UnavailableError;
	import cn.vision.events.CommandEvent;
	import cn.vision.events.StateEvent;
	import cn.vision.interfaces.IAvailable;
	import cn.vision.interfaces.IState;
	import cn.vision.interfaces.IView;
	import cn.vision.managers.ViewManager;
	import cn.vision.states.CommandFinishedState;
	import cn.vision.states.CommandIdleState;
	import cn.vision.states.CommandInitializeState;
	import cn.vision.states.CommandRunningState;
	import cn.vision.utils.StateUtil;
	
	
	/**
	 * 命令开始执行时派发。
	 * 
	 * @default commandStart
	 * 
	 */
	[Event(name="commandStart", type="cn.vision.events.CommandEvent")]
	
	
	/**
	 * 命令结束执行时派发。
	 * 
	 * @default commandEnd
	 * 
	 */
	[Event(name="commandEnd", type="cn.vision.events.CommandEvent")]
	
	
	/**
	 * 命令状态改变时派发。
	 * 
	 * @default stateChange
	 * 
	 */
	[Event(name="stateChange", type="cn.vision.events.StateEvent")]
	
	
	/**
	 * 命令基类。<br>
	 * 开发人员需要定义命令的子类来继承，如果是同步命令，则只需重写受保护的processExecute方法，
	 * 如果是异步命令，则需重写execute()方法，并在异步命令的开始和结束的地方调用commandStart和
	 * commandEnd。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Command extends VSEventDispatcher implements IState, IAvailable
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $sync:Boolean (default = true) 命令是否为同步，true为同步，false为异步。
		 * 
		 */
		public function Command($sync:Boolean = true)
		{
			super();
			
			initialize($sync);
		}
		
		/**
		 * @private
		 */
		private function initialize($sync:Boolean):void
		{
			//variables
			vs::sync  = $sync;
			vs::state = CommandStateConsts.INITIALIZE;
			
			stateStore = new Holder;
			stateStore.registData(CommandStateConsts.INITIALIZE, new CommandInitializeState);
			stateStore.registData(CommandStateConsts.IDLE      , new CommandIdleState);
			stateStore.registData(CommandStateConsts.RUNNING   , new CommandRunningState);
			stateStore.registData(CommandStateConsts.FINISHED  , new CommandFinishedState);
			
			state = CommandStateConsts.IDLE;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IDestroy#destroy()
		 */
		override public function destroy():void
		{
			for each (var key:String in stateStore.keys)
			{
				var state:State = stateStore.retrieveData(key);
				state.destroy();
				stateStore.removeData(key);
			}
			stateStore.destroy();
			stateStore = null;
		}
		
		
		/**
		 * 结束正在执行的命令。<br>
		 * 只有异步命令才可以关闭，如从页面加载数据，而关闭操作则需要重写close方法。
		 * 
		 */
		public function close():void
		{
			executing && commandEnd();
		}
		
		
		/**
		 * 执行命令。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在命令的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processExecute。
		 * 
		 * @see cn.vision.core.Command.processExecute()
		 * @see cn.vision.core.Command.commandStart()
		 * @see cn.vision.core.Command.commandEnd()
		 * 
		 */
		public function execute():void
		{
			if (available)
			{
				commandStart();
				
				processExecute();
				
				if (sync) commandEnd();
			}
			else
			{
				throw new UnavailableError(this);
			}
		}
		
		
		/**
		 * 命令执行<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.vision.core.Command.execute()
		 * 
		 */
		protected function processExecute():void { }
		
		
		/**
		 * 命令开始，发送命令开始事件。<br>
		 * 重写命令的子类时，一般无需重写此方法，此方法只在开发人员重写execute方法时调用它。
		 * 
		 * @see cn.vision.core.Command.execute()
		 * 
		 */
		protected function commandStart():void
		{
			if(!vs::executing)
			{
				vs::executing = true;
				state = CommandStateConsts.RUNNING;
				dispatchEvent(new CommandEvent(CommandEvent.COMMAND_START, this));
			}
		}
		
		
		/**
		 * 命令结束，发送命令结束事件。<br>
		 * 重写命令的子类时，一般无需重写此方法，此方法只在开发人员重写execute方法时调用它。
		 * 
		 * @see cn.vision.core.Command.execute()
		 * 
		 */
		protected function commandEnd():void
		{
			if (vs::executing)
			{
				vs::executing = false;
				state = CommandStateConsts.FINISHED;
				dispatchEvent(new CommandEvent(CommandEvent.COMMAND_END, this));
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get available():Boolean
		{
			return true;
		}
		
		
		/**
		 * 是否在执行中。
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
		 * 命令的优先级。
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
		 * 是否为同步命令。<br>
		 * 命令分为同步和异步两种方式，如果是异步命令，在调用execute时，不会执行commandEnd，
		 * 需要在命令结束时手动调用一次commandEnd，该参数在Command构造函数中传入。
		 */
		public function get sync():Boolean
		{
			return vs::sync as Boolean;
		}
		
		
		/**
		 * 获取命令调用处理类。
		 */
		protected function get presenter():Presenter
		{
			return Presenter.presenter;
		}
		
		
		/**
		 * @private
		 */
		protected var stateStore:Holder;
		
		
		/**
		 * @private
		 */
		vs var sync:Boolean = true;
		
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