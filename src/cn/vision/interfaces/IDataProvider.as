package cn.vision.interfaces
{
	public interface IDataProvider extends ILength
	{
		function get dataProvider():Object
		function set dataProvider($value:Object):void
		function get itemRender():Class
		function set itemRender($value:Class):void
	}
}