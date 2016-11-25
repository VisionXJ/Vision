package cn.vision.net
{
	
	/**
	 * 
	 * 继承URLLoader，增加超时检测。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	import cn.vision.events.TimeoutEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	
	/**
	 * 
	 * 超时事件，当加载时间超过指定时长时抛出。
	 * 
	 */
	
	[Event(name="timeout", type="cn.vision.events.TimeoutEvent")]
	
	
	public class URILoader extends URLLoader
	{
		
		/**
		 * 
		 * <code>URILoader</code> 构造函数。
		 * 
		 */
		
		public function URILoader($request:URLRequest = null)
		{
			super($request);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function load($request:URLRequest):void
		{
			vs::loading = true;
			
			if (timeout)
			{
				createTimer();
				timer.reset();
				timer.start();
			}
			
			addEventListener(Event.COMPLETE, handlerDefault);
			addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDefault);
			addEventListener(ProgressEvent.PROGRESS, handlerProgress);  //下载过程中 收到数据时调度
			
			super.load($request);
		}
		
		/**
		 * @private
		 */
		private function createTimer():void
		{
			if(!timer)
			{
				timer = new Timer(1000, timeout);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerTimerComplete);
			}
		}
		
		/**
		 * @private
		 */
		private function removeTimer():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlerTimerComplete);
				timer.stop();
				timer = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault($e:Event):void
		{
			removeEventListener(Event.COMPLETE, handlerDefault);
			removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDefault);
			removeEventListener(ProgressEvent.PROGRESS, handlerProgress);
			
			removeTimer();
			
			vs::loading = false;
		}
		
		/**
		 * @private
		 */
		private function handlerProgress($e:Event):void
		{
			if (timer) timer.reset();
		}
		
		/**
		 * @private
		 */
		private function handlerTimerComplete($e:TimerEvent):void
		{
			handlerDefault(null);
			
			dispatchEvent(new TimeoutEvent(TimeoutEvent.TIMEOUT));
		}
		
		
		/**
		 * 
		 * 是否在加载状态。
		 * 
		 */
		
		public function get loading():Boolean
		{
			return Boolean(vs::loading);
		}
		
		
		/**
		 * 
		 * 超时时长，以秒为单位，若在加载过程中设置timeout属性，会重置当前的超时检测时间。
		 * 
		 */
		
		public function get timeout():uint
		{
			return vs::timeout;
		}
		
		/**
		 * @private
		 */
		public function set timeout($value:uint):void
		{
			vs::timeout = $value;
			
			if (loading)
			{
				createTimer();
				timer.repeatCount = timeout;
				timer.reset();
				timer.start();
			}
		}
		
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		
		
		/**
		 * @private
		 */
		vs var loading:Boolean;
		
		/**
		 * @private
		 */
		vs var timeout:uint;
		
	}
}