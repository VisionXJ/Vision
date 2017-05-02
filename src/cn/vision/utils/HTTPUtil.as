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
		 * 根据URL获取主域名信息。
		 * 
		 * @param $url:String 
		 * 
		 * @return String 返回主域名字符串。
		 * 
		 */
		
		public static function getDomainName($url:String):String
		{
			if ($url)
			{
				$url = $url.replace("\\", "/");
				$url = $url.toLowerCase();
				var doubleSplit:Array = $url.split("//");
				if (doubleSplit.length)
				{
					$url = doubleSplit[doubleSplit.length - 1];
					var singleSplit:Array = $url.split("/");
					if (singleSplit.length)
					{
						$url = singleSplit[0];
						var colonSplit:Array = $url.split(":");
						if (colonSplit.length)
						{
							$url = colonSplit[0];
							var dotSplit:Array = $url.split(".");
							if (dotSplit.length > 1)
							{
								if (isNaN(dotSplit[dotSplit.length - 1]))
								{
									$url = dotSplit[dotSplit.length - 2] + "." + dotSplit[dotSplit.length - 1];
									if (URLFIX[dotSplit[dotSplit.length - 2]] && 
										URLFIX[dotSplit[dotSplit.length - 1]])
									{
										$url = dotSplit[dotSplit.length - 3] + "." + $url;
									}
								}
								else
								{
									$url = dotSplit.join(".");
								}
							}
						}
					}
				}
			}
			return $url;
		}
		
		
		/**
		 * 
		 * 规范化url。
		 * 
		 * @param $url:String 
		 * 
		 * @return String 返回规范化后的url字符串。
		 * 
		 */
		
		public static function normalize($url:String):String
		{
			return ($url && $url.indexOf("http") != 0) ? "http://" + $url : $url;
		}
		
		
		
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
		 * @private
		 */
		private static const URLFIX:Object = {
			"com" : true, 
			"cn" : true, 
			"edu" : true, 
			"tw" : true, 
			"tv" : true, 
			"org" : true, 
			"net" : true, 
			"gov" : true, 
			"biz" : true, 
			"cc" : true, 
			"info" : true, 
			"us" : true, 
			"asia" : true, 
			"name" : true, 
			"tel" : true,
			"xxx" : true
		};
		
	}
}