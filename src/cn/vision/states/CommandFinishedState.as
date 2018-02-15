package cn.vision.states
{
	
	import cn.vision.consts.CommandStateConsts;
	import cn.vision.core.vs;
	import cn.vision.core.State;
	
	
	/**
	 * FinishedCommandState 描述了命令的结运行完毕后的状态。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class CommandFinishedState extends State
	{
		
		/**
		 * 构造函数。
		 */
		
		public function CommandFinishedState()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function initializeVariables():void
		{
			vs::name = CommandStateConsts.IDLE;
		}
		
	}
}