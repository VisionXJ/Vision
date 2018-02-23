package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.interfaces.IGeom2D;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 平面几何矩阵变换工具类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Geom2DUtil extends NoInstance
	{
		
		/**
		 * 图形平移。
		 * 
		 * @param $geom:IGeom2D 要平移的图形实例。
		 * @param $x:Number x方向平移。
		 * @param $y:Number y方向平移。
		 * 
		 */
		public static function move($geom:IGeom2D, $x:Number, $y:Number):void
		{
			var matrix:Matrix = new Matrix;
			matrix.translate($x, $y);
			$geom.transform(matrix);
		}
		
		
		/**
		 * 图形旋转。
		 * 
		 * @param $geom:IGeom2D 要旋转的图形实例。
		 * @param $radian:Number 以弧度为单位的旋转角度。
		 * @param $point:Point (default = null) 绕某个点旋转，如为空则视为原点(0, 0)。
		 * 
		 */
		public static function rotate($geom:IGeom2D, $radian:Number, $point:Point = null):void
		{
			var matrix:Matrix = new Matrix;
			if ($point)
			{
				matrix.translate(-$point.x, -$point.y);
				var rotate:Matrix = new Matrix();
				rotate.rotate($radian);
				matrix.concat(rotate);
				var move:Matrix = new Matrix;
				move.translate($point.x, $point.y);
				matrix.concat(move);
			}
			else
			{
				matrix.rotate($radian);
			}
			
			$geom.transform(matrix);
		}
		
		
		/**
		 * 图形缩放。
		 * 
		 * @param $geom:IGeom2D 要缩放的图形实例。
		 * @param $scaleX:Number x方向缩放。
		 * @param $scaleY:Number y方向缩放。
		 * 
		 */
		public static function scale($geom:IGeom2D, $scaleX:Number, $scaleY:Number):void
		{
			var matrix:Matrix = new Matrix;
			matrix.scale($scaleX, $scaleY);
			$geom.transform(matrix);
		}
		
	}
}