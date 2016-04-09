package cn.vision.system
{
	
	/**
	 * 
	 * 继承是为了屏蔽文件不存在时的所抛出的IOErrorEvent。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	
	public class VSFile extends File implements IID, IName
	{
		
		/**
		 * 
		 * <code>VSFile</code>构造函数。
		 * 
		 * @param $path:String 如果传递 path 参数，File 对象将指向指定的路径，
		 * 并将设置 nativePath 属性和 url 属性以反映该路径。
		 * 
		 */
		
		public function VSFile($path:String = null)
		{
			//addEventListener(IOErrorEvent.IO_ERROR, handlerIOError, true, 0, true);
			
			super($path);
			
			initialize($path);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($path:String):void
		{
			vs::vid = IDUtil.generateID();
			
			if ($path && exists) 
			{
				//removeEventListener(IOErrorEvent.IO_ERROR, handlerIOError, true);
				
				canonicalize();
			}
		}
		
		
		/**
		 * @private
		 */
		/*private function handlerIOError($e:IOErrorEvent):void
		{
			removeEventListener(IOErrorEvent.IO_ERROR, handlerIOError, true);
		}*/
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className = (vs::className || ClassUtil.getClassName(this));
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
		
		public function get instanceName():String { return vs::name; }
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::name = $value;
		}
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var name:String;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
	}
}