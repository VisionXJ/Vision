package cn.vision.errors
{
	
	/**
	 * 
	 * VSError是所有vison错误的基类。
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
	import cn.vision.managers.ErrorManager;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	import cn.vision.utils.StringUtil;
	
	
	public class VSError extends Error implements IID, IName
	{
		
		/**
		 * 
		 * <code>VSError</code>构造函数。
		 * 
		 * @param $message:String (default = "") 出错信息。
		 * 
		 */
		
		public function VSError($message:String = "")
		{
			super(message, ErrorManager.registError(ClassUtil.getClass(this)));
			
			initialize();
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize():void
		{
			vs::className = ClassUtil.getClassName(this);
			vs::vid = IDUtil.generateID();
			name = StringUtil.lowercaseInitials(className);
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
		vs var instanceName:String;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
	}
}