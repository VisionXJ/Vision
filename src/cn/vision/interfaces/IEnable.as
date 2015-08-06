package cn.vision.interfaces
{
	public interface IEnable
	{
		/**
		 * set ui enabled or not.
		 */
		function get enabled():Boolean
		
		/**
		 * @private
		 */
		function set enabled($value:Boolean):void
	}
}