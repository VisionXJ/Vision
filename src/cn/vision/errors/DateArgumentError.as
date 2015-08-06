package cn.vision.errors
{
	
	/**
	 * 
	 * 日期参数异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.errors.VSError;
	
	
	public final class DateArgumentError extends VSError
	{
		public function DateArgumentError()
		{
			super("日期参数不合法");
		}
	}
}