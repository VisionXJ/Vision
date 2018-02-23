package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 参数个数异常，当参数个数不正确时引发。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentNumError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param ...$args 可接受的参数个数数组。
		 * 
		 */
		public function ArgumentNumError(...$args)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ARGUMENT_NUM, $args));
		}
		
	}
}