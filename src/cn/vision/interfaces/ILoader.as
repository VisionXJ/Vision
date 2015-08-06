package cn.vision.interfaces
{
	
	/**
	 * 
	 * 定义了Loader类型统一加载接口。
	 * 
	 */
	
	
	public interface ILoader extends ITimeout
	{
		
		/**
		 * 
		 * 加载一个请求。
		 * 
		 * @param $request:IRequest (default = null) 加载的请求。
		 * 
		 */
		
		function load($request:IRequest = null):void;
		
		
		/**
		 * 
		 * 如果正在加载，关闭当前加载过程。
		 * 
		 */
		
		function close():void;
		
		
		/**
		 * 
		 * 已加载的字节数。
		 * 
		 */
		
		function get bytesLoaded():Number;
		
		
		/**
		 * 
		 * 需要加载的总字节数。
		 * 
		 */
		
		function get bytesTotal():Number;
		
		
		/**
		 * 
		 * 是否在加载过程中。
		 * 
		 */
		
		function get loading():Boolean;
		
	}
}