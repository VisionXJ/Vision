package cn.vision.geom
{
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentCircleRLargerZeroError;
	import cn.vision.errors.ArgumentInvalidError;
	import cn.vision.errors.ArgumentNumError;
	
	import flash.geom.Point;
	
	/**
	 * 平面圆。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Circle2D extends Ellipse2D
	{
		
		/**
		 * 构造函数，传入参数并解析成圆。
		 * 
		 * @copy cn.vision.geom.Circle2D#parse()
		 * 
		 */
		public function Circle2D(...$args)
		{
			super($args);
		}
		
		/**
		 * 根据传入的参数进行圆解析。
		 * 
		 * 传入参数有以下几种形式：<br>
		 * 1：传入A，O两个点：A为圆上任意一点；O为圆心。<br>
		 * 2：传入r，O，r为圆的半径，O为圆心。<br>
		 * 3：传入r，h，k，r为圆的半径，h为圆心X坐标，k为圆心Y坐标。
		 * 
		 * 注：如果不传入任何参数，则会与构造标准椭圆x^2+y^2=1。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 2:
					resolveTwo($args[0], $args[1]); break;
				case 3:
					resolveEllipse($args[0], $args[0], $args[1], $args[2]); break;
				case 0:
					resolveEllipse(1, 1); break;
				default:
					throw new ArgumentNumError(0, 2, 3);
			}
		}
		
		/**
		 * @private
		 */
		private function resolveTwo($1:*, $2:*):void
		{
			if ($1 is Point && $2 is Point)
				resolvePoints($1, $2);
			else if ($1 is Number && $2 is Point)
				resolveEllipse($1, $1, $2.x, $2.y);
			else throw new ArgumentInvalidError;
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($A:Point, $O:Point):void
		{
			var d:Number = Point.distance($A, $O);
			if (d > 0) resolveEllipse(d, d, $O.x, $O.y);
			else throw new ArgumentCircleRLargerZeroError;
		}
		
		
		/**
		 * 半径。
		 */
		public function get r():Number
		{
			return vs::a;
		}
		
		/**
		 * @private
		 */
		public function set r($value:Number):void
		{
			if ($value != vs::a)
				resolveEllipse($value, $value, vs::h, vs::k, vs::angle);
		}
		
		
		/**
		 * @private
		 */
		override public function set angle(value:Number):void { }
		
		/**
		 * @private
		 */
		override public function set a($value:Number):void
		{
			if ($value != vs::a)
				resolveEllipse($value, $value, vs::h, vs::k, vs::angle);
		}
		
		/**
		 * @private
		 */
		override public function set b($value:Number):void
		{
			if ($value != vs::a)
				resolveEllipse($value, $value, vs::h, vs::k, vs::angle);
		}
		
	}
}