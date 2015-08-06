package cn.vision.pattern.core
{
	
	/**
	 * 
	 * 核心处理类。<br>
	 * 一般一个application只建立一个处理类，请编写Presenter的子类并使用单例模式。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.vision.core.VSEventDispatcher;

	
	public class Presenter extends VSEventDispatcher
	{
		
		/**
		 * <code>Presenter</code>构造函数。
		 */
		
		public function Presenter()
		{
			super();
		}
		
		
		/**
		 * 
		 * 启动application调用此函数。
		 * 
		 */
		
		public function start($app:*, ...$args):void
		{
			app = $app;
			setup.apply(this, $args);
		}
		
		
		/**
		 * 
		 * 启动创建流程，请在子类覆盖此方法。
		 * 
		 */
		
		protected function setup(...$args):void { }
		
		
		/**
		 * 程序主入口。
		 */
		protected var app:*;
		
	}
}