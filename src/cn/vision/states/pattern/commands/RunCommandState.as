package cn.vision.states.pattern.commands
{
	
	/**
	 * ExecutingCommandState describe the command state when it's executing.
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 */
	
	
	import cn.vision.pattern.core.State;
	
	
	public final class RunCommandState extends State
	{
		public function RunCommandState()
		{
			super();
		}
		
		public static var TITLE:String = "runCommandState";
		
	}
}