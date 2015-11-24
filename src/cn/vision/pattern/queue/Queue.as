package cn.vision.pattern.queue
{
	
	/**
	 * 
	 * <code>Quene</code>是所有队列的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.state.QueueStateConsts;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.StateEvent;
	import cn.vision.events.pattern.QueueEvent;
	import cn.vision.pattern.core.Command;
	import cn.vision.pattern.data.Holder;
	import cn.vision.states.pattern.core.queue.*;
	import cn.vision.utils.DebugUtil;
	import cn.vision.utils.StateUtil;
	
	
	/**
	 * 
	 * 队列结束执行时派发。
	 * 
	 */
	
	[Event(name="queueEnd"  , type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 队列开始执行时派发。
	 * 
	 */
	
	[Event(name="queueStart", type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令结束时派发。
	 * 
	 */
	
	[Event(name="stepEnd"   , type="cn.vision.events.pattern.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令开始时派发。
	 * 
	 */
	
	[Event(name="stepStart" , type="cn.vision.events.pattern.QueueEvent")]
	
	
	public class Queue extends VSEventDispatcher
	{
		
		/**
		 * 
		 * <code>Quene</code>构造函数。
		 * 
		 */
		
		public function Queue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		public function execute($command:Command = null):void
		{
			
		}
		
		
		/**
		 * 
		 * 提前某个命令。
		 * 
		 * @param $command:Command 需要提前的命令实例。
		 * @param $close:Boolean 是否关闭当前正在运行的命令实例。
		 * 
		 */
		
		public function shift($command:Command, $close:Boolean = false):Boolean
		{
			return false;
		}
		
		
		/**
		 * 
		 * 滞后某个命令。
		 * 
		 */
		
		public function delay($command:Command):Boolean
		{
			return false;
		}
		
		
		/**
		 * 
		 * 变量初始化。
		 * 
		 */
		
		protected function initializeVariables():void
		{
			vs::state = QueueStateConsts.INITIALIZE;
			
			stateStore = new Holder;
		}
		
		
		/**
		 * 
		 * 状态初始化。
		 * 
		 */
		
		protected function initializeStates():void
		{
			stateStore.registData(QueueStateConsts.INITIALIZE, new QueueInitializeState);
			stateStore.registData(QueueStateConsts.IDLE      , new QueueIdleState);
			stateStore.registData(QueueStateConsts.RUNNING   , new QueueRunningState);
		}
		
		
		/**
		 * 
		 * 初始化完毕。
		 * 
		 */
		
		protected function initializeComplete():void
		{
			state = QueueStateConsts.IDLE;
		}
		
		
		/**
		 * 
		 * 管理器结束执行任务时调用此方法发送事件。
		 * 
		 */
		
		protected function queueEnd():void
		{
			state = QueueStateConsts.IDLE;
			dispatchEvent(eventQueueEnd);
		}
		
		
		/**
		 * 
		 * 管理器开始执行任务时调用此方法发送事件。
		 * 
		 */
		
		protected function queueStart():void
		{
			state = QueueStateConsts.RUNNING;
			dispatchEvent(eventQueueStart);
		}
		
		
		/**
		 * 
		 * 单步命令结束时调用此方法发送事件。
		 * 
		 */
		
		protected function stepEnd($command:Command):void
		{
			eventStepEnd.vs::command = $command;
			dispatchEvent(eventStepEnd);
		}
		
		
		/**
		 * 
		 * 单步命令开始时调用此方法发送事件。
		 * 
		 */
		
		protected function stepStart($command:Command):void
		{
			eventStepStart.vs::command = $command;
			dispatchEvent(eventStepStart);
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
		 * @inheritDoc
		 */
		
		public function get lastState():String
		{
			return vs::lastState;
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
		protected var stateStore:Holder;
		
		/**
		 * @private
		 */
		private var eventQueueStart:QueueEvent = new QueueEvent(QueueEvent.QUEUE_START);
		
		/**
		 * @private
		 */
		private var eventQueueEnd:QueueEvent = new QueueEvent(QueueEvent.QUEUE_END);
		
		/**
		 * @private
		 */
		private var eventStepStart:QueueEvent = new QueueEvent(QueueEvent.STEP_START);
		
		/**
		 * @private
		 */
		private var eventStepEnd:QueueEvent = new QueueEvent(QueueEvent.STEP_END);
		
		
		/**
		 * @private
		 */
		vs var lastState:String;
		
		/**
		 * @private
		 */
		vs var state:String;
		
	}
}