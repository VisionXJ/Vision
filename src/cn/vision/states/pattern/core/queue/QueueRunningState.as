package cn.vision.states.pattern.core.queue
{
	
	/**
	 * 
	 * 描述了队列的运行状态。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.state.QueueStateConsts;
	import cn.vision.core.vs;
	import cn.vision.pattern.core.State;
	
	
	public class QueueRunningState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function QueueRunningState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = QueueStateConsts.RUNNING;
		}
		
	}
}