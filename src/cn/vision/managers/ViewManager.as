package cn.vision.managers
{
	
	import cn.vision.collections.Holder;
	import cn.vision.errors.ArgumentNotNullError;
	import cn.vision.interfaces.IView;
	
	
	/**
	 * 视图类管理器。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ViewManager extends Manager
	{
		/**
		 * 注册一个IView实例。
		 * 
		 * @param $name:String 名称索引。
		 * @param $view:IView 要注册的Model。
		 * 
		 * @return Boolean 是否注册成功。
		 * 
		 */
		public static function registView($name:String, $view:IView):Boolean
		{
			var result:Boolean = $name != null && $view != null;
			if (result) VIEWS.registData($name, $view);
			else throw new ArgumentNotNullError("$name", "$view");
			return result;
		}
		
		
		/**
		 * 根据注册的名称索引删除已注册的IView实例。
		 * 
		 * @param $name:String 名称索引。
		 * 
		 * @return Boolean 是否移除成功。
		 * 
		 */
		public static function removeView($name:String):Boolean
		{
			return VIEWS.removeData($name);
		}
		
		
		/**
		 * 根据注册的名称索引获取IView实例。
		 * 
		 * @param $name:String 名称索引。
		 * 
		 * @return IView 获取到的IView。
		 * 
		 */
		public static function retrieveView($name:String):IView
		{
			return VIEWS.retrieveData($name);
		}
		
		
		/**
		 * @private
		 */
		private static const VIEWS:Holder = new Holder;
		
	}
}