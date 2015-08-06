package cn.vision.utils
{
	
	/**
	 * 
	 * 用于为新的实例生成唯一ID标识。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	
	public final class IDUtil extends NoInstance
	{
		
		/**
		 * 生成一个新的实例ID标识。
		 * 
		 * @return <code>String</code>
		 */
		
		public static function generateID():uint
		{
			return id++;
		}
		
		private static var id:uint = 0;
		
	}
}