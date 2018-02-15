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
		 * @param $num:uint (default = 0) 可接受的参数个数。
		 * 
		 */
		public function ArgumentNumError($num:uint)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ARGUMENT_NUM, $num));
		}
		
	}
}