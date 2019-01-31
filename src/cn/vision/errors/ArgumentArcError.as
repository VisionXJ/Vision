package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	public final class ArgumentArcError extends VSError
	{
		public function ArgumentArcError()
		{
			super(ErrorConsts.vs::ARGUMENT_ARC_ERROR);
		}
	}
}