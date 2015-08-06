package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	public final class NetUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取第$index块网络接口的信息。
		 * 
		 * @param $index:uint 需要获取的网络接口序号，从0开始。
		 * 
		 * @return NetworkInterface 返回的网络接口信息
		 * 
		 */
		
		public static function getNetworkInterface($index:uint = 0):NetworkInterface
		{
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			var l:uint = interfaces.length;
			$index = MathUtil.clamp($index, 0, l);
			return l ? NetworkInfo.networkInfo.findInterfaces()[$index] : null;
		}
	}
}