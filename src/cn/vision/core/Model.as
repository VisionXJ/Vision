package cn.vision.core
{
	
	import cn.vision.collections.Holder;
	import cn.vision.errors.UnavailableError;
	import cn.vision.interfaces.IView;
	import cn.vision.managers.CommandManager;
	import cn.vision.managers.ModelManager;
	import cn.vision.managers.ViewManager;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.ClassUtil;
	
	
	/**
	 * 业务逻辑模型，用于处理视图逻辑，数据交互，数据解析。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Model extends VSEventDispatcher
	{
		
		/**
		 * 构造函数。
		 */
		public function Model()
		{
			super();
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IDestroy#destroy()
		 */
		override public function destroy():void
		{
			viewStore.destroy();
			viewStore = null;
		}
		
		
		/**
		 * 根据已注册的命令名称执行对应的命令。
		 * 
		 * @param $commandName:String
		 * @param $useQueue:Boolean (default = true)，是否使用队列执行该命令。
		 * 
		 */
		public function execute($command:Command, $useQueue:Boolean = true):void
		{
			if (Presenter.presenter)
				Presenter.presenter.execute($command, $useQueue);
		}
		
		
		/**
		 * 注册一个视图实例，视图必须实现IView接口。
		 * 
		 * @param $view:IView 要注册的视图实例。
		 * 
		 * @return Boolean 是否注册成功。
		 * 
		 */
		public function registView($name:String, $view:IView):Boolean
		{
			return viewStore.registData($name, $view);
		}
		
		
		/**
		 * 根据注册的名称索引删除已注册的IView实例。
		 * 
		 * @param $viewName:String 名称索引。
		 * 
		 * @return Boolean 是否移除成功。
		 * 
		 */
		public function removeView($name:String):Boolean
		{
			return viewStore.removeData($name);
		}
		
		
		/**
		 * 获取注册的视图实例。
		 * 
		 * @param $viewName:String 要获取的视图实例名称。
		 * 
		 * @return IView 获取到的视图实例。
		 * 
		 */
		public function retrieveView($name:String):IView
		{
			return viewStore.retrieveData($name) || ViewManager.retrieveView($name);
		}
		
		
		/**
		 * @copy cn.vision.managers.ModelManager#retrieveModel()
		 */
		public function retrieveModel($name:String):Model
		{
			return ModelManager.retrieveModel($name);
		}
		
		
		/**
		 * @private
		 */
		private var viewStore:Holder = new Holder;
		
	}
}