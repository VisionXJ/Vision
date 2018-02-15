package cn.vision.utils
{

	import cn.vision.core.NoInstance;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 定义了一些常用Timer操作。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	public final class TimerUtil extends NoInstance
	{
		
		/**
		 * 创建一个Timer。
		 * 
		 * @param $delay:uint 计时器事件间的延迟（以毫秒为单位）。建议 delay 不要低于 20 毫秒。计时器频率不得超过 60 帧/秒，这意味着低于 16.6 毫秒的延迟可导致出现运行时问题。
		 * @param $repeat:uint (default = 0) 指定重复次数。如果为 0，则计时器重复无限次数。如果不为 0，则将运行计时器，运行次数为指定的次数，然后停止。 
		 * @param $tick:Function (default = null) 计时器每次触发的回调函数。
		 * @param $complete:Function (default = null) 计时器最后一次触发的回调函数。
		 * @param $start:Boolean (default = true) 是否立即启动。
		 * 
		 * @return Timer
		 * 
		 */
		public static function createTimer(
			$delay:uint, 
			$repeat:uint = 0, 
			$tick:Function = null, 
			$complete:Function = null, 
			$start:Boolean = true):Timer
		{
			if($delay && ($tick!= null || $complete!= null))
			{
				var timer:Timer = new Timer($delay * 1000, $repeat);
				
				if ($tick!= null)
					timer.addEventListener(TimerEvent.TIMER, $tick);
				if ($repeat && $complete!= null)
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, $complete);
				
				if ($start) timer.start();
			}
			return timer;
		}
		
		/**
		 * 延迟一段时间执行函数。
		 * 
		 * @param $time:Number 延迟时间，毫秒为单位。
		 * @param $func:Function 要延迟执行的函数。
		 * @param ...$args 延迟执行的函数所需的相关参数。
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