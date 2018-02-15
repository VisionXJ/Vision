package cn.vision.interfaces
{
	
	/**
	 * 
	 * 命令执行器接口。
	 * 
	 */
	
	
	import cn.vision.core.Command;
	
	
	public interface IProcesser
	{
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		function execute($command:Command, $useQueue:Boolean = true):void;
		
	}
}