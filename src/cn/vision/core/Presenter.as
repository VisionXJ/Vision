package cn.vision.core
{
	
	import cn.vision.errors.UnavailableError;
	import cn.vision.events.QueueEvent;
	import cn.vision.events.RevocableQueueEvent;
	import cn.vision.managers.CommandManager;
	import cn.vision.queue.RevokableCommandQueue;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.ClassUtil;
	
	
	/**
	 * Application流程控制处理类。<br>
	 * 一个application只建立一个处理类，请编写Presenter的子类并使用单例模式。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Presenter extends VSObject
	{
		
		/**
		 * 构造函数。
		 */
		public function Presenter()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 初始化处理器，创建命令队列，为队列注册撤销恢复侦听事件。
		 * @private
		 */
		private function initialize():void
		{
			queue = new RevokableCommandQueue;
			queue.addEventListener(QueueEvent.STEP_END, command_endHandler);
			queue.addEventListener(RevocableQueueEvent.REDO_END, command_endHandler);
			queue.addEventListener(RevocableQueueEvent.UNDO_END, command_endHandler);
		}
		
		/**
		 * @private
		 */
		private function command_endHandler($e:QueueEvent):void
		{
			redoable = queue.redoable;
			undoable = queue.undoable;
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
			if ($useQueue)
				queue.execute($command);
			else
				$command.execute();
		}
		
		
		/**
		 * 重做。
		 */
		public function redo():void
		{
			queue.redo();
		}
		
		
		/**
		 * 撤销。
		 */
		public function undo():void
		{
			queue.undo();
		}
		
		
		/**
		 * 启动application调用此函数。
		 * 
		 * @param $app:* 主程序实例。
		 * @param ...$args 其他需要传入的参数。
		 * 
		 */
		public function start($app:*, ...$args):void
		{
			if (vs::presenter == null)
			{
				vs::presenter = this;
				
				app = $app;
				setup.apply(null, $args);
			}
		}
		
		
		/**
		 * 获取presenter实例。
		 */
		internal static function get presenter():Presenter
		{
			return vs::presenter;
		}
		
		
		/**
		 * 能否进行反撤销操作。
		 */
		public var redoable:Boolean;
		
		
		/**
		 * 能否进行撤销操作。
		 */
		public var undoable:Boolean;
		
		
		/**
		 * 启动创建流程，请在子类覆盖此方法。
		 * 
		 * @param ...$args 其他需要传入的参数。
		 * 
		 */
		protected function setup(...$args):void { }
		
		
		/**
		 * 程序主入口。
		 */
		protected var app:*;
		
		/**
		 * 撤销恢复命令队列。
		 */
		protected var queue:RevokableCommandQueue;
		
		
		/**
		 * @private
		 */
		vs static var presenter:Presenter;
		
	}
}