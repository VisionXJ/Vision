package cn.vision.commands
{
	
	import cn.vision.core.Command;
	import cn.vision.core.vs;
	import cn.vision.errors.UnavailableError;
	
	
	/**
	 * 撤销机制命令，与可撤销队列结合起来使用。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class RevokableCommand extends Command
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $sync:Boolean (default = true) 命令是否为同步，true为同步，false为异步。
		 * @param $revocable:Boolean (default = true) 是否允许撤销重做。
		 * 
		 */
		public function RevokableCommand($sync:Boolean, $revokable:Boolean = true)
		{
			super($sync);
			
			vs::revokable = $revokable;
		}
		
		
		/**
		 * 命令重做。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在重做的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processRedo。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.processRedo()
		 * 
		 */
		public function redo():void
		{
			if (available)
			{
				if (revokable)
				{
					commandStart();
					
					processRedo();
					
					if (sync) commandEnd();
				}
			}
			else
			{
				throw new UnavailableError(this);
			}
		}
		
		
		/**
		 * 命令重做。<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.redo()
		 * 
		 */
		protected function processRedo():void { }
		
		
		/**
		 * 命令撤销。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在撤销的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processUndo。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.processUndo()
		 * 
		 */
		public function undo():void
		{
			if (available)
			{
				if (revokable)
				{
					commandStart();
					
					processUndo();
					
					if (sync) commandEnd();
				}
			}
			else
			{
				throw new UnavailableError(this);
			}
		}
		
		
		/**
		 * 命令撤销。<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.undo()
		 * 
		 */
		protected function processUndo():void { }
		
		
		/**
		 * 是否允许加入到撤销与反撤销执行队列中，
		 * 该参数在构造RevocableCommand时传入。
		 * 
		 */
		public function get revokable():Boolean
		{
			return vs::revokable as Boolean;
		}
		
		
		/**
		 * @private
		 */
		vs var revokable:Boolean;
		
	}
}