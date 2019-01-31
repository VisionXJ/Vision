package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * OA与OB不垂直，不能形成椭圆异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentEllispeUnverticalError extends VSError
	{
		public function ArgumentEllispeUnverticalError()
		{
			super(ErrorConsts.vs::ARGUMENT_ELLISPE_UNVERTICAL);
		}
	}
}