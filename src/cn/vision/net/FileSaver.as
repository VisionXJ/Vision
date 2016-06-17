package cn.vision.net
{
	
	/**
	 * 
	 * 文件存储器，本地存储文件资源。<br>
	 * AIR Only。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.errors.FileRequestError;
	import cn.vision.system.VSFile;
	import cn.vision.utils.DebugUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * 关闭存储时调度。
	 * 
	 */
	
	[Event(name="close", type="flash.events.Event")]
	
	
	/**
	 * 
	 * 完成存储时调度。
	 * 
	 */
	
	[Event(name="complete", type="flash.events.Event")]
	
	
	/**
	 * 
	 * 写入出错时调度。
	 * 
	 */
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * 
	 * 写入过程中写入进度发生改变时调度。
	 * 
	 */
	
	[Event(name="outputProgress", type="flash.events.OutputProgressEvent")]
	
	
	/**
	 * 
	 * 写入发生安全策略错误时触发。
	 * 
	 */
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	public final class FileSaver extends VSEventDispatcher
	{
		
		/**
		 * 
		 * <code>FileSaver</code>构造函数。
		 * 
		 * @param $request:FileRequest (defalut = null) 写入的请求。
		 * 
		 */
		
		public function FileSaver($request:FileRequest = null)
		{
			super();
			
			resolveRequest($request);
		}
		
		
		/**
		 * 
		 * 开始向存储文件，或者恢复上一次写入。
		 * 
		 * @param $request:FileRequest (default = null) 需要写入的请求。
		 * 
		 */
		
		public function save($request:FileRequest):void
		{
			if (resolveRequest($request))
			{
				vs::saving = true;
				count = 0;
				temp = temp || new VSFile(saveURL + ".tmp");
				file = file || new VSFile(saveURL);
				vs::bytesTotal = data.length;
				if (temp.exists)
				{
					vs::bytesPending = bytesTotal - temp.size;
					bytesPending == 0 ? move() : open();
				}
				else
				{
					if (file.exists)
						file.deleteFile();
					else
						vs::bytesPending = bytesTotal;
					open();
				}
			}
			else throw new FileRequestError;
		}
		
		
		/**
		 * 
		 * 停止写入过程。
		 * 
		 */
		
		public function close():void
		{
			if (vs::saving)
			{
				vs::saving = false;
				
				back();
				removeOpenListener();
				removeWriteListener();
				removeMoveListener();
				vs::bytesPending = vs::bytesTotal = 0;
				temp = file = null;
				request = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function open():void
		{
			createOpenListener();
			stream.openAsync(temp, FileMode.UPDATE);
		}
		
		/**
		 * @private
		 */
		private function write():void
		{
			createWriteListener();
			stream.writeBytes(data, stream.position);
		}
		
		/**
		 * @private
		 */
		private function move():void
		{
			createMoveListener();
			temp.moveToAsync(file, true);
		}
		
		/**
		 * @private
		 */
		private function back():void
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
		private function resolveRequest($request:FileRequest):Boolean
		{
			if (request || $request)
			{
				var result:Boolean = ! ($request && (! request || 
					request.saveURL  != $request.saveURL || 
					request.data     != $request.data));
				if(!result)
				{
					//存储的文件数据发生了变更。
					if (request && request.data != $request.data)
						DebugUtil.execute(temp.deleteFileAsync);
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
		private function createOpenListener():void
		{
			if(!opened)
			{
				opened = true;
				stream = new FileStream;
				stream.addEventListener(Event.COMPLETE, handlerOpenComplete);
				stream.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
				stream.addEventListener(ProgressEvent.PROGRESS, handlerOpenProgress);
			}
		}
		
		/**
		 * @private
		 */
		private function removeOpenListener():void
		{
			if (opened)
			{
				opened = false;
				if (stream)
				{
					stream.removeEventListener(Event.COMPLETE, handlerOpenComplete);
					stream.removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
					stream.removeEventListener(ProgressEvent.PROGRESS, handlerOpenProgress);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function createWriteListener():void
		{
			if(!writed)
			{
				writed = true;
				stream.addEventListener(Event.CLOSE, handlerDefault);
				stream.addEventListener(Event.COMPLETE, handlerWriteComplete);
				stream.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
				stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, handlerWriteProgress);
			}
		}
		
		/**
		 * @private
		 */
		private function removeWriteListener():void
		{
			if (writed)
			{
				writed = false;
				stream.removeEventListener(Event.CLOSE, handlerDefault);
				stream.removeEventListener(Event.COMPLETE, handlerWriteComplete);
				stream.removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
				stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, handlerWriteProgress);
			}
		}
		
		/**
		 * @private
		 */
		private function createMoveListener():void
		{
			if(!moved)
			{
				moved = true;
				temp.addEventListener(Event.CANCEL, handlerCancel);
				temp.addEventListener(Event.COMPLETE, handlerMoveComplete);
				temp.addEventListener(IOErrorEvent.IO_ERROR, handlerMoveIOError);
				temp.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerMoveSecurityError);
			}
		}
		
		/**
		 * @private
		 */
		private function removeMoveListener():void
		{
			if (moved)
			{
				moved = false;
				temp.removeEventListener(Event.CANCEL, handlerCancel);
				temp.removeEventListener(Event.COMPLETE, handlerMoveComplete);
				temp.removeEventListener(IOErrorEvent.IO_ERROR, handlerMoveIOError);
				temp.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlerMoveSecurityError);
			}
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
		private function handlerOpenComplete($e:Event):void
		{
			stream.position = stream.bytesAvailable;
			var movable:Boolean = (data.length - stream.position) <= 0;
			removeOpenListener();
			if (movable) 
			{
				back();
				move();
			}
			else
			{
				write();
			}
		}
		
		/**
		 * @private
		 */
		private function handlerOpenProgress($e:ProgressEvent):void
		{
			vs::bytesPending = vs::bytesTotal * 
				(1 - .1 * $e.bytesLoaded / $e.bytesTotal);
			dispatchEvent(new OutputProgressEvent(
				OutputProgressEvent.OUTPUT_PROGRESS, 
				false, false, bytesPending, bytesTotal));
		}
		
		/**
		 * @private
		 */
		private function handlerWriteComplete($e:Event):void
		{
			removeWriteListener();
			back();
			move();
		}
		
		/**
		 * @private
		 */
		private function handlerWriteProgress($e:OutputProgressEvent):void
		{
			vs::bytesPending = vs::bytesTotal * (.9 - .8 * 
				($e.bytesTotal - $e.bytesPending) / $e.bytesTotal);
			dispatchEvent(new OutputProgressEvent(
				OutputProgressEvent.OUTPUT_PROGRESS, 
				false, false, bytesPending, bytesTotal));
		}
		
		/**
		 * @private
		 */
		private function handlerCancel($e:Event):void
		{
			close();
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * @private
		 */
		private function handlerMoveComplete($e:Event):void
		{
			close();
			dispatchEvent($e.clone());
		}
		
		/**
		 * @private
		 */
		private function handlerMoveIOError($e:IOErrorEvent):void
		{
			if (++count < 3)
			{
				back();
				move();
			}
			else
			{
				close();
				dispatchEvent($e.clone());
			}
		}
		
		/**
		 * @private
		 */
		private function handlerMoveSecurityError($e:SecurityErrorEvent):void
		{
			close();
			dispatchEvent($e.clone());
		}
		
		
		/**
		 * 
		 * 存储的数据。
		 * 
		 */
		
		public function get data():ByteArray
		{
			return request ? request.data : null;
		}
		
		
		/**
		 * 
		 * 还需要写入的字节数。
		 * 
		 */
		
		public function get bytesPending():Number
		{
			return vs::bytesPending;
		}
		
		
		/**
		 * 
		 * 总字节数。
		 * 
		 */
		
		public function get bytesTotal():Number
		{
			return vs::bytesTotal;
		}
		
		
		/**
		 * 
		 * 是否在写入状态。
		 * 
		 */
		
		public function get saving():Boolean
		{
			return Boolean(vs::saving);
		}
		
		
		/**
		 * 
		 * 存储路径。
		 * 
		 */
		
		public function get saveURL():String
		{
			return request ? request.saveURL : null;
		}
		
		
		/**
		 * @private
		 */
		private var opened:Boolean;
		
		/**
		 * @private
		 */
		private var writed:Boolean;
		
		/**
		 * @private
		 */
		private var moved:Boolean;
		
		/**
		 * @private
		 */
		private var count:uint;
		
		/**
		 * @private
		 */
		private var request:FileRequest;
		
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
		vs var saving:Boolean;
		
		/**
		 * @private
		 */
		vs var bytesPending:Number;
		
		/**
		 * @private
		 */
		vs var bytesTotal:Number;
		
	}
}