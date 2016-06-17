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
			if (resolveRequest($request))
			{
				vs::loading = true;
				vs::bytesLoaded = vs::bytesTotal = 0;
				vs::speed = 0;
				vs::fileName = request.localURL.split("\\").pop();
				
				LogUtil.log("FTPLoader.load()", fileName);
				
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
					socketCtrlCreate();
					deleteTemp();
					
					ctrlSocket.connect(host, port);
					createTimer(timeout, handlerCtrlConnectTimeout);
				}
			}
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
		private function resolveRequest($request:FTPRequest):Boolean
		{
			if (request || $request)
			{
				//检测新的请求与现有的请求是否相同
				var same:Boolean =  ! ($request && (!request || 
					request.host      != $request.host || 
					request.port      != $request.port || 
					request.userName  != $request.userName  || 
					request.passWord  != $request.passWord  || 
					request.remoteURL != $request.remoteURL || 
					request.localURL  != $request.localURL));
				//不同时，则把新的请求赋值给现有请求
				if(!same)
				{
					closeInternal(false);
					request = $request;
				}
				var result:Boolean = request && request.available;
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function createTimer($delay:Number, $handler:Function):void
		{
			removeTimer();
			if(!timer && $delay)
			{
				timerHandler = $handler;
				timer = new Timer($delay * 1000);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
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
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer = null;
				timerHandler = null;
			}
		}
		
		/**
		 * @private
		 */
		private function resetTimer():void
		{
			if (timeout)
			{
				count = 0;
				if (timer)
				{
					timer.reset();
					timer.start();
				}
			}
		}
		
		/**
		 * @private
		 */
		private function streamOpen():void
		{
			if(!stream && temp)
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
		private function socketCtrlCreate():void
		{
			LogUtil.log("FTPLoader.socketCtrlCreate()", fileName);
			if(!ctrlSocket)
			{
				ctrlSocket = new Socket;
				ctrlSocket.addEventListener(Event.CLOSE, handlerCtrlClose);
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
			LogUtil.log("FTPLoader.socketCtrlRemove()", fileName);
			if (ctrlSocket)
			{
				ctrlSocket.removeEventListener(Event.CLOSE, handlerCtrlClose);
				ctrlSocket.removeEventListener(IOErrorEvent.IO_ERROR, handlerCtrlDefault);
				ctrlSocket.removeEventListener(ProgressEvent.SOCKET_DATA, handlerCtrlProgress);
				ctrlSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerCtrlDefault);
				DebugUtil.execute(ctrlSocket.close, true);
				ctrlSocket = null;
			}
		}
		
		/**
		 * @private
		 */
		private function socketDataCreate():void
		{
			LogUtil.log("FTPLoader.socketDataCreate()", fileName);
			if(!dataSocket)
			{
				dataSocket = new Socket;
				dataSocket.addEventListener(Event.CLOSE, handlerDataClose);
				dataSocket.addEventListener(Event.CONNECT, handlerDataConnect);
				dataSocket.addEventListener(IOErrorEvent.IO_ERROR, handlerDataIOError);
				dataSocket.addEventListener(ProgressEvent.SOCKET_DATA, handlerDataProgress);
				dataSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDataDefault);
			}
		}
		
		/**
		 * @private
		 */
		private function socketDataRemove():void
		{
			LogUtil.log("FTPLoader.socketDataRemove()", fileName);
			if (dataSocket)
			{
				dataSocket.removeEventListener(Event.CLOSE, handlerDataClose);
				dataSocket.removeEventListener(Event.CONNECT, handlerDataConnect);
				dataSocket.removeEventListener(IOErrorEvent.IO_ERROR, handlerDataIOError);
				dataSocket.removeEventListener(ProgressEvent.SOCKET_DATA, handlerDataProgress);
				dataSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerDataDefault);
				DebugUtil.execute(dataSocket.close, false);
				dataSocket = null;
			}
		}
		
		/**
		 * @private
		 */
		private function moveFileCreate():void
		{
			if (temp)
			{
				temp.addEventListener(Event.COMPLETE, handlerMoveDefault);
				temp.addEventListener(IOErrorEvent.IO_ERROR, handlerMoveDefault);
			}
		}
		
		/**
		 * @private
		 */
		private function moveFileRemove():void
		{
			if (temp)
			{
				temp.removeEventListener(Event.COMPLETE, handlerMoveDefault);
				temp.removeEventListener(IOErrorEvent.IO_ERROR, handlerMoveDefault);
			}
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
		}
		
		/**
		 * @private
		 */
		private function moveFile():void
		{
			LogUtil.log("FTPLoader.moveFile()", fileName);
			if(!moving && bytesTotal && 
				file &&!file.exists && 
				temp && temp.exists && 
				temp.size == bytesTotal)
			{
				//如果不先取消temp的其他操作，文件移动过程中会出现导致软件卡死的现象。
				LogUtil.log(fileName, "move start");
				moving = true;
				count = 0;
				socketCtrlRemove();
				socketDataRemove();
				streamClose();
				moveFileCreate();
				createTimer(1, handlerMoveDefault);
				temp.moveToAsync(file, true);
			}
		}
		
		/**
		 * @private
		 */
		private function deleteTemp():void
		{
			if (temp && temp.exists) 
			{
				temp.deleteFile();
			}
		}
		
		/**
		 * 有时文件传输完毕后dataSocket不会立刻关闭，此时移动临时文件至正式文件会出现卡死的情况，此处做一个延迟移动。
		 * @private
		 */
		private function closeInternal($complete:Boolean = true):void
		{
			LogUtil.log("FTPLoader.closeInternal()", fileName);
			if (vs::loading)
			{
				vs::loading = moving = false;
				socketDataRemove();
				socketCtrlRemove();
				removeTimer();
				streamClose();
				moveFileRemove();
				file = temp = null;
			}
			if ($complete) dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @private
		 */
		private function execute($code:String):void
		{
			if (this[$code] is Function) this[$code]();
		}
		
		
		/**
		 * 登陆。
		 * @private
		 */
		private function command220():void
		{
			if(!avoid)
			{
				resetTimer();
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
			resetTimer();
			ctrlSocket.writeMultiByte("PASS " + passWord + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 进入被动模式。
		 * @private
		 */
		private function command230():void
		{
			resetTimer();
			avoid = false;
			ctrlSocket.writeMultiByte("PASV\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 设定数据传输socket的IP与端口，并获取文件大小。
		 * @private
		 */
		private function command227():void
		{
			resetTimer();
			var sa:int = data.indexOf("227");
			var st:int = data.indexOf("(", sa);
			var en:int = data.indexOf(")", sa);
			var a2:Array = data.substring(st + 1, en).split(",");
			var p1:int = a2.pop();
			var p2:int = a2.pop();
			dataHost = a2.join(".");
			dataPort = (p2 * 256) + p1;
			ctrlSocket.writeMultiByte("SIZE " + remoteURL + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 传输完毕处理。
		 * @private
		 */
		private function command226():void
		{
			LogUtil.log("FTPLoader.command226()", fileName);
			createTimer(.1, handlerDataCompleteTimer);
		}
		
		/**
		 * 下载。
		 * @private
		 */
		private function command213():void
		{
			LogUtil.log("FTPLoader.command213()", fileName);
			if(!bytesTotal) vs::bytesTotal = Number(data.substr(4));
			socketDataCreate();
			dataSocket.connect(dataHost, dataPort);
			createTimer(timeout, handlerDataConnectTimeout);
		}
		
		/**
		 * 用户名或密码错误。
		 * @private
		 */
		private function command421():void
		{
			LogUtil.log("FTPLoader.command421()", fileName);
			closeInternal(false);
			dispatchEvent(new SecurityErrorEvent(
				SecurityErrorEvent.SECURITY_ERROR, 
				false, false, data.substr(4), 2124));
		}
		
		/**
		 * FTP上文件不存在。
		 * @private
		 */
		private function command530():void
		{
			LogUtil.log("FTPLoader.command530()", fileName);
			closeInternal(false);
			dispatchEvent(new IOErrorEvent(
				IOErrorEvent.IO_ERROR,
				false, false, data.substr(4), 2035));
		}
		
		/**
		 * 文件不存在。
		 * @private
		 */
		private function command550():void
		{
			LogUtil.log("FTPLoader.command550()", fileName);
			var bool:Boolean = data.indexOf("No support for resume of ASCII transfer") != -1;
			if (bool)
			{
				socketDataRemove();
				streamClose();
				deleteTemp();
				streamOpen();
				vs::bytesLoaded = 0;
				command213();
			}
			else
			{
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
			LogUtil.log("FTPLoader.handlerCtrlDefault()", fileName);
			closeInternal(false);
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlClose($e:Event):void
		{
			LogUtil.log("FTPLoader.handlerCtrlClose()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				if (bytesTotal > 0)
				{
					ctrlSocket.connect(host, port);
				}
				else
				{
					closeInternal(false);
					dispatchEvent(new Event(Event.CLOSE));
				}
			}
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlConnectTimeout($e:TimerEvent):void
		{
			LogUtil.log("FTPLoader.handlerCtrlConnectTimeout()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				closeInternal(false);
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, 
					false, false, "连接FTP服务器控制层超时！", 2036));
			}
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlProgress($e:ProgressEvent):void
		{
			LogUtil.log("FTPLoader.handlerCtrlProgress()", fileName);
			var temp:String = ctrlSocket.readUTFBytes(ctrlSocket.bytesAvailable);
			var list:Array = temp.split("\n");
			var filter:Function = function($item:*, $index:int, $array:Array):Boolean
			{
				return !StringUtil.isEmpty($item.substr(0, 3));
			};
			list = list.filter(filter, null);
			while (list.length)
			{
				data = list.shift();
				LogUtil.log(fileName, data);
				var cmd:String = data.substr(0, 3);
				if(!StringUtil.isEmpty(cmd))
					DebugUtil.execute(execute, false, "command" + cmd);
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataDefault($e:Event):void
		{
			LogUtil.log("FTPLoader.handlerDataDefault()", fileName);
			closeInternal(false);
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerDataClose($e:Event):void
		{
			LogUtil.log("FTPLoader.handlerDataClose()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				dataSocket.connect(dataHost, dataPort);
				resetTimer();
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataCompleteTimer($e:TimerEvent):void
		{
			LogUtil.log("FTPLoader.handlerDataCompleteTimer()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				socketDataRemove();
				streamClose();
				deleteTemp();
				streamOpen();
				vs::bytesLoaded = 0;
				command213();
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataConnect($e:Event):void
		{
			LogUtil.log("FTPLoader.handlerDataConnect()", fileName);
			streamOpen();
			requestFile();
			createTimer(timeout, handlerDataProgressTimeout);
		}
		
		/**
		 * @private
		 */
		private function handlerDataConnectTimeout($e:TimerEvent = null):void
		{
			LogUtil.log("FTPLoader.handlerDataConnectTimeout()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				closeInternal(false);
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, 
					false, false, "连接FTP服务器数据层超时！", 2036));
			}
		}
		
		/**
		 * @private
		 */
		private function handlerDataProgress($e:ProgressEvent):void
		{
			resetTimer();
			var bytes:ByteArray = new ByteArray;
			dataSocket.readBytes(bytes, 0, dataSocket.bytesAvailable);
			stream.writeBytes(bytes, 0, bytes.bytesAvailable);
			vs::bytesLoaded = temp.size;
			vs::speed = bytesLoaded / (getTimer() - time);
			dispatchEvent(new ProgressEvent(
				ProgressEvent.PROGRESS, 
				false, false, bytesLoaded, bytesTotal));
		}
		
		/**
		 * @private
		 */
		private function handlerDataProgressTimeout($e:TimerEvent):void
		{
			LogUtil.log("FTPLoader.handlerDataProgressTimeout()", fileName);
			if (++count < 2)
			{
				resetTimer();
				if (dataSocket.connected) dataSocket.close();
				dataSocket.connect(dataHost, dataPort);
			}
			else handlerDataConnectTimeout();
		}
		
		/**
		 * @private
		 */
		private function handlerDataIOError($e:IOErrorEvent):void
		{
			LogUtil.log("FTPLoader.handlerDataIOError()", fileName);
			if (loaded)
			{
				removeTimer();
				moveFile();
			}
			else
			{
				if(++count > 1)
				{
					closeInternal(false);
					dispatchEvent($e.clone());
				}
				else
				{
					command213();
				}
			}
		}
		
		/**
		 * @private
		 */
		private function handlerMoveDefault($e:Event):void
		{
			LogUtil.log(fileName, "move end");
			if ($e.type == Event.COMPLETE)
			{
				closeInternal();
			}
			else
			{
				resetTimer();
				if (++count < 2)
				{
					temp.cancel();
					temp.moveToAsync(file, true);
				}
				else
				{
					closeInternal(false);
					dispatchEvent(
						$e.type == IOErrorEvent.IO_ERROR
							? $e.clone()
							: new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "移动文件超时！", 2037)
					);
				}
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
		 * 文件是否已下载完毕。
		 * 
		 */
		
		public function get loaded():Boolean
		{
			var result:Boolean = file && file.exists;
			if(!result)
			{
				if (bytesTotal && temp.exists) 
					result = (temp.size == bytesTotal);
			}
			return result;
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
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var timerHandler:Function;
		
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
		vs var bytesLoaded:Number = 0;
		
		/**
		 * @private
		 */
		vs var bytesTotal:Number = 0;
		
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