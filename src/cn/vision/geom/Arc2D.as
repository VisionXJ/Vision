package cn.vision.geom
{
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentArcError;
	import cn.vision.errors.ArgumentArcRadiusUnequalError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.geom.Point2DUtil;
	
	import flash.geom.Point;
	
	/**
	 * 平面圆弧。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Arc2D extends Circle2D
	{
		
		/**
		 * 构造函数，传入参数并解析成圆弧。
		 * 
		 * @copy cn.vision.geom.Arc2D#parse()
		 * 
		 */
		public function Arc2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * Arc2D的解析传入参数有以下方式：<br>
		 * 1：传入起始点，终点，中心点；<br>
		 * 2：传入r，h，k，radianStart, radianEnd, clockwise。<br>
		 * 
		 * 如果不传入任何参数，则默认构造一段半径为1的半圆弧。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 1: case 2: case 5: case 6:
					resolveArc.apply(null, $args); break;
				case 3: resolveThree($args[0], $args[1], $args[2]); break;
				case 4: resolveFour($args[0], $args[1], $args[2], $args[3]); break;
				case 0: resolveArc(1); break;
				default: throw new ArgumentNumError(0, 1, 2, 3, 4, 5, 6); 
			}
		}
		
		private function resolveThree($1:*, $2:*, $3:*):void
		{
			if ($1 is Point && $2 is Point && $3 is Point)
				resolvePoints($1, $2, $3);
			else if ($1 is Number && $2 is Number && $3 is Number)
				resolveArc($1, $2, $3);
			else
				throw new ArgumentArcError;
		}
		
		/**
		 * @private
		 */
		private function resolveFour($1:*, $2:*, $3:*, $4:*):void
		{
			if ($1 is Point && $2 is Point && $3 is Point && $4 is Boolean)
				resolvePoints($1, $2, $3, $4);
			else if ($1 is Number && $2 is Number && $3 is Number && $4 is Number)
				resolveArc($1, $2, $3, $4);
			else
				throw new ArgumentArcError;
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($start:Point, $end:Point, $center:Point, $clockwise:Boolean = true):void
		{
			var d1:Number = Point.distance($start, $center);
			var d2:Number = Point.distance($end, $center);
			if (MathUtil.equal(d1, d2, 3) && d1 > 0)
			{
				resolveArc(d1, $center.x, $center.y, 
					Point2DUtil.angle($center, $start), 
					Point2DUtil.angle($center, $end), $clockwise);
			}
			else throw new ArgumentArcRadiusUnequalError;
		}
		
		/**
		 * @private
		 */
		protected function resolveArc(
			$r:Number, 
			$h:Number = 0, 
			$k:Number = 0, 
			$radianStart:Number = 0, 
			$radianEnd:Number = Math.PI, 
			$clockwise:Boolean = true):void
		{
			resolveEllipse($r, $r, $h, $k);
			vs::radianStart = MathUtil.moduloAngle($radianStart, true);
			vs::radianEnd = MathUtil.moduloAngle($radianEnd, true);
			vs::clockwise = $clockwise;
			if (vs::clockwise)
			{
				if (vs::radianEnd > vs::radianStart) vs::radianEnd -= Math.PI * 2;
			}
			else
			{
				if (vs::radianEnd < vs::radianStart) vs::radianEnd += Math.PI * 2;
			}
			vs::start.copyFrom(Point2DUtil.offset(vs::center, vs::radianStart, vs::a));
			vs::end.copyFrom(Point2DUtil.offset(vs::center, vs::radianEnd, vs::a));
		}
		
		
		/**
		 * 克隆圆弧属性。
		 */
		override protected function cloneAttributes($target:*):*
		{
			$target.vs::clockwise = vs::clockwise;
			$target.vs::radianStart = vs::radianStart;
			$target.vs::radianEnd = vs::radianEnd;
			$target.vs::start.copyFrom(vs::start);
			$target.vs::end.copyFrom(vs::end);
			return super.cloneAttributes($target);
		}
		
		
		/**
		 * @private
		 */
		override public function set r($value:Number):void
		{
			if ($value != vs::a)
				resolveArc($value, vs::h, vs::k, vs::radianStart, vs::radianEnd, vs::clockwise as Boolean);
		}
		
		
		/**
		 * 是否为顺时针。
		 */
		public function get clockwise():Boolean
		{
			return vs::clockwise as Boolean;
		}
		
		/**
		 * @private
		 */
		public function set clockwise($value:Boolean):void
		{
			vs::clockwise = $value;
		}
		
		
		/**
		 * 起始弧度。
		 */
		public function get radianStart():Number
		{
			return vs::radianStart;
		}
		
		/**
		 * @private
		 */
		public function set radianStart($value:Number):void
		{
			if ($value != vs::radianStart)
				resolveArc(vs::a, vs::h, vs::k, $value, vs::radianEnd, vs::clockwise as Boolean);
		}
		
		
		/**
		 * 终止弧度。
		 */
		public function get radianEnd():Number
		{
			return vs::radianEnd;
		}
		
		/**
		 * @private
		 */
		public function set radianEnd($value:Number):void
		{
			if ($value != vs::radianEnd)
				resolveArc(vs::a, vs::h, vs::k, vs::radianStart, $value, vs::clockwise as Boolean);
		}
		
		
		/**
		 * 圆弧起点。
		 */
		public function get start():Point
		{
			return vs::start.clone();
		}
		
		
		/**
		 * 圆弧终点。
		 */
		public function get end():Point
		{
			return vs::end.clone();
		}
		
		
		/**
		 * @private
		 */
		vs var start:Point = new Point;
		
		/**
		 * @private
		 */
		vs var end:Point = new Point;
		
		/**
		 * @private
		 */
		vs var clockwise:Boolean = true;
		
		/**
		 * @private
		 */
		vs var radianStart:Number = 0;
		
		/**
		 * @private
		 */
		vs var radianEnd:Number = Math.PI * 2;
		
	}
}