package cn.vision.core
{
	
	/**
	 * 
	 * 定义无需实例化类基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	public class NoInstance
	{
		public function NoInstance()
		{
			throw new Error("Class Pattern");
		}
		
	}
}