package cn.vision.net
{
	
	import cn.vision.consts.NoticeConsts;
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.events.TimeoutEvent;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	import cn.vision.utils.RegexpUtil;
	
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
	
	
	/**
	 * 继承URLLoader，增加超时检测。
	 * 
	 * <rebuild>
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class URILoader extends URLLoader implements IExtra, IID, IName//, IState
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $request:URLRequest (default = null) 要访问的URL请求。
		 * 
		 */
		public function URILoader($request:URLRequest = null)
		{
			request = $request;
			super($request);
			initialize();
		}
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize():void
		{
			vs::vid = IDUtil.generateID();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function load($request:URLRequest):void
		{
			vs::loading = true;
			
			if ($request) request = $request;
			
			if (timeout)
			{
				createTimer();
				resetTimer();
			}
			
			addEventListener(Event.COMPLETE, handlerDefault);
			addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDefault);
			addEventListener(ProgressEvent.PROGRESS, handlerProgress);
			
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
		
		private function resetTimer():void
		{
			if (timer)
			{
				timer.reset();
				timer.start();
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
			
			dispatchEvent(new TimeoutEvent(TimeoutEvent.TIMEOUT, 
				RegexpUtil.replaceTag(NoticeConsts.vs::REQUEST_TIMEOUT, this)));
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get extra():VSObject
		{
			return(vs::extra = vs::extra || new VSObject);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get className():String
		{
			return vs::className = vs::className || ClassUtil.getClassName(this);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get instanceName():String { return vs::instanceName; }
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::instanceName = $value;
		}
		
		
		/**
		 * 是否在加载状态。
		 */
		public function get loading():Boolean
		{
			return vs::loading as Boolean;
		}
		
		
		/**
		 * 超时时长，以秒为单位，若在加载过程中设置timeout属性，会重置当前的超时检测时间。
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
		 * @copy flash.net.URLRequest.url
		 */
		public function get url():String
		{
			return request ? request.url : null;
		}
		
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var request:URLRequest;
		
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var loading:Boolean;
		
		/**
		 * @private
		 */
		vs var timeout:uint;
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var instanceName:String;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
	}
}