package cn.vision.states
{
	
	/**
	 * 
	 * 描述了队列的闲置状态。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.QueueStateConsts;
	import cn.vision.core.vs;
	import cn.vision.core.State;
	
	
	public class QueueIdleState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function QueueIdleState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function initializeVariables():void
		{
			vs::name = QueueStateConsts.IDLE;
		}
		
	}
}