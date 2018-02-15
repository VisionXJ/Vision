package cn.vision.interfaces
{
	
	import cn.vision.core.Model;
	
	
	/**
	 * 视图接口。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public interface IView
	{
		
		/**
		 * @copy cn.vision.managers.ModelManager#registModel()
		 */
		function registModel($name:String, $model:Model):Boolean;
		
		
		/**
		 * @copy cn.vision.managers.ModelManager#removeModel()
		 */
		function removeModel($name:String):Boolean;
		
		
		/**
		 * @copy cn.vision.managers.ModelManager#retrieveModel()
		 */
		function retrieveModel($name:String):Model;
		
	}
}