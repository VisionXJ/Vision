package cn.vision.utils.geom
{
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * 定义了一些三维矩阵常用方法。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Matrix3DUtil extends NoInstance
	{
		
		/**
		 * 对Matrix3D进行变换。
		 * 
		 * @param $matrix:Matrix 要变换的Matrix
		 * @param $translateX:Number (default = 0) X方向平移。
		 * @param $translateY:Number (default = 0) Y方向平移。
		 * @param $translateZ:Number (default = 0) Z方向平移。
		 * @param $scaleX:Number (default = 1) X方向缩放。
		 * @param $scaleY:Number (default = 1) Y方向缩放。
		 * @param $scaleZ:Number (default = 1) Z方向缩放。
		 * @param $rotationX:Number (default = 0) 绕X轴旋转角度。
		 * @param $rotationY:Number (default = 0) 绕Y轴旋转角度。
		 * @param $rotationZ:Number (default = 0) 绕Z轴旋转角度。
		 * @param $x:Number (default = 0) X中心偏移。
		 * @param $y:Number (default = 0) Y中心偏移。
		 * @param $z:Number (default = 0) Z中心偏移。
		 * 
		 */
		public static function transform($matrix:Matrix3D, 
										 $translateX:Number = 0, $translateY:Number = 0, $translateZ:Number = 0, 
										 $scaleX:Number = 1, $scaleY:Number = 1, $scaleZ:Number = 1, 
										 $rotationX:Number = 0, $rotationY:Number = 0, $rotationZ:Number = 0, 
										 $x:Number = 0, $y:Number = 0, $z:Number = 0):void
		{
			$matrix.appendTranslation(-$x, -$y, -$z);
			$matrix.appendScale($scaleX, $scaleY, $scaleZ);
			$matrix.appendRotation($rotationX * MathConsts.vs::PI_MOD_ANGLE, Vector3D.X_AXIS);
			$matrix.appendRotation($rotationY * MathConsts.vs::PI_MOD_ANGLE, Vector3D.Y_AXIS);
			$matrix.appendRotation($rotationZ * MathConsts.vs::PI_MOD_ANGLE, Vector3D.Z_AXIS);
			$matrix.appendTranslation($x + $translateX, $y + $translateY, $z + $translateZ);
		}
		
	}
}