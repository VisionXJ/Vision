package cn.vision.errors
{
	
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.Command;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.interfaces.IAvailable;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.RegexpUtil;
	
	
	/**
	 * 不可用异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class UnavailableError extends VSError
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $name:String 命令名称。
		 * 
		 */
		public function UnavailableError($instance:IAvailable)
		{
			super(RegexpUtil.replaceTag(ErrorConsts.vs::UNAVAILABLE, ClassUtil.getClassName($instance)));
		}
	}
}