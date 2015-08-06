package cn.vision.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 定义了一些常用Timer操作。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	public class TimerUtil
	{
		
		/**
		 * 
		 * 延迟一段时间执行函数。
		 * 
		 */
		
		public static function callLater($time:Number, $func:Function, ...$args):void
		{
			var timer:Timer = new Timer($time, 1);
			var handlerCallLater:Function = function($e:TimerEvent):void
			{
				$func.apply(null, $args);
				
				timer.removeEventListener(TimerEvent.TIMER, handlerCallLater);
				timer.stop();
				timer = null;
			};
			timer.addEventListener(TimerEvent.TIMER, handlerCallLater);
			timer.start();
		}
		
	}
}
