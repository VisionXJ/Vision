package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.Presenter;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 主程序处理器启动异常，通常是因为已经启动过了主程序处理器，第二次启动时触发，一个Application只有一个主程序处理器，并且只能启动一次。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class PresenterStartedError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $presenter:Presenter 抛出此异常的主程序处理器。
		 * 
		 */
		public function PresenterStartedError($presenter:Presenter)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::PRESENTER_STARTED_ERROR, $presenter.className));
		}
		
	}
}