package cn.vision.interfaces
{
	
	public interface ITimeout
	{
		
		/**
		 * 超时时长，以秒为单位。
		 */
		function get timeout():uint;
		
		/**
		 * @private
		 */
		function set timeout($value:uint):void;
		
	}
}