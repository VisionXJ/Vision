package cn.vision.interfaces
{
	
	import cn.vision.core.VSObject;

	
	public interface IExtra
	{
		
		/**
		 * An extra object for each vision instance, can store some property or so.
		 */
		function get extra():VSObject;
		
	}
}