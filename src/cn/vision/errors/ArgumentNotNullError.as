package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.RegexpUtil;
	
	/**
	 * 
	 * 参数不能为空异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentNotNullError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param ...$properties 一个或多个属性名。
		 * 
		 */
		public function ArgumentNotNullError(...$properties)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ARGUMENT_NOT_NULL, $properties.toString()));
		}
	}
}