package cn.vision.states.pattern.core.command
{
	
	/**
	 * 
	 * 描述了命令的闲置状态。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.state.CommandStateConsts;
	import cn.vision.core.vs;
	import cn.vision.pattern.core.State;
	
	
	public final class CommandIdleState extends State
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function CommandIdleState()
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