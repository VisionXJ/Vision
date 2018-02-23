package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	import cn.vision.core.vs;
	
	/**
	 * 抽象异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class AbstractError extends VSError
	{
		public function AbstractError($methodName:String)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::ABSTRACT, $methodName));
		}
	}
}