package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * 参数不合法异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentInvalidError extends VSError
	{
		public function ArgumentInvalidError()
		{
			super(ErrorConsts.vs::ARGUMENT_INVALID);
		}
	}
}