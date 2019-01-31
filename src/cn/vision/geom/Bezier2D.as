package cn.vision.geom
{
	import cn.vision.core.vs;
	import cn.vision.errors.IndexOutOfRangeError;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.geom.Bezier2DUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 平面贝塞尔曲线。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Bezier2D extends Geom2D
	{
		
		/**
		 * 构造函数。
		 * 
		 * 根据传入参数进行贝塞尔曲线解析。
		 * 
		 * @param $start:Point 起始点。
		 * @param $end:Point 终止点。
		 * @param ...$args 其他控制点参数，可以是控制点数组，数组只能是Array类型。
		 * 
		 */
		public function Bezier2D($start:Point, $end:Point, ...$args)
		{
			$args = resolveArgs($args);
			ArrayUtil.unshift($args, $start, $end);
			super($args);
		}
		
		/**
		 * 根据传入的参数进行贝塞尔曲线解析。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			vs::start.copyFrom(ArrayUtil.shift($args));
			vs::end  .copyFrom(ArrayUtil.shift($args));
			vs::ctrls = $args.concat();
			vs::numCtrls = vs::ctrls.length;
		}
		
		
		/**
		 * 添加一个控制点。
		 * 
		 * @param $vertex:Point 顶点。
		 * @param $index:uint 序号。
		 * 
		 */
		public function addCtrl($ctrl:Point, $index:uint = uint.MAX_VALUE):void
		{
			$index = MathUtil.clamp($index, 0, vs::numVertex);
			vs::ctrls.splice($index, 0, $ctrl);
			vs::numVertex = vs::vertexes.length;
		}
		
		
		/**
		 * 获取一个顶点。
		 * 
		 * @param $index:uint 序号。
		 * 
		 */
		public function getCtrl($index:uint):Point
		{
			if (MathUtil.range($index, 0, vs::numVertex)) return vs::vertexes[$index];
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * 修改一个顶点。
		 * 
		 * @param $vertex:Point 新的顶点数据。
		 * @param $index:uint 要修改的序号。
		 * 
		 */
		public function modifyCtrl($ctrl:Point, $index:int):void
		{
			if (MathUtil.range($index, 0, vs::numCtrls))
				vs::ctrls[$index].copyFrom($ctrl);
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * 删除一个顶点。
		 * 
		 * @param $index:uint 序号。
		 * 
		 */
		public function removeCtrl($index:uint):void
		{
			if (MathUtil.range($index, 0, vs::numCtrls))
			{
				vs::ctrls.splice($index, 1);
				vs::numCtrls = vs::ctrls.length;
			}
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IGeom2D#transform()
		 */
		override public function transform($matrix:Matrix):void
		{
			vs::start.copyFrom($matrix.transformPoint(vs::start));
			vs::end  .copyFrom($matrix.transformPoint(vs::end));
			for each (var ctrl:Point in vs::ctrls)
				ctrl.copyFrom($matrix.transformPoint(ctrl));
		}
		
		
		/**
		 * 起始点。
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
				vs::start.copyFrom($value);
		}
		
		
		/**
		 * 终止点。
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
				vs::end.copyFrom($value);
		}
		
		
		/**
		 * 控制点数组。
		 */
		public function get ctrls():Array
		{
			return vs::ctrls;
		}
		
		
		/**
		 * 多边形顶点个数。
		 */
		public function get numCtrls():uint
		{
			return vs::numCtrls;
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
		vs var ctrls:Array;
		
		/**
		 * @private
		 */
		vs var numCtrls:uint;
		
	}
}