package cn.vision.geom
{
	
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentInvalidError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.errors.IndexOutOfRangeError;
	import cn.vision.errors.PolygonVertexError;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 平面多边形。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Polygon2D extends Geom2D
	{
		
		/**
		 * 构造函数。
		 * 
		 * @copy cn.vision.geom.geom2d.Polygon2D#parse()
		 * 
		 */
		public function Polygon2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * 根据传入的参数进行多边形解析，多边形的顶点个数必须>2。
		 * 
		 * 传入参数有以下几种形式：<br>
		 * 1：传入多个Point参数；<br>
		 * 2：传入Point数组，数组可以是Array或Verter.<Point>。
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			switch ($args.length)
			{
				case 1 : resolveVector($args[0]); break;
				default: resolvePoints($args);
			}
		}
		
		/**
		 * @private
		 */
		private function resolveVector($data:*):void
		{
			if ($data is Vector.<Point>) resolvePoints($data);
			else throw new ArgumentInvalidError;
		}
		
		/**
		 * @private
		 */
		private function resolvePoints($data:*):void
		{
			vs::vertexes.length = 0;
			for each(var p:Point in $data) 
			{
				if((numVertexes > 0 && !vs::vertexes[numVertexes - 1].equals(p)) ||
					numVertexes == 0) 
					vs::vertexes[numVertexes] = p;
			}
			if (vs::vertexes[numVertexes - 1].equals(vs::vertexes[0])) vs::vertexes.pop();
			if (numVertexes < 3) throw new PolygonVertexError;
			
			vs::numVertexes = vs::vertexes.length;
		}
		
		
		/**
		 * 添加一个顶点。
		 * 
		 * @param $vertex:Point 顶点。
		 * @param $index:uint 序号。
		 * 
		 */
		public function addVertex($vertex:Point, $index:uint = uint.MAX_VALUE):void
		{
			$index = MathUtil.clamp($index, 0, vs::numVertex);
			vs::vertexes.splice($index, 0, $vertex);
			vs::numVertex = vs::vertexes.length;
		}
		
		
		/**
		 * 获取一个顶点。
		 * 
		 * @param $index:uint 序号。
		 * 
		 */
		public function getVertex($index:uint):Point
		{
			if (MathUtil.range($index, 0, vs::numVertexes)) return vs::vertexes[$index];
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * 修改一个顶点。
		 * 
		 * @param $vertex:Point 新的顶点数据。
		 * @param $index:uint 要修改的序号。
		 * 
		 */
		public function modifyVertex($vertex:Point, $index:int):void
		{
			if (MathUtil.range($index, 0, vs::numVertex))
				vs::vertexes[$index].copyFrom($vertex);
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * 删除一个顶点。
		 * 
		 * @param $index:uint 序号。
		 * 
		 */
		public function removeVertex($index:uint):void
		{
			if (MathUtil.range($index, 0, vs::numVertex))
			{
				if (vs::numVertex > 3)
				{
					vs::vertexes.splice($index, 1);
					vs::numVertex = vs::vertexes.length;
				}
				else throw new PolygonVertexError;
			}
			else throw new IndexOutOfRangeError;
		}
		
		
		/**
		 * @copy cn.vision.interfaces.IGeom2D#transform()
		 */
		override public function transform($matrix:Matrix):void
		{
			for each (var vertex:Point in vs::vertexes)
				vertex.copyFrom($matrix.transformPoint(vertex));
		}
		
		
		/**
		 * 多边形顶点个数。
		 */
		public function get numVertexes():uint
		{
			return vs::vertexes.length;
		}
		
		
		/**
		 * 多边形顶点数组。
		 */
		public function get vertexes():Array
		{
			var result:Array = [];
			for (var i:int = 0, l:int = vs::vertexes.length; i < l; i++)
				result[i] = vs::vertexes[i].clone();
			return result;
		}
		
		
		/**
		 * @private
		 */
		vs var numVertexes:uint;
		
		/**
		 * @private
		 */
		vs var vertexes:Array = [];
		
	}
}