package cn.vision.net
{
	
	/**
	 * 
	 * FTP文件上传工具，支持断点续传。<br>
	 * AIR Only
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
	import cn.vision.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	
	import spark.skins.spark.windowChrome.RestoreButtonSkin;
	
	
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
	
	
	public class FTPUploader extends VSEventDispatcher implements ITimeout
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $request:FTPRequest (defalut = null) 需要加载的FTP请求。
		 * 
		 * @see cn.vision.net.FTPRequest
		 * 
		 */
		
		public function FTPUploader($request:FTPRequest = null)
		{
			super();
			
			resolveRequest($request);
		}
		
		
		/**
		 * 
		 * 停止FTP上传。
		 * 
		 */
		
		public function close():void
		{
			if (vs::uploading)
			{
				vs::uploading = false;
				streamClose();
				socketCtrlRemove();
				socketDataRemove();
				removeTimer();
				file = null;
			}
		}
		
		
		/**
		 * 
		 * 开始FTP上传。
		 * 
		 * @param $request:FTPRequest (default = null) 需要加载的FTP请求。
		 * 
		 * @see cn.vision.net.FTPRequest
		 * 
		 */
		
		public function upload($request:FTPRequest = null):void
		{
			if (resolveRequest($request))
			{
				vs::uploading = true;
				vs::fileName = request.localURL.split(File.separator).pop();
				
				file = new VSFile(localURL);
				try
				{
					if (file.exists)
					{
						streamOpen();
						socketCtrlCreate();
						
						ctrlSocket.connect(host, port);
						createTimer(timeout, handlerCtrlConnectTimeout);
					}
					else
					{
						close();
						dispatchEvent(new IOErrorEvent(
							IOErrorEvent.IO_ERROR,
							false, false, "需要上传的文件不存在！", 2035));
					}
				}
				catch(e:Error) 
				{ 
					close();
					dispatchEvent(new IOErrorEvent(
						IOErrorEvent.IO_ERROR,
						false, false, "文件正在使用中！", 2035));
				}
			}
			else throw new FTPRequestError;
		}
		
		
		/**
		 * @private
		 */
		private function resolveRequest($request:FTPRequest):Boolean
		{
			close();
			
			if (request || $request)
			{
				var result:Boolean =  ! ($request && (!request || 
					request.host      != $request.host || 
					request.port      != $request.port || 
					request.userName  != $request.userName || 
					request.passWord  != $request.passWord || 
					request.remoteURL != $request.remoteURL || 
					request.localURL  != $request.localURL));
				if(!result)
				{
					request = $request;					
					result  = request.available;
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function socketCtrlCreate():void
		{
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
			if (ctrlSocket)
			{
				if (ctrlSocket.connected)
				{
					ctrlSocket.writeMultiByte("QUIT\r\n", "utf8");
					ctrlSocket.flush();
					ctrlSocket.close();
				}
				ctrlSocket.removeEventListener(Event.CLOSE, handlerCtrlClose);
				ctrlSocket.removeEventListener(IOErrorEvent.IO_ERROR, handlerCtrlDefault);
				ctrlSocket.removeEventListener(ProgressEvent.SOCKET_DATA, handlerCtrlProgress);
				ctrlSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerCtrlDefault);
				ctrlSocket = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function socketDataCreate():void
		{
			if(!dataSocket) dataSocket = new Socket;
		}
		
		/**
		 * @private
		 */
		private function socketDataRemove():void
		{
			if (dataSocket)
			{
				if (dataSocket.connected) dataSocket.close();
				dataSocket = null;
			}
		}
		
		/**
		 * @private
		 */
		private function streamOpen():void
		{
			if(!stream)
			{
				stream = new FileStream;
				stream.open(file, FileMode.READ);
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
		private function createTimer($delay:Number, $handler:Function):void
		{
			removeTimer();
			timerHandler = $handler;
			if(!timer && $delay)
			{
				timer = new Timer($delay * 1000);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
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
		private function removeTimer():void
		{
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer = null;
			}
		}
		
		/**
		 * @private
		 */
		private function execute($code:String):void
		{
			this[$code]();
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
			ctrlSocket.writeMultiByte("TYPE I\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 进入被动模式。
		 * @private
		 */
		private function command200():void
		{
			resetTimer();
			ctrlSocket.writeMultiByte("DELE " + remoteURL + "\r\n", "utf8");
			ctrlSocket.writeMultiByte("PASV\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 获取数据传输层的IP与端口。
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
			
			socketDataCreate();
			dataSocket.connect(dataHost, dataPort);
			
			ctrlSocket.writeMultiByte("STOR " + remoteURL + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * 上传数据。
		 * @private
		 */
		private function command150():void
		{
			removeTimer();
			var bytes:ByteArray = new ByteArray;
			stream.readBytes(bytes);
			dataSocket.writeBytes(bytes);
			dataSocket.flush();
			dataSocket.close();
		}
		
		
		
		/**
		 * 
		 * Linux系统下的上传数据。
		 * 
		 */
		
		private function command257():void
		{
			if (data.indexOf("successfully") == -1)
			{
				dispatchEvent(new Event(Event.CANCEL));
			}
		}
		
		
		/**
		 * 完毕处理。
		 * @private
		 */
		private function command226():void
		{
			close();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 用户名或密码不正确。
		 * @private
		 */
		private function command530():void
		{
			if (data.indexOf("Please login with USER and PASS")!= -1)
			{
				ctrlSocket.writeMultiByte("USER " + userName + "\r\n", "utf8");
				ctrlSocket.flush();
			}
			else
			{
				close();
				dispatchEvent(new IOErrorEvent(
					IOErrorEvent.IO_ERROR,
					false, false, data.substr(4), 2035));
			}
		}
		
		/**
		 * 不能创建文件。
		 * @private
		 */
		private function command553():void
		{
			//Linux下的处理。
			if (data.indexOf("Could not create file") != -1)
			{
//				解析上传文件夹的路径。
				var tempURL:String = remoteURL.indexOf("\\") == -1 
					? remoteURL : remoteURL.replace(/\\/g, '/');
				tempURL = tempURL.slice(0, tempURL.lastIndexOf("/"));
				ctrlSocket.writeMultiByte("MKD " + tempURL + "\r\n", "utf8");
				ctrlSocket.flush();
			}
			else
			{
				close();
				dispatchEvent(new IOErrorEvent(
					IOErrorEvent.IO_ERROR, 
					false, false, data, 2036));
			}
		}
		
		/**
		 * 
		 * 未找到定义的文件夹。
		 * @private
		 * 
		 */
		private function command550():void
		{
			resetTimer();
			
			if (data.split(" ")[1] == "Delete") return;
			
			//解析上传文件夹的路径。
			var tempURL:String = remoteURL.indexOf("\\") == -1 
				? remoteURL : remoteURL.replace(/\\/g, '/');
			tempURL = tempURL.slice(0, tempURL.lastIndexOf("/"));
			ctrlSocket.writeMultiByte("MKD " + tempURL + "\r\n", "utf8");
			ctrlSocket.flush();
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlDefault($e:Event):void
		{
			close();
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlClose($e:Event):void
		{
			if (uploading) ctrlSocket.connect(host, port);
			else close();
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlProgress($e:ProgressEvent):void
		{
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
				trace(data);
				var cmd:String = data.substr(0, 3);
				if(!StringUtil.isEmpty(cmd))
					DebugUtil.execute(execute, false, "command" + cmd);
			}
		}
		
		/**
		 * @private
		 */
		private function handlerCtrlConnectTimeout($e:TimerEvent):void
		{
			close();
			dispatchEvent(new IOErrorEvent(
				IOErrorEvent.IO_ERROR, 
				false, false, "连接FTP服务器超时！", 2036));
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
		 * 需要上传的文件路径。
		 * 
		 */
		
		public function get localURL():String
		{
			return request ? request.localURL : null;
		}
		
		
		/**
		 * 
		 * 上传路径。
		 * 
		 */
		
		public function get remoteURL():String
		{
			return request ? request.remoteURL : null;
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
		 * 
		 * 是否在加载状态。
		 * 
		 */
		
		public function get uploading():Boolean
		{
			return Boolean(vs::uploading);
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
		vs var fileName:String;
		
		/**
		 * @private
		 */
		vs var uploading:Boolean;
		
		/**
		 * @private
		 */
		vs var timeout:uint;
		
		
	}
}