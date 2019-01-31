package cn.vision.geom
{
	import cn.vision.core.vs;
	import cn.vision.errors.AbstractError;
	import cn.vision.utils.ArrayUtil;
	
	import flash.geom.Point;
	
	/**
	 * 平面二次贝塞尔曲线。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Curve2D extends Bezier2D
	{
		
		/**
		 * 构造函数。
		 * 
		 * 根据传入参数进行贝塞尔曲线解析。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 终止点。
		 * @param $ctrl:Point 控制点。
		 * 
		 */
		public function Curve2D($start:Point, $end:Point, $ctrl:Point)
		{
			super($start, $end, $ctrl);
		}
		
		
		override public function addCtrl($ctrl:Point, $index:uint=uint.MAX_VALUE):void { throw new AbstractError("addCtrl"); }
		
		override public function getCtrl($index:uint):Point { throw new AbstractError("getCtrl"); }
		
		override public function modifyCtrl($ctrl:Point, $index:int):void { throw new AbstractError("modifyCtrl"); }
		
		override public function removeCtrl($index:uint):void { throw new AbstractError("removeCtrl"); }
		
		
		/**
		 * 控制点。
		 */
		public function get ctrl():Point
		{
			return vs::ctrls[0].clone();
		}
		
		/**
		 * @private
		 */
		public function set ctrl($value:Point):void
		{
			if(!vs::ctrls[0].equals($value))
				vs::ctrls[0].copyFrom($value);
		}
		
	}
}