package cn.vision.interfaces
{
	
	/**
	 * 
	 * 定义了超时时长属性。
	 * 
	 */
	
	
	public interface ITimeout
	{
		
		/**
		 * 
		 * 超时时长，以秒为单位。
		 * 
		 */
		
		function get timeout():uint;
		
		/**
		 * @private
		 */
		function set timeout($value:uint):void;
		
	}
}