package cn.vision.geom.plane
{
	import cn.vision.core.VSObject;
	
	/**
	 * 几何基类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	internal class Geom extends VSObject
	{
		public function Geom()
		{
			super();
		}
		
		
		/**
		 * 解析传入的参数。
		 * 
		 * @param ...$args 传入的参数不定，在子类中覆盖parse方法分情况解析。
		 * 
		 */
		protected function parse(...$args):void
		{
			
		}
		
		
		/**
		 * 复制一个本身的实例。
		 */
		public function clone():*
		{
			return new Geom;
		}
		
	}
}