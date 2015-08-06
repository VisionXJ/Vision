package cn.vision.core
{
	
	/**
	 * 
	 * vision事件基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	import flash.events.Event;
	
	
	public class VSEvent extends Event implements IID, IName
	{
		
		/**
		 * 
		 * <code>VSEvent</code>构造函数。
		 * 
		 * @param $type:String 事件的类型，可以作为 CommandEvent.type 访问。
		 * @param $bubbles:Boolean (default = false) 确定 CommandEvent 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param $cancelable:Boolean (default = false) 确定是否可以取消 CommandEvent 对象。默认值为 false。
		 * 
		 */
		
		public function VSEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			vs::className = ClassUtil.getClassName(this);
			vs::vid = IDUtil.generateID();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className;
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