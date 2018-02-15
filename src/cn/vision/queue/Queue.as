package cn.vision.queue
{
	
	/**
	 * 
	 * <code>Quene</code>是所有队列的基类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.collections.Holder;
	import cn.vision.consts.QueueStateConsts;
	import cn.vision.core.Command;
	import cn.vision.core.State;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.errors.DestroyQueueExecutingError;
	import cn.vision.events.QueueEvent;
	import cn.vision.events.StateEvent;
	import cn.vision.states.QueueIdleState;
	import cn.vision.states.QueueInitializeState;
	import cn.vision.states.QueueRunningState;
	import cn.vision.utils.StateUtil;
	
	
	/**
	 * 
	 * 队列结束执行时派发。
	 * 
	 */
	
	[Event(name="queueEnd"  , type="cn.vision.events.QueueEvent")]
	
	
	/**
	 * 
	 * 队列开始执行时派发。
	 * 
	 */
	
	[Event(name="queueStart", type="cn.vision.events.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令结束时派发。
	 * 
	 */
	
	[Event(name="stepEnd"   , type="cn.vision.events.QueueEvent")]
	
	
	/**
	 * 
	 * 单步命令开始时派发。
	 * 
	 */
	
	[Event(name="stepStart" , type="cn.vision.events.QueueEvent")]
	
	
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
		 * @private
		 */
		private function initialize():void
		{
			vs::state = QueueStateConsts.INITIALIZE;
			
			stateStore = new Holder;
			
			stateStore.registData(QueueStateConsts.INITIALIZE, new QueueInitializeState);
			stateStore.registData(QueueStateConsts.IDLE      , new QueueIdleState);
			stateStore.registData(QueueStateConsts.RUNNING   , new QueueRunningState);
			
			state = QueueStateConsts.IDLE;
		}
		
		
		/**
		 * 清空命令。
		 */
		public function clear():void { }
		
		
		/**
		 * 队列停止执行。
		 */
		public function close():void { }
		
		
		/**
		 * 滞后某个命令。
		 * 
		 * @param $command:Command 需要延后的命令实例。
		 * 
		 */
		public function delay($command:Command):Boolean { return false; }
		
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			if (executing) throw new DestroyQueueExecutingError(this);
			
			for each (var state:State in stateStore) state.destroy();
			stateStore.destroy();
		}
		
		
		/**
		 * 执行命令。
		 * 
		 * @param $command:Command 需要执行的命令实例。
		 * 
		 */
		public function execute($command:Command = null):void { }
		
		
		/**
		 * 判断一个命令是否在队列中存在，判断一个命令是否存在，必须该命令正在等待被执行或执行中，已执行过的命令不算。
		 * 
		 * @param $command:Command 需要判断的命令实例。
		 * 
		 */
		public function exist($command:Command):Boolean { return false }
		
		
		/**
		 * 查找某个命令在队列中的索引。
		 * 
		 * @param $command:Command 需要查找的命令实例。
		 * 
		 */
		public function indexOf($command:Command):int { return -1; }
		
		
		/**
		 * 将命令加入队列末尾，此方法与execute不同，push操作后，命令不会立即执行。
		 * 
		 * @param $command:Command 要添加的命令实例。
		 * 
		 */
		public function push($command:Command):void { }
		
		
		/**
		 * 删除某个命令实例。
		 * 
		 * @param $command:Command 需要删除的元素实例。
		 * 
		 */
		public function remove($command:Command):Boolean { return false; }
		
		
		/**
		 * 提前某个命令。
		 * 
		 * @param $command:Command 需要提前的命令实例。
		 * @param $close:Boolean 是否关闭当前正在运行的命令实例。
		 * 
		 */
		public function shift($command:Command, $close:Boolean = false):Boolean { return false; }
		
		
		/**
		 * 管理器结束执行任务时调用此方法发送事件。
		 */
		protected function queueEnd():void
		{
			state = QueueStateConsts.IDLE;
			dispatchEvent(EVENT_QUEUE_END);
		}
		
		
		/**
		 * 管理器开始执行任务时调用此方法发送事件。
		 */
		protected function queueStart():void
		{
			state = QueueStateConsts.RUNNING;
			dispatchEvent(EVENT_QUEUE_START);
		}
		
		
		/**
		 * 单步命令结束时调用此方法发送事件。
		 */
		protected function stepEnd($command:Command):void
		{
			EVENT_STEP_END.vs::command = $command;
			dispatchEvent(EVENT_STEP_END);
		}
		
		
		/**
		 * 单步命令开始时调用此方法发送事件。
		 */
		protected function stepStart($command:Command):void
		{
			EVENT_STEP_START.vs::command = $command;
			dispatchEvent(EVENT_STEP_START);
		}
		
		
		/**
		 * 是否在执行命令中。
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
		vs var lastState:String;
		
		/**
		 * @private
		 */
		vs var state:String;
		
		/**
		 * @private
		 */
		vs var executing:Boolean;
		
		
		/**
		 * @private
		 */
		private static const EVENT_QUEUE_START:QueueEvent = new QueueEvent(QueueEvent.QUEUE_START);
		
		/**
		 * @private
		 */
		private static const EVENT_QUEUE_END:QueueEvent = new QueueEvent(QueueEvent.QUEUE_END);
		
		/**
		 * @private
		 */
		private static const EVENT_STEP_START:QueueEvent = new QueueEvent(QueueEvent.STEP_START);
		
		/**
		 * @private
		 */
		private static const EVENT_STEP_END:QueueEvent = new QueueEvent(QueueEvent.STEP_END);
		
	}
}