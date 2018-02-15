package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 不是子类异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentNotSubClassError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $class:Class 子类。
		 * @param $parent:Class 验证引发异常的父类。
		 * 
		 */
		public function ArgumentNotSubClassError($class:Class, $parent:Class)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ARGUMENT_NOT_SUB_CLASS, 
				ClassUtil.getClassName($class), 
				ClassUtil.getClassName($parent)));
		}
	}
}