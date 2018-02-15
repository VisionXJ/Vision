package cn.vision.managers
{
	
	import cn.vision.collections.Holder;
	import cn.vision.collections.Map;
	import cn.vision.core.Command;
	import cn.vision.errors.ArgumentNotNullError;
	import cn.vision.errors.ArgumentNotSubClassError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.interfaces.IProcesser;
	import cn.vision.utils.ClassUtil;
	
	
	/**
	 * 命令类管理器。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class CommandManager extends Manager
	{
		
		/**
		 * 注册一种命令类。
		 * 
		 * @param $name:String 命令名称。
		 * @param $command:Class 命令类。
		 * 
		 * @return Boolean 是否注册成功。
		 * 
		 */
		public static function registCommand($name:String, $command:Class):Boolean
		{
			var result:Boolean = $name != null && $command != null;
			if (result)
			{
				result = ClassUtil.validateSubclass($command, Command);
				
				if (result) COMMANDS.registData($name, $command);
				else throw new ArgumentNotSubClassError($command, Command);
			}
			else throw new ArgumentNotNullError("$name", "$command");
			
			return result;
		}
		
		
		/**
		 * 删除一种命令类。
		 * 
		 * @param $name:String 命令类名。
		 * 
		 * @return Boolean 是否移除成功。
		 * 
		 */
		public static function removeCommand($name:String):Boolean
		{
			return COMMANDS.removeData($name);
		}
		
		
		/**
		 * 
		 * 获取一种命令类。
		 * 
		 */
		
		public static function retrieveCommand($name:String):Class
		{
			return COMMANDS.retrieveData($name);
		}
		
		
		/**
		 * @private
		 */
		private static const COMMANDS:Holder = new Holder;
		
	}
}