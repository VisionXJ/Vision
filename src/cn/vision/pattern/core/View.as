package cn.vision.pattern.core
{
	import cn.vision.core.UI;
	import cn.vision.core.vs;
	
	public class View
	{
		public function View()
		{
			super();
		}
		public function get presenter():Presenter
		{
			return vs::presenter;
		}
		vs var presenter:Presenter;
	}
}