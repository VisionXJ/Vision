package cn.vision.managers
{
	
	import cn.vision.consts.KeyboardConsts;
	import cn.vision.datas.Callback;
	import cn.vision.managers.Manager;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	/**
	 * 快捷键管理器，为功能函数注册快捷键。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class KeyboardManager extends Manager
	{
		
		/**
		 * 初始化舞台。
		 * 
		 * @param $stage:Stage 舞台实例。
		 * 
		 */
		public static function initialize($stage:Stage):void
		{
			if(!stage&& $stage)
			{
				callbacks = {};
				
				stage = $stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, key_downHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP, key_upHandler);
				
				callableTimer = new Timer(500, 1);
				callableTimer.addEventListener(TimerEvent.TIMER_COMPLETE, call_delayHandler);
				
				timerShift = new Timer(250, 1);
				timerCtrl  = new Timer(250, 1);
				timerAlt   = new Timer(250, 1);
				timerShift.addEventListener(TimerEvent.TIMER_COMPLETE, shift_delayHandler);
				timerCtrl .addEventListener(TimerEvent.TIMER_COMPLETE, ctrl_delayHandler);
				timerAlt  .addEventListener(TimerEvent.TIMER_COMPLETE, alt_delayHandler);
			}
		}
		
		
		/**
		 * 清除所有已注册的快捷键，如果要重新注册快捷键，需要再次调用initialize。
		 */
		public static function clear():void
		{
			if (stage)
			{
				callbacks = null;
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_downHandler);
				stage.removeEventListener(KeyboardEvent.KEY_UP, key_upHandler);
				stage = null;
				
				callableTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, call_delayHandler);
				
				timerShift.removeEventListener(TimerEvent.TIMER_COMPLETE, shift_delayHandler);
				timerCtrl .removeEventListener(TimerEvent.TIMER_COMPLETE, ctrl_delayHandler);
				timerAlt  .removeEventListener(TimerEvent.TIMER_COMPLETE, alt_delayHandler);
				callableTimer = timerShift = timerCtrl = timerAlt = null;
			}
		}
		
		
		private static function key_downHandler($e:KeyboardEvent):void
		{
			processFunc(false, $e.keyCode, $e.shiftKey, $e.ctrlKey, $e.altKey);
		}
		
		private static function key_upHandler($e:KeyboardEvent):void
		{
			processFunc(true, $e.keyCode, $e.shiftKey, $e.ctrlKey, $e.altKey);
		}
		
		private static function call_delayHandler($e:TimerEvent):void
		{
			callable = true;
		}
		
		private static function shift_delayHandler($e:TimerEvent):void
		{
			shift = false;
		}
		
		private static function ctrl_delayHandler($e:TimerEvent):void
		{
			ctrl = false;
		}
		
		private static function alt_delayHandler($e:TimerEvent):void
		{
			alt = false;
		}
		
		
		/**
		 * 根据按下的快捷键检查是否有注册对应的功能函数，如果有则执行该功能函数。
		 * @private
		 */
		private static function processFunc($up:Boolean, $keyCode:uint, $shift:Boolean, $ctrl:Boolean, $alt:Boolean):void
		{
			if ($up) 
			{
				executingKey = null;
				//为了获得更好的体验，有时人为按下功能键会有误差，这是对按下功能键操作作一定的延时处理。
				if (shift && !$shift) resetStartTimer(timerShift);
				if (ctrl  && !$ctrl ) resetStartTimer(timerCtrl );
				if (alt   && !$alt  ) resetStartTimer(timerAlt  );
			}
			else
			{
				if ($shift && !shift) shift = $shift;
				if ($ctrl  && !ctrl ) ctrl  = $ctrl ;
				if ($alt   && !alt  ) alt   = $alt  ;
			}
			var key:String = $keyCode + "-" + shift + "-" + ctrl + "-" + alt;
			if (callable)
			{
				var callback:Callback = callbacks[key];
				if (callback!= null)
				{
					if (executingKey != key) 
					{
						callable = false;
						resetStartTimer(callableTimer);
					}
					callback.call();
					executingKey = key;
				}
			}
		}
		
		/**
		 * 重置计时器。
		 */
		private static function resetStartTimer($timer:Timer):void
		{
			if($timer)
			{
				$timer.reset();
				$timer.start();
			}
		}
		
		
		/**
		 * 对函数注册一个快捷键，重复的快捷键注册会覆盖以前注册的功能。
		 * 
		 * @param $keyCode:uint 按键对应的keyCode
		 * @param $up:Boolean (default = false) 指示函数是在按下时触发还是弹起时触发。
		 * @param $funcKey:uint (default = 0) 指示ctrl，shift，alt等功能键。
		 * @param $handler:Function (default = null) 要触发的函数。
		 * @param $...$args 函数相关参数。
		 * 
		 * @see cn.vision.consts.KeyboardConsts
		 * 
		 */
		public static function registControl($keyCode:uint, $funcKey:uint = 0, $handler:Function = null, ...$args):void
		{
			var callback:Callback = new Callback($handler, $args);
			if (callback.available)
			{
				var key:String = $keyCode + "-" + getFuncKeyIndex($funcKey);
				callbacks[key] = callback;
			}
		}
		
		
		/**
		 * 移除一个已注册的快捷键关联。
		 * 
		 * @param $keyCode:uint 按键对应的keyCode
		 * @param $up:Boolean (default = false) 指示函数是在按下时触发还是弹起时触发。
		 * @param $funcKey:uint (default = 0) 指示ctrl，shift，alt等功能键。
		 * 
		 * @see cn.vision.consts.FuncKeyConsts
		 * 
		 */
		public static function removeControl($keyCode:uint, $funcKey:uint = 0):void
		{
			var key:String = $keyCode + "-" + getFuncKeyIndex($funcKey);
			if (callbacks[key] != null) delete callbacks[key];
		}
		
		
		/**
		 * 根据使用的快捷键获取功能键索引。
		 */
		private static function getFuncKeyIndex($funKey:uint):String
		{
			return FUNCKEYS[$funKey];
		}
		
		
		/**
		 * 功能键字典。
		 */
		private static const FUNCKEYS:Object = {
			1 : "true-false-false", // SHIFT
			2 : "false-true-false", // CTRL
			4 : "false-false-true", // ALT
			3 : "true-true-false" , // SHIFT | CTRL
			5 : "true-false-true" , // SHIFT | ALT
			6 : "false-true-true" , // CTRL  | ALT
			7 : "true-true-true"  , // SHIFT | CTRL | ALT
			0 : "false-false-false" // NONE
		};
		
		
		/**
		 * 存储是否按下shift键。
		 */
		private static var shift:Boolean;
		
		/**
		 * 存储是否按下ctrl键。
		 */
		private static var ctrl:Boolean;
		
		/**
		 * 存储是否按下alt键。
		 */
		private static var alt:Boolean;
		
		/**
		 * 用于延迟ctrl功能按键弹起的计时器。
		 */
		private static var timerCtrl:Timer;
		
		/**
		 * 用于延迟shift功能按键弹起的计时器。
		 */
		private static var timerShift:Timer;
		
		/**
		 * 用于延迟alt功能按键弹起的计时器。
		 */
		private static var timerAlt:Timer;
		
		/**
		 * 控制快捷键开启关闭的计时器。
		 */
		private static var callableTimer:Timer;
		
		/**
		 * 能否使用快捷键调用函数。
		 */
		private static var callable:Boolean = true;
		
		/**
		 * 当前执行的快捷键索引。
		 */
		private static var executingKey:String;
		
		/**
		 * 存储舞台实例。
		 * @private
		 */
		private static var stage:Stage;
		
		/**
		 * 存储按快捷键索引注册的功能函数。
		 * @private
		 */
		private static var callbacks:Object;
		
	}
}