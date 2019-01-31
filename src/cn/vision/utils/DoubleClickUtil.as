package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * 双击工具，AS3源生双击事件不是很好用，使用此工具辅助。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class DoubleClickUtil extends NoInstance
	{
		
		/**
		 * 为Sprite元素创建双击事件辅助。
		 * 此工具派发的双击鼠标事件不支持冒泡，如果要访问类似冒泡的event.target属性，请访问其属性event.relatedObject。
		 * 
		 * @param $sprite:Sprite
		 * 
		 */
		public static function create($sprite:Sprite):void
		{
			if(!sprites[$sprite])
			{
				$sprite.doubleClickEnabled = false;
				sprites[$sprite] = new DoubleClickHelper($sprite);
				sprites[$sprite].play();
			}
		}
		
		
		/**
		 * 为Sprite元素移除双击事件辅助。
		 * 
		 * @param $sprite:Sprite
		 * 
		 */
		public static function remove($sprite:Sprite):void
		{
			if (sprites[$sprite])
			{
				sprites[$sprite].stop();
				delete sprites[$sprite];
			}
		}
		
		private static var sprites:Dictionary = new Dictionary;
		
	}
}


import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;


class DoubleClickHelper
{
	public function DoubleClickHelper($sprite:Sprite)
	{
		sprite = $sprite;
	}
	
	public function play():void
	{
		sprite.addEventListener(MouseEvent.CLICK, sprite_clickHandler, true, 0, true);
		timer = new Timer(300, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler, false, 0, true);
	}
	
	public function stop():void
	{
		sprite.removeEventListener(MouseEvent.CLICK, sprite_clickHandler, true);
		timer.stop();
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
		timer = null;
	}
	
	private function sprite_clickHandler(e:MouseEvent):void
	{
		if (timer.running)
		{
			e.stopImmediatePropagation();
			timer.stop();
			sprite.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK,
				e.bubbles, e.cancelable, e.localX, e.localY, e.target as InteractiveObject, 
				e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
		}
		else
		{
			timer.reset();
			timer.start();
		}
	}
	
	private function timer_completeHandler(e:TimerEvent):void
	{
		timer.stop();
	}
	
	
	private var sprite:Sprite;
	
	private var timer:Timer;
	
}
