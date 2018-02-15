package cn.vision.geom.plane
{
	import cn.vision.core.vs;
	
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
	public class Line extends Geom
	{
		/**
		 * 构造函数，传入参数并解析成直线方程，
		 * 如果不传入任何参数，则表示为X轴的直线y = 0。<br>
		 * 
		 * @copy cn.vision.geom.plane.Line#parse()
		 * 
		 */
		public function Line(...$args)
		{
			super();
			
			parse.apply(null, $args);
		}
		
		
		/**
		 * 根据传入的参数进行直线解析。
		 * 
		 * Line解析的传入参数有三种形式：<br>
		 * 1：传入A，B，C三个系数，构造Ax+By+C=0形式的直线方程；<br>
		 * 2：传入k，b系数，构造y=kx+b形式的直线方程；<br>
		 * 3：传入p1，p2两点或x1，y1，x2，y2构造两点式直线方程。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 2:
					resolveTwo($args[0], $args[1]);
					break;
				case 3:
					resolveABC($args[0], $args[1], $args[2]);
					break;
				case 4:
					resolvePoints2($args[0], $args[1], $args[2], $args[3]);
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function resolveTwo($arg1:*, $arg2:*):void
		{
			if ($arg1 is Point)
			{
				if ($arg2 is Point) resolvePoints($arg1, $arg2);
				else resolvePK($arg1, $arg2);
			}
			else
				resolveKB($arg1, $arg2);
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($p1:Point, $p2:Point):void
		{
			resolvePoints2($p1.x, $p1.y, $p2.x, $p2.y);
		}
		
		/**
		 * @private
		 */
		private function resolvePoints2($x1:Number, $y1:Number, $x2:Number, $y2:Number):void
		{
			vs::A = $y1 - $y2;
			vs::B = $x2 - $x1;
			vs::C = $x1 * $y2 - $x2 * $y1;
			
			vs::k = -vs::A / vs::B;
			vs::b = -vs::C / vs::B;
		}
		
		/**
		 * @private
		 */
		private function resolveKB($k:Number, $b:Number):void
		{
			vs::k = $k;
			vs::b = $b;
			if ($k == Number.POSITIVE_INFINITY || 
				$k == Number.NEGATIVE_INFINITY)
			{
				vs::A =-1;
				vs::B = 0;
				vs::C = $b;
			}
			else
			{
				vs::A = vs::k;
				vs::B =-1;
				vs::C = vs::b;
			}
		}
		
		/**
		 * @private
		 */
		private function resolvePK($p:Point, $k:Number):void
		{
			if ($k == Number.POSITIVE_INFINITY || 
				$k == Number.NEGATIVE_INFINITY)
			{
				vs::A = 1;
				vs::B = 0;
				vs::C =-$p.x;
			}
			else
			{
				vs::A =-$k;
				vs::B = 1;
				vs::C =-$p.y + $k * $p.x;
			}
			vs::k = -vs::A / vs::B;
			vs::b = -vs::C / vs::B;
		}
		
		/**
		 * @private
		 */
		private function resolveABC($A:Number, $B:Number, $C:Number):void
		{
			vs::A = $A;
			vs::B = $B;
			vs::C = $C;
			
			vs::k = -vs::A / vs::B;
			vs::b = -vs::C / vs::B;
		}
		
		
		/**
		 * 复制一个Line的实例，新实例的属性与旧的实例属性相同。
		 * 
		 * @return Line
		 * 
		 */
		override public function clone():*
		{
			var line:Line = new Line;
			line.vs::A = vs::A;
			line.vs::B = vs::B;
			line.vs::C = vs::C;
			line.vs::k = vs::k;
			line.vs::b = vs::b;
			return line;
		}
		
		
		/**
		 * 对直线应用矩阵变换。
		 * 
		 * @param $matrix:Matrix 变换矩阵。
		 * @param $clone:Boolean (default = true) 是否克隆新对象，还是直接改变直线本身。
		 * 
		 */
		public function transform($matrix:Matrix, $clone:Boolean = true):Line
		{
			var line:Line = $clone ? clone() : this;
			const ta:Number = line.vs::A;
			const tb:Number = line.vs::B;
			const tc:Number = line.vs::C;
			line.vs::A = $matrix.d  * ta + $matrix.c  * tb;
			line.vs::B = $matrix.b  * ta + $matrix.a  * tb;
			line.vs::C =-$matrix.tx * line.vs::A - $matrix.ty * line.vs::B + tc;
			line.vs::k = -line.vs::A / line.vs::B;
			line.vs::b = -line.vs::C / line.vs::B;
			
			return $clone ? line : null;
		}
		
		
		/**
		 * 直线的斜率，斜率式y=kx+b的k系数。
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
			if ($value != vs::k) resolveKB($value, vs::b);
		}
		
		/**
		 * 斜率式y=kx+b的b系数。
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
			if ($value != vs::b) resolveKB(vs::k, $value);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的A系数。
		 */
		public function get A():Number
		{
			return vs::A;
		}
		
		/**
		 * @private
		 */
		public function set A($value:Number):void
		{
			if ($value != vs::A) resolveABC($value, vs::B, vs::C);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的B系数。
		 */
		public function get B():Number
		{
			return vs::B;
		}
		
		/**
		 * @private
		 */
		public function set B($value:Number):void
		{
			if ($value != vs::B) resolveABC(vs::A, $value, vs::C);
		}
		
		
		/**
		 * 一般式Ax+By+C=0中的C系数。
		 */
		public function get C():Number
		{
			return vs::C;
		}
		
		/**
		 * @private
		 */
		public function set C($value:Number):void
		{
			if ($value != vs::C) resolveABC(vs::A, vs::B, $value);
		}
		
		
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