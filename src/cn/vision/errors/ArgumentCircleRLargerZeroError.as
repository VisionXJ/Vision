package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * 圆的半径必须大于0。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentCircleRLargerZeroError extends VSError
	{
		public function ArgumentCircleRLargerZeroError()
		{
			super(ErrorConsts.vs::ARGUMENT_CIRCLE_R_LARGER_ZERO);
		}
	}
}