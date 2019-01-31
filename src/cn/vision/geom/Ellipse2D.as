package cn.vision.geom
{
	import cn.vision.consts.MathConsts;
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentEllispeUnverticalError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.utils.geom.Point2DUtil;
	import cn.vision.utils.geom.Vector2DUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 平面椭圆。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Ellipse2D extends Geom2D
	{
		
		/**
		 * 构造函数，传入参数并解析成椭圆。
		 * 
		 * @copy cn.vision.geom.Ellipse2D#parse()
		 * 
		 */
		public function Ellipse2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * 根据传入的参数进行椭圆解析。
		 * 
		 * 传入参数有以下几种形式：<br>
		 * 1：定义椭圆旋转角度为angle，传入vertexA，vertexB，center三个点：
		 * vertexA为椭圆中心出发以angle角度方向发出的射线与椭圆的交点；
		 * vertexB为椭圆中心出发以angle+pi/2角度方向发出的射线与椭圆的交点；
		 * center为椭圆中心点。<br>
		 * 
		 * 2：传入a，b，h，k，angle参数，其中，h，k，angle可省略，默认值皆为0。<br>
		 * 
		 * 注：如果不传入任何参数，则会构造椭圆x^2/2^2+y^2=1。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 3:
					resolveThree($args[0], $args[1], $args[2]);
					break;
				case 2: case 4: case 5:
					resolveEllipse.apply(null, $args);
					break;
				case 0:
					resolveEllipse(2, 1);
					break;
				default:
					throw new ArgumentNumError(0, 2, 3, 4, 5);
			}
		}
		
		/**
		 * @private
		 */
		private function resolveThree($1:*, $2:*, $3:*):void
		{
			if ($1 is Point && $2 is Point && $3 is Point)
				resolvePoints($1, $2, $3);
			else
				resolveEllipse($1, $2, $3);
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($vertexA:Point, $vertexB:Point, $center:Point):void
		{
			var va:Vector2D = new Vector2D($center, $vertexA);
			var vb:Vector2D = new Vector2D($center, $vertexB);
			if (Vector2DUtil.dotProduct(va, vb) == 0)
				resolveEllipse(va.length, vb.length, $center.x, $center.y, va.angle);
			else
				throw new ArgumentEllispeUnverticalError;
		}
		
		/**
		 * @private
		 */
		protected function resolveEllipse(
			$a:Number, 
			$b:Number, 
			$h:Number = 0, 
			$k:Number = 0, 
			$angle:Number = 0):void
		{
			vs::angle = $angle;
			vs::a = $a;
			vs::b = $b;
			vs::h = $h;
			vs::k = $k;
			
			vs::center.setTo($h, $k);
			vs::vertexA.copyFrom(Point2DUtil.offset(vs::center, vs::angle, vs::a));
			vs::vertexB.copyFrom(Point2DUtil.offset(vs::center, vs::angle + MathConsts.PI_2, vs::b));
		}
		
		
		/**
		 * 克隆椭圆的属性。
		 */
		override protected function cloneAttributes($target:*):*
		{
			$target.vs::angle = vs::angle;
			$target.vs::a = vs::a;
			$target.vs::b = vs::b;
			$target.vs::h = vs::h;
			$target.vs::k = vs::k;
			$target.vs::vertexA.copyFrom(vs::vertexA);
			$target.vs::vertexB.copyFrom(vs::vertexB);
			$target.vs::center.copyFrom(vs::center);
			return $target;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IGeom2D#transform()
		 */
		override public function transform($matrix:Matrix):void
		{
			resolvePoints(
				$matrix.transformPoint(vs::vertexA), 
				$matrix.transformPoint(vs::vertexB), 
				$matrix.transformPoint(vs::center));
		}
		
		
		/**
		 * 旋转弧度。
		 */
		public function get angle():Number
		{
			return vs::angle;
		}
		
		/**
		 * @private
		 */
		public function set angle($value:Number):void
		{
			if ($value!= vs::angle)
				resolveEllipse(vs::a, vs::b, vs::h, vs::k, $value);
		}
		
		
		/**
		 * X轴半径，通用公式中记作参数a。
		 */
		public function get a():Number
		{
			return vs::a;
		}
		
		/**
		 * @private
		 */
		public function set a($value:Number):void
		{
			if ($value!= vs::a)
				resolveEllipse($value, vs::b, vs::h, vs::k, vs::angle);
		}
		
		
		/**
		 * Y轴半径，通用公式中记作参数b。
		 */
		public function get b():Number
		{
			return vs::b;
		}
		
		/**
		 * @private
		 */
		public function set b($value:Number):void
		{
			if ($value!= vs::b)
				resolveEllipse(vs::a, $value, vs::h, vs::k, vs::angle);
		}
		
		
		/**
		 * 圆心X坐标，通用公式中记作参数h。
		 */
		public function get h():Number
		{
			return vs::h;
		}
		
		/**
		 * @private
		 */
		public function set h($value:Number):void
		{
			if ($value!= vs::h)
				resolveEllipse(vs::a, vs::b, $value, vs::k, vs::angle);
		}
		
		
		/**
		 * 圆心Y坐标，通用公式中记作参数k。
		 */
		public function get k():Number
		{
			return vs::k;
		}
		
		/**
		 * @private
		 */
		public function set k($value:Number):void
		{
			if ($value!= vs::k)
				resolveEllipse(vs::a, vs::b, vs::h, $value, vs::angle);
		}
		
		
		/**
		 * 椭圆上的边界点A，从椭圆中心点发出一条与X轴夹角为angle，长度为a的射线，所得到的点。
		 */
		public function get vertexA():Point
		{
			return vs::vertexA.clone();
		}
		
		
		/**
		 * 椭圆上的边界点B，从椭圆中心点发出一条与X轴夹角为angle+pi/2，长度为b的射线，所得到的点。
		 */
		public function get vertexB():Point
		{
			return vs::vertexB.clone();
		}
		
		
		/**
		 * 圆心O。
		 */
		public function get center():Point
		{
			return vs::center.clone();
		}
		
		
		/**
		 * @private
		 */
		vs var angle:Number;
		
		/**
		 * @private
		 */
		vs var a:Number;
		
		/**
		 * @private
		 */
		vs var b:Number;
		
		/**
		 * @private
		 */
		vs var h:Number;
		
		/**
		 * @private
		 */
		vs var k:Number;
		
		/**
		 * @private
		 */
		vs var vertexA:Point = new Point;
		
		/**
		 * @private
		 */
		vs var vertexB:Point = new Point;
		
		/**
		 * @private
		 */
		vs var center:Point = new Point;
		
	}
}