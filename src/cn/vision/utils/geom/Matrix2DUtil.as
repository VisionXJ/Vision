package cn.vision.utils.geom
{
	
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.geom.Matrix;
	
	/**
	 * 定义了一些二维矩阵常用方法。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Matrix2DUtil extends NoInstance
	{
		
		/**
		 * 对Matrix进行变换。
		 * 
		 * @param $matrix:Matrix 要变换的Matrix
		 * @param $translateX:Number (default = 0) X方向平移。
		 * @param $translateY:Number (default = 0) Y方向平移。
		 * @param $scaleX:Number (default = 1) X方向缩放。
		 * @param $scaleY:Number (default = 1) Y方向缩放。
		 * @param $rotation:Number (default = 0) 以弧度为单位的旋转角度。
		 * @param $x:Number (default = 0) X中心偏移。
		 * @param $y:Number (default = 0) Y中心偏移。
		 * 
		 */
		public static function transform($matrix:Matrix,
										 $translateX:Number = 0, $translateY:Number = 0,
										 $scaleX:Number = 1, $scaleY:Number = 1,
										 $rotation:Number = 0, 
										 $x:Number = 0, $y:Number = 0):void
		{
			$matrix.translate(-$x, -$y);
			$matrix.scale($scaleX, $scaleY);
			$matrix.rotate($rotation);
			$matrix.translate($x + $translateX, $y + $translateY);
		}
		
	}
}