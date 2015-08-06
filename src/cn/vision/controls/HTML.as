package cn.vision.controls
{
	import cn.vision.core.UI;
	import cn.vision.core.vs;
	
	import flash.html.HTMLLoader;
	
	use namespace vs;
	public class HTML extends UI
	{
		public function HTML()
		{
			super();
		}
		/******************************************************
		 * create htmlLoader
		 ******************************************************/
		private function createChildren():void
		{
			addChild(htmlLoader = new HTMLLoader);
			
		}
		
		private var htmlLoader:HTMLLoader;
	}
}