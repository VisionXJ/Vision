package cn.vision.errors
{
	
	/**
	 * 
	 * FTP请求异常，当FTP请求为空，或者请求不合法时，会抛出此异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	public final class FTPRequestError extends VSError
	{
		
		/**
		 * 
		 * <code>FTPRequestError</code>构造函数。
		 * 
		 */
		
		public function FTPRequestError()
		{
			super("FTP请求不能为空，且请求必须合法，请检查请求的IP，端口，用户名，密码，加载与存储路径！");
		}
		
	}
}