package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 销毁异常，当存储器的length不为空时，进行销毁，会抛出此异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class DestroyNotEmptiedError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param instance:* 抛出此异常的实例。
		 * 
		 */
		public function DestroyNotEmptiedError($instance:*)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::DESTROY_NOT_EMPTIED, ClassUtil.getClassName($instance, false)));
		}
		
	}
}