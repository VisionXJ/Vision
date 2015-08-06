package cn.vision.managers
{
	import cn.vision.utils.ClassUtil;
	
	import flash.utils.Dictionary;

	public final class ErrorManager extends Manager
	{
		
		/**
		 * 
		 * 注册一个错误类型
		 * 
		 */
		
		public static function registError($error:Class):uint
		{
			var u:Boolean = (! errors[$error]) && ClassUtil.validateSubclass($error, Error);
			if (u) errors[$error] = id++;
			
			return errors[$error];
		}
		
		
		/**
		 * @private
		 */
		private static var id:uint = 6000;
		
		
		/**
		 * @private
		 */
		private static const errors:Dictionary = new Dictionary;
		
	}
}