package cn.vision.errors
{
	
	/**
	 * 
	 * 单例异常。当尝试构造新的单例类时抛出此异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.vision.utils.ClassUtil;
	import cn.vision.core.VSError;
	
	
	public class SingleTonError extends VSError
	{
		
		/**
		 * 
		 * <code>SingleTonError</code>构造函数。
		 * 
		 * @param instance:* 抛出此异常的实例。
		 * 
		 */
		
		public function SingleTonError($instance:*)
		{
			super(ClassUtil.getClassName($instance) + " is single ton mode!");
		}
		
	}
	
	
}