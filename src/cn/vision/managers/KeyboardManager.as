package cn.vision.managers
{
	
	/**
	 * 
	 * 快捷键管理器。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.errors.SingleTonError;
	import cn.vision.system.Callback;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public final class KeyboardManager extends Manager
	{
		
		/**
		 * 
		 * <code>MPCConfig</code>构造函数。
		 * 
		 */
		
		public function KeyboardManager()
		{
			if(!keyboardManager)
			{
				super();
			}
			else throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 初始化舞台，为舞台添加键盘侦听。
		 * 
		 */
		
		public function initialize($stage:Stage):void
		{
			if(!stage && $stage)
			{
				stage = $stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, handlerKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, handlerKeyUp);
				sequenceMap = {};
				parallelMap = {};
				orderMap = {};
				funckeysArr.length = 0;
				funckeysMap = {};
			}
		}
		
		
		/**
		 * 
		 * 清除舞台，移除所有舞台的键盘侦听。
		 * 
		 */
		
		public function clear():void
		{
			if (stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, handlerKeyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, handlerKeyUp);
				parallelMap = sequenceMap = orderMap = stage = null;
			}
		}
		
		
		/**
		 * 
		 * 注册快捷键控制，如果已存在相关快捷键的控制，则原有的控制会被覆盖。
		 * 
		 * @param $handler:Function 对应的回调。
		 * @param $keys:Array 相关功能按键编码数组，16，17，18为ctrl，shfit，alt功能键，
		 * 如16，17，63代表先按shift，后按ctrl，再按A，如$order为false，
		 * 则按键顺序会被忽略，最多输入4个，重复的功能按键代码，多余的都会被忽略，如16，17，
		 * 17，18，63会被视为16, 17, 18，63。
		 * @param $order:Boolean (default = false) 一个标记，指定功能按键是否有先后顺序。
		 * @param $args 
		 * 
		 */
		
		public function registControl($handler:Function, $keys:Array, $order:Boolean = false, ...$args):void
		{
			var callback:Callback = new Callback($handler, $args);
			if (callback.available)
			{
				var tmp:Array = filter($keys);
				var key:uint = tmp[tmp.length - 1] > 18 ? tmp.pop() : 0;
				if (key)
				{
					var odr:Array = setOrder(key, tmp, $order);
					var map:Object = $order ? sequenceMap : parallelMap;
					map[getKey(key, $order ? tmp : odr)] = callback;
				}
			}
		}
		
		
		/**
		 * 
		 * 删除已注册的快捷键控制。
		 * 
		 * @param $keyCode:uint 按键编码。
		 * @param $order:Boolean (default = false) 一个标记，指定功能按键是否有先后顺序。
		 * @param $args 相关功能按键，如16，17代表先按shift，后按ctrl，如$order为false，
		 * 则按键顺序会被忽略，最多输入3个，重复的功能按键代码，多余的都会被忽略，如16，17，
		 * 17，18，63会被视为16，17，18，63。
		 * 
		 */
		
		public function removeControl($keyCode:uint, $order:Boolean = false, ...$args):void
		{
			var tmp:Array = filter($args);
			var odr:Array = setOrder($keyCode, tmp, $order);
			var map:Object = $order ? sequenceMap : parallelMap;
			delete map[getKey($keyCode, $order ? tmp : odr)];
		}
		
		
		/**
		 * @private
		 */
		private function getKey($keyCode:uint, $args:Array):String
		{
			var key:String = "";
			for each (var item:uint in $args) 
				key += (key == "") ? item : "-" + item;
			key += "-" + $keyCode.toString();
			return key;
		}
		
		/**
		 * @private
		 */
		private function getOrder($keyCode:uint, $args:Array):Boolean
		{
			var temp:Array = $args.concat();
			temp.sort(Array.NUMERIC);
			return orderMap[getKey($keyCode, temp)];
		}
		
		/**
		 * @private
		 */
		private function setOrder($keyCode:uint, $args:Array, $order:Boolean):Array
		{
			var temp:Array = $args.concat();
			temp.sort(Array.NUMERIC);
			orderMap[getKey($keyCode, temp)] = $order;
			return temp;
		}
		
		/**
		 * @private
		 */
		private function filter($array:Array):Array
		{
			var result:Array = [];
			var a:Object = {};
			for each (var item:uint in $array) 
			{
				if(!a[item]) 
				{
					a[item] = true;
					result[result.length] = item;
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function processFuncKeys($keyCode:uint, 
										 $ctrl:Boolean, 
										 $shift:Boolean, 
										 $alt:Boolean, 
										 $up:Boolean = false):void
		{
			if ($keyCode > 15 && $keyCode < 19)
			{
				processFuncKey($ctrl , Keyboard.CONTROL  , $keyCode);
				processFuncKey($shift, Keyboard.SHIFT    , $keyCode);
				processFuncKey($alt  , Keyboard.ALTERNATE, $keyCode);
			}
			else if ($up)
			{
				processHandler($keyCode);
			}
		}
		
		/**
		 * @private
		 */
		private function processFuncKey($down:Boolean, $funcKey:uint, $keyCode:uint):void
		{
			if ($funcKey == $keyCode)
			{
				if ($down)
				{
					if(!funckeysMap[$keyCode])
					{
						funckeysMap[$keyCode] = true;
						funckeysArr[funckeysArr.length] = $keyCode;
					}
				}
				else
				{
					if (funckeysMap[$keyCode])
					{
						funckeysMap[$keyCode] = false;
						var index:int = funckeysArr.indexOf($keyCode);
						if (index > -1) funckeysArr.splice(index, 1);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function processHandler($keyCode:uint):void
		{
			var odr:Boolean = getOrder($keyCode, funckeysArr);
			var tmp:Array = odr ? funckeysArr : funckeysArr.concat();
			if(!odr) tmp.sort(Array.NUMERIC);
			var key:String = getKey($keyCode, tmp);
			var map:Object = odr ? sequenceMap : parallelMap;
			if (map[key]) map[key].call();
		}
		
		
		/**
		 * @private
		 */
		private function handlerKeyDown($e:KeyboardEvent):void
		{
			processFuncKeys($e.keyCode, $e.ctrlKey, $e.shiftKey, $e.altKey);
		}
		
		/**
		 * @private
		 */
		private function handlerKeyUp($e:KeyboardEvent):void
		{
			processFuncKeys($e.keyCode, $e.ctrlKey, $e.shiftKey, $e.altKey, true);
		}
		
		
		/**
		 * @private
		 */
		private var stage:Stage;
		
		/**
		 * @private
		 */
		private var sequenceMap:Object;
		
		/**
		 * @private
		 */
		private var parallelMap:Object;
		
		/**
		 * @private
		 */
		private var orderMap:Object;
		
		
		/**
		 * @private
		 */
		private var funckeysArr:Array = [];
		
		/**
		 * @private
		 */
		private var funckeysMap:Object = {};
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const keyboardManager:KeyboardManager = new KeyboardManager;
		
	}
}