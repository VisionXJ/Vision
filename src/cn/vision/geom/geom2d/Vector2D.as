package cn.vision.geom.geom2d
{
	
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentNumError;
	
	import flash.geom.Point;
	
	/**
	 * 平面向量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Vector2D extends Line2D
	{
		
		/**
		 * 构造函数，传入参数并解析成向量，
		 * 如果不传入任何参数，则表示为X轴的单位向量(1, 0)。<br>
		 * 
		 * @copy cn.vision.geom.plane.Vector2D#parse()
		 * 
		 */
		public function Vector2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * Vector2D的解析传入参数有以下方式：<br>
		 * 1：传入起始点，长度，以及与X轴的夹角；<br>
		 * 2：传入起始点，终止点；<br>
		 * 3：传入一个Point；<br>
		 * 4；传入u，v。<br>
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			resolveLine($args);
			resolveVector($args);
			resolveAngle();
		}
		
		
		/**
		 * 解析向量。
		 * 
		 * @param $args:Array 传入参数。
		 * 
		 */
		protected function resolveVector($args:Array):void
		{
			switch ($args.length)
			{
				case 1 : resolvePoints(0, 0, $args[0].x, $args[0].y); break;
				case 2 : resolveTwo($args[0], $args[1]); break;
				case 3 : resolvePointLK($args[0], $args[1], $args[2]); break;
				case 4 : resolvePoints($args[0], $args[1], $args[2], $args[3]); break;
				case 0 : break;
				default: throw new ArgumentNumError(0, 1, 2, 3, 4); 
			}
		}
		
		/**
		 * @private
		 */
		private function resolveTwo($arg1:*, $arg2:*):void
		{
			$arg1 is Point
				? resolvePoints($arg1.x, $arg1.y, $arg2.x, $arg2.y)
				: resolvePoints(0, 0, $arg1, $arg2);
		}
		
		/**
		 * @private
		 */
		private function resolvePointLK($start:Point, $length:Number, $radian:Number):void
		{
			resolvePoints($start.x, $start.y, 
				$start.x + $length * Math.cos($radian), 
				$start.y + $length * Math.sin($radian));
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($x1:Number, $y1:Number, $x2:Number, $y2:Number):void
		{
			vs::start.setTo($x1, $y1);
			vs::end  .setTo($x2, $y2);
			vs::u = $x2 - $x1;
			vs::v = $y2 - $y1;
			vs::length = Point.distance(vs::start, vs::end);
		}
		
		
		/**
		 * @copy cn.vision.geom.geom2d.Line2D#resolveAngle()
		 */
		override protected function resolveAngle():void
		{
			vs::angle = Math.atan2(vs::v, vs::u);
		}
		
		
		/**
		 * 克隆线段的属性。
		 */
		override protected function cloneAttributes($target:*):*
		{
			$target.vs::start.copyFrom(vs::start);
			$target.vs::end  .copyFrom(vs::end);
			$target.vs::u = vs::u;
			$target.vs::v = vs::v;
			$target.vs::length = vs::length;
			return super.cloneAttributes($target);
		}
		
		
		/**
		 * @private
		 */
		private function resolveAll():void
		{
			var args:Array = [vs::start.x, vs::start.y, vs::end.x, vs::end.y];
			resolveLine(args);
			resolveVector(args);
			resolveAngle();
		}
		
		
		/**
		 * @private
		 */
		public function set angle($value:Number):void
		{
			if ($value != vs::angle)
			{
				vs::end.setTo(
					vs::start.x + vs::length * Math.cos($value), 
					vs::start.y + vs::length * Math.sin($value));
				resolveAll();
			}
		}
		
		
		/**
		 * 向量起点。
		 */
		public function get start():Point
		{
			return vs::start.clone();
		}
		
		/**
		 * @private
		 */
		public function set start($value:Point):void
		{
			if(!vs::start.equals($value))
			{
				vs::start.copyFrom($value);
				resolveAll();
			}
		}
		
		
		/**
		 * 向量终点。
		 */
		public function get end():Point
		{
			return vs::end.clone();
		}
		
		/**
		 * @private
		 */
		public function set end($value:Point):void
		{
			if(!vs::end.equals($value))
			{
				vs::end.copyFrom($value);
				resolveAll();
			}
		}
		
		
		/**
		 * 向量长度。
		 */
		public function get length():Number
		{
			return vs::length;
		}
		
		/**
		 * @private
		 */
		public function set length($value:Number):void
		{
			if ($value != vs::length)
			{
				vs::end.setTo(
					vs::start.x + $value * Math.cos(vs::angle), 
					vs::start.y + $value * Math.sin(vs::angle));
				resolveAll();
			}
		}
		
		
		/**
		 * x方向上增量。
		 */
		public function get u():Number
		{
			return vs::u;
		}
		
		/**
		 * @private
		 */
		public function set u($value:Number):void
		{
			if ($value != vs::u)
			{
				vs::end.x = vs::start.x + $value;
				resolveAll();
			}
		}
		
		
		/**
		 * y方向上增量。
		 */
		public function get v():Number
		{
			return vs::v;
		}
		
		/**
		 * @private
		 */
		public function set v($value:Number):void
		{
			if ($value != vs::v)
			{
				vs::end.y = vs::start.y + $value;
				resolveAll();
			}
		}
		
		
		/**
		 * @private
		 */
		vs var start:Point = new Point;
		
		/**
		 * @private
		 */
		vs var end:Point = new Point(1, 0);
		
		/**
		 * @private
		 */
		vs var length:Number;
		
		/**
		 * @private
		 */
		vs var u:Number = 1;
		
		/**
		 * @private
		 */
		vs var v:Number = 0;
		
	}
}