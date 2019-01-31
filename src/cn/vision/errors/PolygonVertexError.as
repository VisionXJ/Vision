package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * 多边形顶点个数异常，当构建多边形传入顶点参数个数不正确时引发。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class PolygonVertexError extends VSError
	{
		public function PolygonVertexError()
		{
			super(ErrorConsts.vs::POLYGON_VERTEX);
		}
		
	}
}