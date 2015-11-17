package cn.vision.net
{
	
	/**
	 * 
	 * HTTP文件加载存储器，支持断点续传。<br>
	 * AIR Only
	 * 
	 * @see cn.vision.net.HTTPRequest
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.errors.HTTPRequestError;
	import cn.vision.interfaces.ITimeout;
	import cn.vision.system.VSFile;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	/**
	 * 
	 * 文件加载完毕时派发此事件。
	 * 
	 */
	
	[Event(name="complete", type="flash.events.Event")]
	
	
	/**
	 * 
	 * 文件不存在或网络不连通时派发此事件。
	 * 
	 */
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * 
	 * 进度发生改变时派发此事件。
	 * 
	 */
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	
	/**
	 * 
	 * 安全错误，当不允许跨域加载文件，或用户名密码错误时会派发此事件。
	 * 
	 */
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	public final class HTTPLoader extends VSEventDispatcher implements ITimeout
	{
		
		/**
		 * 
		 * <code>HTTPLoader</code>构造函数。
		 * 
		 * @param $request:HTTPRequest (defalut = null) 需要加载的HTTP请求。
		 * 
		 * @see cn.vision.net.HTTPRequest
		 * 
		 */
		
		public function HTTPLoader($request:HTTPRequest = null)
		{
			super();
			
			resolveRequest($request);
		}
		
		
		/**
		 * 
		 * 开始HTTP加载。
		 * 
		 * @param $request:HTTPRequest (default = null) 需要加载的HTTP请求。
		 * 
		 * @see cn.vision.net.HTTPRequest
		 * 
		 */
		
		public function load($request:HTTPRequest = null):void
		{
			if (resolveRequest($request))
			{
				vs::loading = true;
				vs::speed = 0;
				time = getTimer();
				file = file || new VSFile(saveURL);
				if (file.exists)
				{
					close();
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					temp = temp || new VSFile(saveURL + ".tmp");
					if(!stream)
					{
						stream = new FileStream;
						stream.open(temp, FileMode.APPEND);
					}
					if(!loader)
					{
						loader = new URLStream;
						loader.addEventListener(Event.COMPLETE, handlerDefault);
						loader.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
						loader.addEventListener(ProgressEvent.PROGRESS, handlerLoaderProgress);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDefault);
					}
					vs::bytesLoaded = temp.exists ? temp.size : 0;
					var request:URLRequest = new URLRequest(loadURL);
					var headers:URLRequestHeader = new URLRequestHeader("Range", "bytes="+bytesLoaded+"-");
					request.requestHeaders.push(headers);
					loader.load(request);
				}
			}
			else
			{
				throw new HTTPRequestError;
			}
		}
		
		
		/**
		 * 
		 * 停止HTTP加载。
		 * 
		 */
		
		public function close():void
		{
			if (vs::loading)
			{
				vs::loading = false;
				if (stream) stream.close();
				if ( temp && file && temp.exists && temp.size == bytesTotal && 
					(!file.exists || file.exists && file.size != bytesTotal)) temp.moveTo(file, true);
				if (loader)
				{
					loader.removeEventListener(Event.COMPLETE, handlerDefault);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
					loader.removeEventListener(ProgressEvent.PROGRESS, handlerLoaderProgress);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDefault);
					loader.connected && loader.close();
				}
				stream = null;
				temp = file = null;
				loader = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function resolveRequest($request:HTTPRequest):Boolean
		{
			if (request || $request)
			{
				var result:Boolean = ! ($request && (!request || 
					request.loadURL  != $request.loadURL || 
					request.saveURL  != $request.saveURL));
				if(!result)
				{
					request = $request;
					result  = request.available;
					if(!result) close();
				}
			}
			return result;
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault($e:Event):void
		{
			close();
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerLoaderProgress($e:ProgressEvent):void
		{
			vs::bytesTotal = isNaN(bytesTotal) ? bytesLoaded + $e.bytesTotal : bytesTotal;
			if (file && file.exists && file.size == bytesTotal)
			{
				close();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				var bytes:ByteArray = new ByteArray;
				loader.readBytes(bytes, 0, loader.bytesAvailable);
				vs::bytesLoaded += bytes.bytesAvailable;
				vs::speed = bytesLoaded / (getTimer() - time);
				stream.writeBytes(bytes, 0, bytes.bytesAvailable);
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, 
					false, false, bytesLoaded, bytesTotal));
			}
		}
		
		
		/**
		 * 
		 * 文件已加载字节数。
		 * 
		 */
		
		public function get bytesLoaded():Number
		{
			return vs::bytesLoaded;
		}
		
		
		/**
		 * 
		 * 文件总字节数。
		 * 
		 */
		
		public function get bytesTotal():Number
		{
			return vs::bytesTotal;
		}
		
		
		/**
		 * 
		 * 加载地址。
		 * 
		 */
		
		public function get loadURL():String
		{
			return request ? request.loadURL : null;
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
		 * 存储地址。
		 * 
		 */
		
		public function get saveURL():String
		{
			return request ? request.saveURL : null;
		}
		
		
		/**
		 * 
		 * 下载速度，单位：字节/毫秒。
		 * 
		 */
		
		public function get speed():Number
		{
			return vs::speed;
		}
		
		
		/**
		 * @inheritDoc
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
			if ($value != vs::timeout)
			{
				vs::timeout = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		private var time:int;
		
		/**
		 * @private
		 */
		private var temp:VSFile;
		
		/**
		 * @private
		 */
		private var file:VSFile;
		
		/**
		 * @private
		 */
		private var stream:FileStream;
		
		/**
		 * @private
		 */
		private var loader:URLStream;
		
		/**
		 * @private
		 */
		private var request:HTTPRequest;
		
		
		/**
		 * @private
		 */
		vs var bytesLoaded:Number;
		
		/**
		 * @private
		 */
		vs var bytesTotal:Number;
		
		/**
		 * @private
		 */
		vs var loading:Boolean;
		
		/**
		 * @private
		 */
		vs var speed:Number;
		
		/**
		 * @private
		 */
		vs var timeout:uint;
		
	}
}