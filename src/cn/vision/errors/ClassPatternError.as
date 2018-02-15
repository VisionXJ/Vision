package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 不可实例化类异常。当尝试构造此种类的实例时抛出此异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ClassPatternError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $class:Class (default = null) 抛出此异常的类。
		 * 
		 */
		
		public function ClassPatternError($instance:*)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::CLASS_PATTERN, ClassUtil.getClassName($instance)));
		}
		
	}
}