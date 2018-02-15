package cn.vision.utils
{
	
	/**
	 * 
	 * 舞台工具类。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.Sprite;
	
	
	public final class StageUtil extends NoInstance
	{
		
		/**
		 * 
		 * 初始化一个舞台实例。
		 * 
		 * @param $app:Sprite 需要初始化的实例。
		 * @param handler:Function 回调函数。
		 * @param ...args handler的参数。
		 * 
		 */
		
		public static function init($app:Sprite, $handler:Function, ...$args):void
		{
			new App($app, $handler, $args);
		}
		
	}
}


/**
 * 
 * App实例包外类。
 * 
 */


import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;


final class App
{
	
	/**
	 * 
	 * 构造函数。
	 * 
	 */
	
	public function App($app:Sprite, $handler:Function, $args:Array)
	{
		app     = $app;
		handler = $handler;
		args    = $args;
		
		check();
	}
	
	
	/**
	 * @private
	 */
	private function check():void
	{
		if (app.stage)
		{
			if (stage)
			{
				assignStageWH();
				addEnterFrame();
				addResize();
				addTimer();
			}
			else
			{
				complyHandler();
			}
		}
		else
		{
			app.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
	}
	
	/**
	 * @private
	 */
	private function addEnterFrame():void
	{
		app.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
	}
	
	/**
	 * @private
	 */
	private function addResize():void
	{
		app.stage.addEventListener(Event.RESIZE, handlerResize);
	}
	
	/**
	 * @private
	 */
	private function addTimer():void
	{
		timer = new Timer(33);
		timer.addEventListener(TimerEvent.TIMER, handlerTimer);
		timer.start();
	}
	
	/**
	 * @private
	 */
	private function delEnterFrame():void
	{
		app.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
	}
	
	/**
	 * @private
	 */
	private function delResize():void
	{
		app.stage.removeEventListener(Event.RESIZE, handlerResize);
	}
	
	/**
	 * @private
	 */
	private function delTimer():void
	{
		timer.removeEventListener(TimerEvent.TIMER, handlerTimer);
		timer.stop();
		timer = null;
	}
	
	/**
	 * @private
	 */
	private function assignStageWH():void
	{
		stageWidth  = app.stage.stageWidth;
		stageHeight = app.stage.stageHeight;
	}
	
	/**
	 * @private
	 */
	private function complyHandler():void
	{
		stage = false;
		if (handler != null) 
			handler.apply(null, args);
		app     = null;
		handler = null;
		args    = null;
	}
	
	
	/**
	 * @private
	 */
	private function handlerAddedToStage(e:Event):void
	{
		app.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		if (stage)
		{
			assignStageWH();
			addEnterFrame();
			addResize();
			addTimer();
		}
		else
		{
			complyHandler();
		}
	}
	
	/**
	 * @private
	 */
	private function handlerEnterFrame(e:Event):void
	{
		delEnterFrame();
		delTimer();
		delResize();
		complyHandler();
	}
	
	/**
	 * @private
	 */
	private function handlerResize(e:Event):void
	{
		if (stageWidth  && stageWidth  == app.stage.stageWidth && 
			stageHeight && stageHeight == app.stage.stageHeight)
		{
			delEnterFrame();
			delResize();
			delTimer();
			complyHandler();
		}
		assignStageWH();
	}
	
	/**
	 * @private
	 */
	private function handlerTimer(e:TimerEvent):void
	{
		delEnterFrame();
		delTimer();
		delResize();
		complyHandler();
	}
	
	
	/**
	 * @private
	 */
	private static var stage:Boolean = true;
	
	/**
	 * @private
	 */
	private static var stageWidth:Number;
	
	/**
	 * @private
	 */
	private static var stageHeight:Number;
	
	/**
	 * @private
	 */
	private var app:Sprite;
	
	/**
	 * @private
	 */
	private var handler:Function;
	
	/**
	 * @private
	 */
	private var args:Array;
	
	/**
	 * @private
	 */
	private var timer:Timer;
	
}