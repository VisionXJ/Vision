package cn.vision.errors
{
	import cn.vision.consts.ErrorConsts;
	import cn.vision.core.VSError;
	import cn.vision.core.vs;
	
	/**
	 * 索引超出范围异常。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class IndexOutOfRangeError extends VSError
	{
		public function IndexOutOfRangeError()
		{
			super(ErrorConsts.vs::INDEX_OUT_OF_RANGE);
		}
	}
}