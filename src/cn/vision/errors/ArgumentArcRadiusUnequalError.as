package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * 圆弧起点与终点到圆心的距离不相等。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ArgumentArcRadiusUnequalError extends VSError
	{
		public function ArgumentArcRadiusUnequalError()
		{
			super(ErrorConsts.vs::ARGUMENT_ARC_RADIUS_UNEQUAL);
		}
	}
}