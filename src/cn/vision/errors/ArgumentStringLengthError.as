package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.utils.RegexpUtil;
	
	public final class ArgumentStringLengthError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $num:int 可接受的参数字符串长度。
		 * 
		 */
		public function ArgumentStringLengthError($num:uint = 1)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ARGUMENT_NUM, $num));
		}
	}
}