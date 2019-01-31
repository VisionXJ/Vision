package cn.vision.geom
{
	import cn.vision.core.vs;
	import cn.vision.utils.MathUtil;
	
	/**
	 * 平面圆锥曲线。<br>
	 * 平面圆锥曲线方程为Ax^2+Bxy+Cy^2+Dx+Ey+F=0。<br>
	 * 平面圆锥曲线家族包含双曲线，抛物线，椭圆和圆。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Conics2D extends Geom2D
	{
		public function Conics2D(...$args)
		{
			super($args);
		}
		
		protected function resolveConics($A:Number, $B:Number, $C:Number, $D:Number, $E:Number, $F:Number):void
		{
			vs::A = $A;
			vs::B = $B;
			vs::C = $C;
			vs::D = $D;
			vs::E = $E;
			vs::F = $F;
			
			vs::matrix.parse(
				vs::A, vs::B * .5, vs::D * .5,
				vs::B * .5, vs::C, vs::E * .5,
				vs::D * .5, vs::E * .5, vs::F);
			
			vs::degenerate = vs::matrix.algebraSum == 0;
			
			if (vs::degenerate)
			{
				if (vs::B == 0 && vs::D == 0 && vs::E == 0)
				{
					if (vs::F == 0)
					{
						if (vs::A != 0 && vs::C != 0)
							vs::discriminant = vs::A * vs::B < 0 ? "intersectLines" : "point";
						else if (vs::A != vs::C)
							vs::discriminant = "line";
					}
					else
					{
						if((vs::A == 0 && vs::C * vs::F < 0) || 
						   (vs::C == 0 && vs::A * vs::F < 0))
							vs::discriminant = "parallelLines";
					}
				}
				else if (vs::A == 0 && vs::B == 0 && vs::C == 0)
				{
					vs::discriminant = "line";
				}
			}
			else
			{
				var two:Determinant = new Determinant(vs::A, vs::B * .5, vs::B * .5, vs::C);
				switch (MathUtil.normal(two.algebraSum, true))
				{
					case-1: vs::discriminant = "hyperbola"; break;
					case 0: vs::discriminant = "parabola" ; break;
					case 1: vs::discriminant = "ellipse"  ; break;
				}
			}
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数A。
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
			if ($value!= vs::A) resolveConics($value, vs::B, vs::C, vs::D, vs::E, vs::F);
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数B。
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
			if ($value!= vs::B) resolveConics(vs::A, $value, vs::C, vs::D, vs::E, vs::F);
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数C。
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
			if ($value!= vs::C) resolveConics(vs::A, vs::B, $value, vs::D, vs::E, vs::F);
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数D。
		 */
		public function get D():Number
		{
			return vs::D;
		}
		
		/**
		 * @private
		 */
		public function set D($value:Number):void
		{
			if ($value!= vs::D) resolveConics(vs::A, vs::B, vs::C, $value, vs::E, vs::F);
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数E。
		 */
		public function get E():Number
		{
			return vs::E;
		}
		
		/**
		 * @private
		 */
		public function set E($value:Number):void
		{
			if ($value!= vs::E) resolveConics(vs::A, vs::B, vs::C, vs::D, $value, vs::F);
		}
		
		
		/**
		 * 平面圆锥曲线方程 Ax^2+Bxy+Cy^2+Dx+Ey+F=0 中的系数F。
		 */
		public function get F():Number
		{
			return vs::F;
		}
		
		/**
		 * @private
		 */
		public function set F($value:Number):void
		{
			if ($value!= vs::F) resolveConics(vs::A, vs::B, vs::C, vs::D, vs::E, $value);
		}
		
		
		/**
		 * 是否退化为特殊的点，直线。<br>
		 * 圆锥曲线在某些特例下会退化为点，两条交叉直线，两条平行直线，或一条直线，以下情况为一些特例：<br>
		 * x^2-y^2=0，两条相交的直线；<br>
		 * x^2-1=0，两条平行直线；<br>
		 * x^2+y^2=0，一个点。
		 */
		public function get degenerate():Boolean
		{
			return vs::degenerate as Boolean;
		}
		
		
		/**
		 * 圆锥曲线的表现形式。
		 * 
		 * @see cn.vision.consts.ConicsDiscriminantConsts
		 * 
		 */
		public function get discriminant():String
		{
			return vs::discriminant;
		}
		
		
		/**
		 * 二次方程矩阵行列式，形式为：<br>
		 * |A, B/2, D/2|<br>
		 * |B/2, C, E/2|<br>
		 * |D/2, E/2, F|
		 */
		public function get matrix():Determinant
		{
			return vs::matrix;
		}
		
		
		/**
		 * @private
		 */
		vs var A:Number;
		
		/**
		 * @private
		 */
		vs var B:Number;
		
		/**
		 * @private
		 */
		vs var C:Number;
		
		/**
		 * @private
		 */
		vs var D:Number;
		
		/**
		 * @private
		 */
		vs var E:Number;
		
		/**
		 * @private
		 */
		vs var F:Number;
		
		/**
		 * @private
		 */
		vs var matrix:Determinant = new Determinant(1, 0, 0, 0, 1, 0, 0, 0, 1);
		
		/**
		 * @private
		 */
		vs var degenerate:Boolean;
		
		/**
		 * @private
		 */
		vs var discriminant:String;
		
	}
}