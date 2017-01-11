package cn.vision.net
{
	
	/**
	 * 
	 * FTP文件加载存储器，支持断点续传。<br>
	 * AIR Only
	 * 
	 * @example
	 * <listing version="3.0">
	 * 		var loader:FTPLoader = new FTPLoader;
	 * 		var request:FTPRequest = new FTPRequest(host, userName, passWord, port, loadURL, saveURL);
	 * 		var loader_completeHandler:Function = function(e:Event):void
	 * 		{
	 * 			trace("load complete");
	 * 		};
	 * 		var loader_ioErrorHandler:Function = function(e:IOErrorEvent):void
	 * 		{
	 * 			trace("load ioError");
	 * 		};
	 * 		loader.load(request);
	 * </listing>
	 * 
	 * @see cn.vision.net.FTPRequest
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.errors.FTPRequestError;
	import cn.vision.interfaces.ITimeout;
	import cn.vision.system.VSFile;
	import cn.vision.utils.DebugUtil;
	import cn.vision.utils.LogUtil;
	import cn.vision.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	/**
	 * 
	 * 文件加载流被服务器关闭时派发此事件。
	 * 
	 */
	
	[Event(name="close", type="flash.events.Event")]
	
	
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
	 * 安全错误，当不允许跨域加载文件，或用户名密码错误时都会派发此事件。
	 * 
	 */
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	public final class FTPLoader extends VSEventDispatcher implements ITimeout
	{
		
		/**
		 * 
		 * <code>FTPLoader</code>构造函数。
		 * 
		 * @param $request:FTPRequest (defalut = null) 需要加载的FTP请求。
		 * 
		 * @see cn.vision.net.FTPRequest
		 * 
		 */
		
		public function FTPLoader($request:FTPRequest = null)
		{
			super();
			
			resolveRequest($request);
		}
		
		
		/**
		 * 
		 * 开始FTP加载。
		 * 
		 * @param $request:FTPRequest (default = null) 需要加载的FTP请求。
		 * 
		 * @see cn.vision.net.FTPRequest
		 * 
		 */
		
		public function load($request:FTPRequest = null):void
		{
			if (resolveRequest($request)) loadFile();
			else throw new FTPRequestError;
		}
		
		
		/**
		 * 
		 * 停止FTP加载。
		 * 
		 */
		
		public function close():void
		{
			closeInternal(false);
		}
		
		
		/**
		 * @private
		 */
		private function streamOpen():void
		{
			if(!stream)
			{
				stream = new FileStream;
				stream.open(temp, FileMode.APPEND);
			}
		}
		
		/**
		 * @private
		 */
		private function streamClose():void
		{
			if (stream) 
			{
				stream.close();
				stream = null;
			}
		}
		
		/**
		 * @private
		 */
		private function createTimer($repeat:uint, $handler:Function):void
		{
			if(!timer)
			{
				timerHandler = $handler;
				timer = new Timer(1000, $repeat);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
				timer.start();
			}
		}
		
		/**
		 * @private
		 */
		private function removeTimer():void
		{
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
				timer = null;
			}
		}
		
		/**
		 * @private
		 */
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
		private function socketCtrlCreate():void
		{
			if(!ctrlSocket)
			{
				ctrlSocket = new Socket;
				ctrlSocket.timeout = 3000;
				ctrlSocket.addEventListener(Event.CLOSE, handlerCtrlDefault);
				ctrlSocket.addEventListener(IOErrorEvent.IO_ERROR, handlerCtrlDefault);
				ctrlSocket.addEventListener(ProgressEvent.SOCKET_DATA, handlerCtrlProgress);
				ctrlSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerCtrlDefault);
			}
		}
		
		/**
		 * @private
		 */
		private function socketCtrlRemove():void
		{
			if (ctrlSocket)
			{
				ctrlSocket.removeEventListener(Event.CLOSE, handlerCtrlDefault);
				ctrlSocket.removeEventListener(IOErrorEvent.IO_ERROR, handlerCtrlDefault);
				ctrlSocket.removeEventListener(ProgressEvent.SOCKET_DATA, handlerCtrlProgress);
				ctrlSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerCtrlDefault);
				if (ctrlSocket.connected) ctrlSocket.close();
				ctrlSocket = null;
			}
		}
		
		/**
		 * @private
		 */
		private function socketDataCreate():void
		{
			if(!dataSocket)
			{
				dataSocket = new Socket;
				dataSocket.timeout = 3000;
				dataSocket.addEventListener(Event.CLOSE, handlerDataDefault);
				dataSocket.addEventListener(Event.CONNECT, handlerDataConnect);
				dataSocket.addEventListener(IOErrorEvent.IO_ERROR, handlerDataDefault);
				dataSocket.addEventListener(ProgressEvent.SOCKET_DATA, handlerDataProgress);
				dataSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDataDefault);
			}
		}
		
		/**
		 * @private
		 */
		private function socketDataRemove():void
		{
			if (dataSocket)
			{
				dataSocket.removeEventListener(Event.CLOSE, handlerDataDefault);
				dataSocket.removeEventListener(Event.CONNECT, handlerDataConnect);
				dataSocket.removeEventListener(IOErrorEvent.IO_ERROR, handlerDataDefault);
				dataSocket.removeEventListener(ProgressEvent.SOCKET_DATA, handlerDataProgress);
				dataSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDataDefault);
				if (dataSocket.connected) dataSocket.close();
				dataSocket = null;
			}
		}
		
		/**
		 * @private
		 */
		private function resolveRequest($request:FTPRequest):Boolean
		{
			if (request || $request)
			{
				//检测新的请求与现有的请求是否相同
				var same:Boolean =!($request && (!request || 
					request.host      != $request.host || 
					request.port      != $request.port || 
					request.userName  != $request.userName  || 
					request.passWord  != $request.passWord  || 
					request.remoteURL != $request.remoteURL || 
					request.localURL  != $request.localURL));
				//不同时，则把新的请求赋值给现有请求
				if(!same)
				{
					if(request) closeInternal(false);
					
					request = $request;
					
					vs::fileName = request.localURL.split("\\").pop();
				}
				var result:Boolean = request && request.available;
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function requestFile():void
		{
			if (temp.exists && temp.size > 0)
			{
				vs::bytesLoaded = temp.size;
				ctrlSocket.writeMultiByte("REST " + bytesLoaded + "\r\n", "utf8");
			}
			ctrlSocket.writeMultiByte("RETR " + remoteURL + "\r\n", "utf8");
			ctrlSocket.flush();
			
			createTimer(2, handlerDataProgressTimerOut);
		}
		
		/**
		 * @private
		 */
		private function loadFile():void
		{
			if(!vs::loading)
			{
				if(!FILES[request.localURL])
				{
					FILES[request.localURL] = this;
					
					vs::loading = true;
					vs::bytesLoaded = vs::bytesTotal = 0;
					vs::speed = 0;
					time = getTimer();
					count = 0;
					moving = avoid = false;
					
					file = new VSFile(localURL);
					temp = new VSFile(localURL + ".tmp");
					
					if (file.exists)
					{
						close();
						dispatchEvent(new Event(Event.COMPLETE));
					}
					else
					{
						if (temp.exists) vs::bytesLoaded = temp.size;
						socketCtrlCreate();
						ctrlSocket.connect(host, port);
					}
				}
				else
				{
					dispatchEvent(new SecurityErrorEvent(
						SecurityErrorEvent.SECURITY_ERROR,
						false, false, "文件 " + remoteURL + " 已经在加载。"))
				}
			}
		}
		
		/**
		 * @private
		 */
		private function reloadFile($deleteTemp:Boolean = false):void
		{
			//LogUtil.log("FTPLoader.reloadFile()", fileName);
			closeInternal(false, $deleteTemp);
			loadFile();
		}
		
		/**
		 * @private
		 */
		private function moveFile():void
		{
			if(!moving && bytesTotal &&
				file &&!file.exists && 
				temp && temp.exists)
			{
				//LogUtil.log("FTPLoader.moveFile()", fileName);
				moving = true;
				count = 0;
				socketCtrlRemove();
				socketDataRemove();
				streamClose();
				//如果不先取消temp的其他操作，文件移动过程中会出现导致软件卡死的现象。
				temp.cancel();
				temp.moveTo(file, true);
				
				closeInternal();
			}
		}
		
		/**
		 * @private
		 */
		private function getLoaded():Boolean
		{
			var result:Boolean = file && file.exists;
			if(!result) result = bytesLoaded >= bytesTotal;
			return result;
		}
		
		/**
		 * @private
		 */
		private function deleteTemp():void
		{
			if (temp && temp.exists) temp.deleteFile();
		}
		
		/**
		 * 有时文件传输完毕后dataSocket不会立刻关闭，此时移动临时文件至正式文件会出现卡死的情况，此处做一个延迟移动。
		 * @private
		 */
		private function closeInternal($complete:Boolean = true, $deleteTemp:Boolean = false):void
		{
			if (vs::loading)
			{
				//LogUtil.log("FTPLoader.closeInternal() complete", $complete, "loading:", vs::loading, fileName);
				vs::loading = moving = false;
				quitCtrl();
				removeTimer();
				socketDataRemove();
				socketCtrlRemove();
				streamClose();
				if ($deleteTemp) deleteTemp();
				file = temp = null;
				delete FILES[localURL];
				
				if ($complete) dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * @private
		 */
		private function commandFilter($item:*, $index:int, $array:Array):Boolean
		{
			return !StringUtil.isEmpty($item.substr(0, 3));
		}
		
		/**
		 * @private
		 */
		private function execute($code:String):void
		{
			if (this[$code] is Function) this[$code]();
		}
		
		/**
		 * @private
		 */
		private function quitCtrl():void
		{
			if (ctrlSocket && ctrlSocket.connected)
			{
				ctrlSocket.writeMultiByte("QUIT \r\n", "utf8");
				ctrlSocket.flush();
			}
		}
		
		
		/**
		 * 登陆。
		 * @private
		 */
		private function command220():void
		{
			if(!avoid)
			{
				avoid = true;
				ctrlSocket.writeMultiByte("USER " + userName + "\r\n", "utf8");
				ctrlSocket.flush();
			}
		}
		
		/**
		 * 输入密码。
		 * @private
		 */
		private function command331():void
		{
			ctrlSocket.writeMultiByte("PASS " + passWord + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 进入被动模式。
		 * @private
		 */
		private function command230():void
		{
			avoid = false;
			ctrlSocket.writeMultiByte("PASV\r\n", "utf8");
			ctrlSocket.flush();
			
			createTimer(3, handlerLoginTimerOut);
		}
		
		/**
		 * 设定数据传输socket的IP与端口，并获取文件大小。
		 * @private
		 */
		private function command227():void
		{
			removeTimer();
			const sa:int = data.indexOf("227");
			const st:int = data.indexOf("(", sa);
			const en:int = data.indexOf(")", sa);
			var a2:Array = data.substring(st + 1, en).split(",");
			const p1:int = a2.pop();
			const p2:int = a2.pop();
			dataHost = a2.join(".");
			dataPort = (p2 * 256) + p1;
			ctrlSocket.writeMultiByte("SIZE " + remoteURL + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 下载。
		 * @private
		 */
		private function command213():void
		{
			//LogUtil.log("FTPLoader.command213()", fileName);
			if(!bytesTotal) vs::bytesTotal = Number(data.substr(4));
			socketDataCreate();
			dataSocket.connect(dataHost, dataPort);
		}
		
		/**
		 * 用户名或密码错误。
		 * @private
		 */
		private function command421():void
		{
			if (++reloadCount < maxReload)
			{
				//服务端关闭了数据套接字需要重新连接
				//LogUtil.log(fileName, "连接数据层超时，重新连接");
				reloadFile();
			}
			else
			{
				//LogUtil.log("FTPLoader.command421()", "error", fileName);
				vs::code = "421";
				closeInternal(false);
				dispatchEvent(new SecurityErrorEvent(
					SecurityErrorEvent.SECURITY_ERROR, 
					false, false, data, 2124));
			}
		}
		
		/**
		 * @private
		 */
		private function command530():void
		{
			//LogUtil.log("FTPLoader.command530()", fileName);
			vs::code = "530";
			data += "," + request.host + "," + request.port + ",";
			closeInternal(false);
			dispatchEvent(new IOErrorEvent(
				IOErrorEvent.IO_ERROR,
				false, false, data, 2035));
		}
		
		/**
		 * FTP上文件不存在。
		 * @private
		 */
		private function command550():void
		{
			var bool:Boolean = data.indexOf("No support for resume of ASCII transfer") != -1;
			if (bool)
			{
				//不支持断点续传，重新下载
				//LogUtil.log(fileName, "FTP不支持断点续传，重新下载。");
				reloadFile(true);
			}
			else
			{
				//LogUtil.log("下载失败，文件不存在", fileName);
				vs::code = "550";
				closeInternal(false);
				dispatchEvent(new IOErrorEvent(
					IOErrorEvent.IO_ERROR,
					false, false, data.substr(4), 2035));
			}
		}
		
		
		/**
		 * @private
		 */
		private function handlerCtrlDefault($e:Event):void
		{
			if (++count < 1)
			{
				//LogUtil.log("FTPLoader.handlerCtrlDefault()", $e.type, "reload", fileName);
				ctrlSocket.connect(host, port);
			}
			else
			{
				//LogUtil.log(fileName, "无法连接控制层", host, port);
				closeInternal(false);
				var e:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR, 
					false, false, "无法链接控制层，" + host + ":" + port, 2037);
				vs::code = 501;
				dispatchEvent(e);
			}
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlProgress($e:ProgressEvent):void
		{
			var temp:String = ctrlSocket.readUTFBytes(ctrlSocket.bytesAvailable);
			var list:Array = temp.split("\n");
			list = list.filter(commandFilter, null);
			while (list.length)
			{
				data = list.shift();
				var tmp:String = data.substr(0, 3);
				if (tmp!= cmd)
				{
					//LogUtil.log(fileName, "FTPLoader.handlerCtrlProgress()", data);
					cmd = tmp;
					if(!StringUtil.isEmpty(cmd))
						DebugUtil.execute(execute, false, "command" + cmd);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataDefault($e:Event):void
		{
			if (getLoaded())
			{
				//LogUtil.log("FTPLoader.handlerDataDefault()", $e.type, "loaded", fileName);
				moveFile();
			}
			else
			{
				if (++count < 1)
				{
					//尚未下载完成，尝试重新连接
					//LogUtil.log("FTPLoader.handlerDataDefault()", $e.type, "reconnect", fileName);
					dataSocket.connect(dataHost, dataPort);
				}
				else
				{
					if (++reloadCount < maxReload)
					{
						//服务端关闭了数据套接字，有丢包情况，需要重新下载
						//LogUtil.log(fileName, "连接数据层断开，重新连接。");
						reloadFile();
					}
					else
					{
						closeInternal(false);
						dispatchEvent(new IOErrorEvent(
							IOErrorEvent.IO_ERROR,
							false, false, "超过了重试下载次数，仍未下载完毕。", 2035));
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataConnect($e:Event):void
		{
			streamOpen();
			requestFile();
		}
		
		/**
		 * @private
		 */
		private function handlerDataProgress($e:ProgressEvent):void
		{
			resetTimer();
			var bytes:ByteArray = new ByteArray;
			dataSocket.readBytes(bytes);
			stream.writeBytes(bytes, 0, bytes.bytesAvailable);
			
			vs::bytesLoaded = temp.exists ? temp.size : 0;
			vs::speed = bytesLoaded / (getTimer() - time);
			dispatchEvent(new ProgressEvent(
				ProgressEvent.PROGRESS, 
				false, false, bytesLoaded, bytesTotal));
			if (bytesLoaded >= bytesTotal)
			{
				//LogUtil.log("FTPLoader.handlerDataProgress()", fileName, "loaded");
				moveFile();
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataProgressTimerOut($e:TimerEvent):void
		{
			removeTimer();
			
			reloadFile();
		}
		
		/**
		 * @private
		 */
		private function handlerLoginTimerOut($e:TimerEvent):void
		{
			removeTimer();
			
			reloadFile();
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
		 * 一个提示编码，此编码通常由服务端返回。
		 * 
		 */
		
		public function get code():String
		{
			return vs::code;
		}
		
		
		/**
		 * 
		 * 文件名。
		 * 
		 */
		
		public function get fileName():String
		{
			return vs::fileName;
		}
		
		
		/**
		 * 
		 * host地址。
		 * 
		 */
		
		public function get host():String
		{
			return request ? request.host : null;
		}
		
		
		/**
		 * 
		 * 是否在加载状态。
		 * 
		 */
		
		public function get loading():Boolean
		{
			return vs::loading as Boolean;
		}
		
		
		/**
		 * 
		 * FTP密码。
		 * 
		 */
		
		public function get passWord():String
		{
			return request ? request.passWord : null;
		}
		
		
		/**
		 * 
		 * FTP端口。
		 * 
		 */
		
		public function get port():uint
		{
			return request ? request.port : 0;
		}
		
		
		/**
		 * 
		 * 存储路径，如是上传模式则为需要上传的文件路径。
		 * 
		 */
		
		public function get localURL():String
		{
			return request ? request.localURL : null;
		}
		
		
		/**
		 * 
		 * 下载路径，若是上传模式则为上传路径。
		 * 
		 */
		
		public function get remoteURL():String
		{
			return request ? request.remoteURL : null;
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
		 * 
		 * FTP用户名。
		 * 
		 */
		
		public function get userName():String
		{
			return request ? request.userName : null;
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
			if ($value != vs::timeout) vs::timeout = $value;
		}
		
		
		/**
		 * 
		 * 定义丢包时重复加载次数。
		 * 
		 */
		
		public var maxReload:uint = 2;
		
		
		/**
		 * @private
		 */
		private static const FILES:Object = {};
		
		
		/**
		 * @private
		 */
		private var time:int;
		
		/**
		 * @private
		 */
		private var avoid:Boolean;
		
		/**
		 * @private
		 */
		private var data:String;
		
		/**
		 * @private
		 */
		private var cmd:String;
		
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
		private var ctrlSocket:Socket;
		
		/**
		 * @private
		 */
		private var dataSocket:Socket;
		
		/**
		 * @private
		 */
		private var dataHost:String;
		
		/**
		 * @private
		 */
		private var dataPort:uint;
		
		/**
		 * @private
		 */
		private var request:FTPRequest;
		
		/**
		 * @private
		 */
		private var stream:FileStream;
		
		/**
		 * @private
		 */
		private var count:uint;
		
		/**
		 * @private
		 */
		private var moving:Boolean;
		
		/**
		 * @private
		 */
		private var reloadCount:uint;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var timerHandler:Function;
		
		/**
		 * @private
		 */
		private var passiveCount:uint;
		
		
		/**
		 * @private
		 */
		vs var bytesLoaded:Number = 0;
		
		/**
		 * @private
		 */
		vs var bytesTotal:Number = 0;
		
		/**
		 * @private
		 */
		vs var code:String;
		
		/**
		 * @private
		 */
		vs var fileName:String;
		
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