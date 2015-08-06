package cn.vision.interfaces
{
	public interface IName
	{
		
		/**
		 * 
		 * The class name of instance. 
		 * 
		 */
		function get className():String
		
		
		/**
		 * 
		 * The name of instance.
		 * 
		 */
		function get instanceName():String
		
		/**
		 * @private
		 */
		function set instanceName($value:String):void
	}
}