package cn.vision.errors
{
	
	/**
	 * 
	 * HTTP请求异常，当HTTP请求为空，或者请求不合法时，会抛出此异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	public final class HTTPRequestError extends VSError
	{
		
		/**
		 * 
		 * <code>HTTPRequestError</code>构造函数。
		 * 
		 */
		
		public function HTTPRequestError()
		{
			super("HTTP请求不能为空，且请求必须合法，请检查请求的加载与存储路径！");
		}
		
	}
}