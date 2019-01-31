package cn.vision.managers
{
	
	/**
	 * 字体管理器。
	 * 
	 * 
	 */
	public final class FontManager extends Manager
	{
		public static function registFont($source:String, $fontName:String):void
		{
			if(!LOADERS[$source])
				LOADERS[$source] = new FontLoader($source, $fontName);
		}
		
		private static var LOADERS:Object = {};
	}
}
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.text.Font;

class FontLoader extends flash.display.Loader
{
	public function FontLoader($source:String = null, $fontName:String = null)
	{
		super();
		
		if ($source && $fontName)
			loadFont($source, $fontName);
	}
	
	
	public function loadFont($source:String, $fontName:String):void
	{
		fontName = $fontName;
		contentLoaderInfo.addEventListener(Event.COMPLETE, loader_defaultHandler);
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_defaultHandler);
		load(new URLRequest($source), new LoaderContext);
	}
	
	private function loader_defaultHandler(e:Event):void
	{
		contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_defaultHandler);
		contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_defaultHandler);
		if (e.type == Event.COMPLETE)
		{
			var font:Class = e.target[fontName];
			if (font) Font.registerFont(font);
		}
	}
	
	private var fontName:String;
	
}