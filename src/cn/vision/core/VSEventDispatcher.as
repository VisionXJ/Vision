package cn.vision.core
{
	
	import cn.vision.interfaces.IDestroy;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * 所有发送事件发送器的基类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class VSEventDispatcher extends EventDispatcher implements IID, IName, IDestroy
	{
		
		/**
		 * 构造函数。
		 * 
		 * @param $target:IEventDispatcher (default = null) 指定发送事件的源对象，null则代表本身。
		 * 
		 */
		public function VSEventDispatcher($target:IEventDispatcher = null)
		{
			super($target);
			
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
		public function destroy():void { }
		
		
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
		 * @inheritDoc
		 */
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
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