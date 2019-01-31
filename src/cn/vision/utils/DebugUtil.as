package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	
	/**
	 * 
	 * DebugUtil定义了一些测试常用函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class DebugUtil extends NoInstance
	{
		
		/**
		 * 
		 * 执行函数。
		 * 
		 * @param $func:Function 执行的函数。
		 * @param $args 执行函数的参数。
		 * 
		 * @return * 当调用函数有返回值时，返回调用函数指定的值。
		 * 
		 */
		
		public static function execute($func:Function, $print:Boolean = true, ...$args):*
		{
			try 
			{
				var result:* = $func.apply(null, $args);
			}
			catch (e:Error) 
			{
				$print && trace(e.getStackTrace());
			}
			return result;
		}
		
	}
}