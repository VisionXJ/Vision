package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * 点工具。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Point2DUtil extends NoInstance
	{
		
		/**
		 * 检查点p的坐标范围是否在ab两点之间。
		 * 
		 * @param $p:Point 点P。
		 * @param $a:Point 点a。
		 * @param $b:Point 点b。
		 * 
		 * @return Boolean true为在ab之间。
		 * 
		 */
		public static function between($p:Point, $a:Point, $b:Point):Boolean
		{
			return MathUtil.between($p.x, $a.x, $b.x) && MathUtil.between($p.y, $a.y, $b.y);
		}
		
		
		/**
		 * $p绕$o旋转$radian之后的新点。
		 * 
		 * @param $p:Point 点p。
		 * @param $radian:Number 旋转的弧度。
		 * @param $o:Point 围绕点o。
		 * @param $clone:Boolean (default = false) 是否复制一个新点，还是直接更改p的坐标值。
		 * 
		 * @return Point 如果$clone为true，得到的新点。
		 * 
		 */
		public static function rotate(
			$p:Point, 
			$radian:Number, 
			$o:Point = null, 
			$clone:Boolean = false):Point
		{
			$o = $o || new Point;
			var result:Point = $clone ? new Point : $p;
			const cos:Number = Math.cos($radian);
			const sin:Number = Math.sin($radian);
			const sbx:Number = $p.x - $o.x;
			const sby:Number = $p.y - $o.y;
			result.setTo(
				sbx * cos - sby * sin + $o.x, 
				sbx * sin + sby * cos + $o.y);
			return result;
		}
		
		
		/**
		 * 2线段的交点。
		 * 
		 * @param $a1:Point 线段a点1。
		 * @param $a2:Point 线段a点2。
		 * @param $b1:Point 线段b点1。
		 * @param $b2:Point 线段b点2。
		 * @param $limit:Boolean (default = false) 是否开启线段限制。
		 * 
		 */
		public static function intersect($a1:Point, $a2:Point, $b1:Point, $b2:Point, $limit:Boolean = true):Point
		{
			var x12:Number = $a1.x - $a2.x;
			var x34:Number = $b1.x - $b2.x;
			var y12:Number = $a1.y - $a2.y;
			var y34:Number = $b1.y - $b2.y;
			var s:Number = x12 * y34 - y12 * x34;
			if(s != 0)
			{
				var n1:Number = $a1.x * $a2.y - $a1.y * $a2.x;
				var n2:Number = $b1.x * $b2.y - $b1.y * $b2.x;
				var result:Point = new Point(
					(n1 * x34 - x12 * n2) / s, 
					(n1 * y34 - y12 * n2) / s);
				if($limit && 
					!between(result, $a1, $a2) || 
					!between(result, $b1, $b2)) result = null;
			}
			return result;
		}
		
	}
}