package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 单例异常，一个程序里只允许存在一个该类的实例，当构建第二个单例类的实例时，引发此异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class SingleTonError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param instance:* 抛出此异常的实例。
		 * 
		 */
		public function SingleTonError($instance:*)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::SINGLE_TON, ClassUtil.getClassName($instance, false)));
		}
		
	}
}