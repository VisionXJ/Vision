package cn.vision.core
{
	
	/**
	 * 
	 * 可视元素的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.vs;
	import cn.vision.interfaces.*;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	
	import flash.display.Sprite;
	
	
	public class UI extends Sprite implements IEnable, IExtra, IID, IName
	{
		
		public function UI()
		{
			super();
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			vs::enabled = true;
			vs::vid = IDUtil.generateID();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className || (vs::className = ClassUtil.getClassName(this));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get extra():Object
		{
			return vs::extra || (vs::extra = {});
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get enabled():Boolean
		{
			return Boolean(vs::enabled);
		}
		
		/**
		 * @private
		 */
		public function set enabled($value:Boolean):void
		{
			vs::enabled = $value;
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
			return vs::instanceName;
		}
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::instanceName = $value;
		}
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var enabled:Boolean;
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
		/**
		 * @private
		 */
		vs var instanceName:String;
		
	}
}
