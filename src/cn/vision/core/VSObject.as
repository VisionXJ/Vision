package cn.vision.core
{
	
	/**
	 * 
	 * vison 数据的基类。
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
	
	
	public dynamic class VSObject implements IID, IName
	{
		
		/**
		 * 
		 * <code>VSObject</code>构造函数。
		 * 
		 */
		
		public function VSObject()
		{
			super();
			
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