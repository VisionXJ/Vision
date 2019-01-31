package cn.vision.geom
{
	import cn.vision.core.VSObject;
	import cn.vision.errors.AbstractError;
	import cn.vision.interfaces.IGeom2D;
	import cn.vision.utils.ClassUtil;
	
	import flash.geom.Matrix;
	
	/**
	 * 平面几何基类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	internal class Geom2D extends VSObject implements IGeom2D
	{
		/**
		 * 构造函数，传入参数并解析。
		 * 
		 * @param ...$args 传入的参数。
		 * 
		 */
		public function Geom2D(...$args)
		{
			super();
			$args = resolveArgs($args);
			parse.apply(null, $args);
		}
		
		
		/**
		 * 对参数数组的嵌套进行反解析。
		 * 
		 * @param $args:Array
		 * 
		 * @return Array
		 * 
		 */
		protected function resolveArgs($args:Array):Array
		{
			while ($args.length == 1 && $args[0] is Array) $args = $args[0];
			return $args;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IGeom2D#transform()
		 */
		public function transform($matrix:Matrix):void
		{
			throw new AbstractError("transform");
		}
		
		
		/**
		 * 解析传入的参数。
		 * 
		 * @param ...$args 传入的参数不定，在子类中覆盖parse方法分情况解析。
		 * 
		 */
		protected function parse(...$args):void
		{
			throw new AbstractError("parse");
		}
		
		
		/**
		 * 克隆属性。
		 */
		protected function cloneAttributes($target:*):*
		{
			throw new AbstractError("cloneAttributes");
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IClone#clone()
		 */
		public function clone():*
		{
			return cloneAttributes(new (ClassUtil.getClass(this)));
		}
		
	}
}