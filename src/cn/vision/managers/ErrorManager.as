package cn.vision.managers
{
	
	import cn.vision.collections.Holder;
	import cn.vision.consts.Consts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	import cn.vision.errors.*;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	
	/**
	 * 错误管理器。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ErrorManager extends Manager
	{
		
		/**
		 * 注册一个错误类型。
		 * 
		 * @param $error:Class
		 * 
		 * @return uint 错误ID。
		 * 
		 */
		public static function registError($error:Class):Boolean
		{
			var result:Boolean = ClassUtil.validateSubclass($error, VSError);
			if (result) ERRORS.registData(ClassUtil.getClassName($error), IDUtil.generateID(Consts.vs::VS_ERROR));
			else throw new ArgumentNotSubClassError($error, VSError);
			return result;
		}
		
		
		/**
		 * 获取错误类型的ID。
		 * 
		 * @param $error:Class
		 * 
		 * @return uint 错误ID。
		 * 
		 */
		public static function retrieveErrorID($error:*):uint
		{
			return ERRORS.retrieveData(ClassUtil.getClassName($error));
		}
		
		
		/**
		 * 删除一个错误类型。
		 * 
		 * @param $error:Class
		 * 
		 * @return Boolean 是否删除成功。
		 * 
		 */
		public static function removeError($error:*):Boolean
		{
			return ERRORS.removeData(ClassUtil.getClassName($error));
		}
		
		
		/**
		 * @private
		 */
		private static function initializeErrors():Boolean
		{
			if(!ERRORS_INITED)
			{
				IDUtil.registID(Consts.vs::VS_ERROR, 6000);
				
				registError(AbstractError);
				registError(SingleTonError);
				registError(ClassPatternError);
				registError(ArgumentNumError);
				registError(ArgumentNotNullError);
				registError(ArgumentInvalidError);
				registError(ArgumentDateError);
				registError(ArgumentNotSubClassError);
				registError(UnavailableError);
				registError(DestroyNotEmptiedError);
				registError(DestroyQueueExecutingError);
			}
			return true;
		}
		
		/**
		 * @private
		 */
		private static const ERRORS:Holder = new Holder;
		
		/**
		 * @private
		 */
		private static const ERRORS_INITED:Boolean = initializeErrors();
		
	}
}