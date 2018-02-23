package cn.vision.interfaces
{
	import flash.geom.Matrix;

	/**
	 * 平面几何接口。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public interface IGeom2D extends IClone
	{
		
		/**
		 * 矩阵变换。
		 * 
		 * @param $matrix:Matrix 变换矩阵。
		 * 
		 */
		function transform($matrix:Matrix):void;
		
	}
}