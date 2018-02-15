package cn.vision.managers
{
	import cn.vision.collections.Holder;
	import cn.vision.core.Model;
	import cn.vision.errors.ArgumentNotNullError;
	
	
	/**
	 * 业务逻辑模型类管理器。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ModelManager extends Manager
	{
		
		/**
		 * 注册一个Model实例。
		 * 
		 * @param $name:String 名称索引。
		 * @param $model:Model 要注册的Model。
		 * 
		 * @return Boolean 是否注册成功。
		 * 
		 */
		public static function registModel($name:String, $model:Model):Boolean
		{
			var result:Boolean = $name != null && $model != null;
			if (result) MODELS.registData($name, $model);
			else throw new ArgumentNotNullError("$name", "$model");
			return result;
		}
		
		
		/**
		 * 根据注册的名称索引删除已注册的Model实例。
		 * 
		 * @param $name:String 名称索引。
		 * 
		 * @return Boolean 是否移除成功。
		 * 
		 */
		public static function removeModel($name:String):Boolean
		{
			return MODELS.removeData($name);
		}
		
		
		/**
		 * 根据注册的名称索引获取Model实例。
		 * 
		 * @param $name:String Model名称索引。
		 * 
		 * @return Model 获取到的Model实例。
		 * 
		 */
		public static function retrieveModel($name:String):Model
		{
			return MODELS.retrieveData($name);
		}
		
		
		/**
		 * @private
		 */
		private static const MODELS:Holder = new Holder;
		
	}
}