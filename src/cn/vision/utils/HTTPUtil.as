package cn.vision.utils
{
	
	/**
	 * 
	 * 定义了一些URI验证相关函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	import cn.vision.core.NoInstance;
	
	public final class HTTPUtil extends NoInstance
	{
		
		/**
		 * 
		 * 验证2个HTTP协议URI是否同一地址。
		 * <p>
		 * 如：http://www.baidu.com和http://www.baidu.com/和http://www.baidu.com/#
		 * </p>
		 * 
		 * @param $uri1:String 第一个地址。
		 * @param $uri2:String 另外一个地址。
		 * 
		 * @return Boolean true则是同一地址，false则不是同一地址。
		 * 
		 */
		
		public static function validateIdentical($uri1:String, $uri2:String):Boolean
		{
			$uri1 = normalize($uri1);
			$uri2 = normalize($uri2);
			if ($uri1 != $uri2)
			{
				if ($uri1 && $uri2)
				{
					var cur:String = $uri1.length < $uri2.length ? $uri1 : $uri2;
					var aim:String = $uri1.length < $uri2.length ? $uri2 : $uri1;
					if (aim.substr(0, cur.length) == cur)
					{
						var tmp:String = aim.substr(cur.length);
						var reg:RegExp = /(\\|\/)?#*$/g;
						var arr:Array = tmp.match(reg);
						var result:Boolean = arr.length > 0 && arr[0] != "";
					}
				}
			}
			else result = true;
			return result;
		}
		
		
		/**
		 * 
		 * 规范化url。
		 * 
		 * @param $url:String 
		 * 
		 */
		
		public static function normalize($url:String):String
		{
			return ($url && $url.indexOf("http") != 0) ? "http://" + $url : $url;
		}
		
	}
}