package cn.vision.geom
{
	
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentInvalidError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 平面直线。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Line2D extends Geom2D
	{
		
		/**
		 * 构造函数，传入参数并解析成直线方程，
		 * 
		 * @copy cn.vision.geom.Line2D#parse()
		 * 
		 */
		public function Line2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * 根据传入的参数进行直线解析。
		 * 
		 * 传入参数有以下几种形式：<br>
		 * 1：传入A，B，C三个系数，构造Ax+By+C=0形式的直线方程；<br>
		 * 2：传入k，b系数，构造y=kx+b形式的直线方程；<br>
		 * 3：传入p1，p2两点构造直线方程；<br>
		 * 4：传入x1，y1，x2，y2构造直线方程。<br>
		 * 
		 * 如果不传入任何参数，则是与X轴重合的直线 y=0。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 2 : resolveTwo($args[0], $args[1]); break;
				case 3 : resolveLine($args[0], $args[1], $args[2]); break;
				case 4 : resolvePoints($args[0], $args[1], $args[2], $args[3]); break;
				case 0 : resolveLine(0, 1, 0); break;
				default: throw new ArgumentNumError(0, 2, 3, 4);
			}
		}
		
		/**
		 * @private
		 */
		private function resolveTwo($arg1:*, $arg2:*):void
		{
			$arg1 is Point
				? ($arg2 is Point
					? resolvePoints($arg1.x, $arg1.y, $arg2.x, $arg2.y)
					: resolvePK($arg1, $arg2))
				: resolveKB($arg1, $arg2);
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($x1:Number, $y1:Number, $x2:Number, $y2:Number):void
		{
			resolveLine($y1 - $y2, $x2 - $x1, $x1 * $y2 - $x2 * $y1);
		}
		
		/**
		 * @private
		 */
		private function resolvePK($p:Point, $k:Number):void
		{
			($k == Number.POSITIVE_INFINITY || 
			 $k == Number.NEGATIVE_INFINITY)
				? resolveLine( 1, 0, -$p.x)
				: resolveLine($k, 1, -$p.y + $k * $p.x);
		}
		
		/**
		 * @private
		 */
		private function resolveKB($k:Number, $b:Number):void
		{
			($k == Number.POSITIVE_INFINITY || 
			 $k == Number.NEGATIVE_INFINITY)
				? resolveLine(-1, 0, $b)
				: resolveLine($k,-1, $b);
		}
		
		/**
		 * @private
		 */
		protected function resolveLine($A:Number, $B:Number, $C:Number):void
		{
			if ($A == 0 && $B == 0 && $C!= 0) throw new ArgumentInvalidError;
			else
			{
				if ($B < 0 && vs::above0B) $A = -$A, $B = -$B, $C = -$C;
				
				vs::A = $A;
				vs::B = $B;
				vs::C = $C;
				vs::k = -vs::A / vs::B;
				vs::b = -vs::C / vs::B;
				
				resolveAngle();
			}
		}
		
		/**
		 * 解析与X轴的夹角。
		 */
		protected function resolveAngle():void
		{
			vs::angle = Math.atan(vs::k);
		}
		
		
		/**
		 * 克隆属性。
		 * 
		 * @param $target:* 要复制到的目标对象。
		 * 
		 * @return *
		 * 
		 */
		override protected function cloneAttributes($target:*):*
		{
			$target.vs::A = vs::A;
			$target.vs::B = vs::B;
			$target.vs::C = vs::C;
			$target.vs::k = vs::k;
			$target.vs::b = vs::b;
			$target.vs::above0B = vs::above0B;
			$target.vs::angle   = vs::angle;
			return $target;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IGeom2D#transform()
		 */
		override public function transform($matrix:Matrix):void
		{
			const a:Number = $matrix.d * vs::A + $matrix.c * vs::B;
			const b:Number = $matrix.b * vs::A + $matrix.a * vs::B;
			resolveLine(a, b, vs::C -$matrix.tx * a - $matrix.ty * b);
		}
		
		
		/**
		 * @private
		 */
		public function toString():String
		{
			return "[" + A + "," + B + "," + C + "]";
		}
		
		
		/**
		 * 是否开启系数B永远大于0约束。
		 */
		public function get above0B():Boolean
		{
			return vs::above0B as Boolean;
		}
		
		/**
		 * @private
		 */
		public function set above0B($value:Boolean):void
		{
			if ($value!= vs::above0B)
			{
				vs::above0B = $value;
				resolveLine(vs::A, vs::B, vs::C);
			}
		}
		
		
		/**
		 * 与X轴的夹角，以弧度为单位。
		 */
		public function get angle():Number
		{
			return vs::angle;
		}
		
		
		/**
		 * 直线的斜率，斜率式y=kx+b的k系数。
		 */
		public function get k():Number
		{
			return MathUtil.float(vs::k, 10);
		}
		
		/**
		 * @private
		 */
		public function set k($value:Number):void
		{
			if ($value != vs::k) resolveKB($value, vs::b);
		}
		
		
		/**
		 * 斜率式y=kx+b的b系数。
		 */
		public function get b():Number
		{
			return MathUtil.float(vs::b, 10);
		}
		
		/**
		 * @private
		 */
		public function set b($value:Number):void
		{
			if ($value != vs::b) resolveKB(vs::k, $value);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的A系数。
		 */
		public function get A():Number
		{
			return MathUtil.float(vs::A, 10);
		}
		
		/**
		 * @private
		 */
		public function set A($value:Number):void
		{
			if ($value != vs::A) resolveLine($value, vs::B, vs::C);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的B系数。
		 */
		public function get B():Number
		{
			return MathUtil.float(vs::B, 10);
		}
		
		/**
		 * @private
		 */
		public function set B($value:Number):void
		{
			if ($value != vs::B) resolveLine(vs::A, $value, vs::C);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的C系数。
		 */
		public function get C():Number
		{
			return MathUtil.float(vs::C, 10);
		}
		
		/**
		 * @private
		 */
		public function set C($value:Number):void
		{
			if ($value != vs::C) resolveLine(vs::A, vs::B, $value);
		}
		
		
		/**
		 * @private
		 */
		vs var above0B:Number = 0;
		
		/**
		 * @private
		 */
		vs var angle:Number;
		
		/**
		 * @private
		 */
		vs var k:Number = 0;
		
		/**
		 * @private
		 */
		vs var b:Number = 0;
		
		/**
		 * @private
		 */
		vs var A:Number = 0;
		
		/**
		 * @private
		 */
		vs var B:Number = 1;
		
		/**
		 * @private
		 */
		vs var C:Number = 0;
		
	}
}