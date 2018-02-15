package cn.vision.core
{
	
	import cn.vision.interfaces.IDestroy;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	import flash.events.Event;
	
	
	/**
	 * vision事件基类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	public class VSEvent extends Event implements IID, IName, IDestroy
	{
		
		/**
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
			vs::vid = IDUtil.generateID();
		}
		
		
		/**
		 * 复制 VSEvent 类的实例。返回一个新的 VSEvent 对象，它是 VSEvent 对象的原始实例的副本。
		 * 通常您不需要调用 clone()；当您重新调度事件，即调用 dispatchEvent(event)（从正在处理 event 的处理函数）时，EventDispatcher 类会自动调用它。
		 * 新的 Event 对象包括原始对象的所有属性。<br><br>
		 * 当您创建自己的自定义 VSEvent 类时，必须覆盖继承的 VSEvent.clone() 方法，以复制自定义类的属性。
		 * 如果您未设置在事件子类中添加的所有属性，则当侦听器处理重新调度的事件时，这些属性将不会有正确的值。
		 * 
		 */
		
		override public function clone():Event
		{
			return new VSEvent(type, bubbles, cancelable);
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
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get instanceName():String
		{
			return vs::name;
		}
		
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