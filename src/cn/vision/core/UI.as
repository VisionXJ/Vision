package cn.vision.core
{
	
	/**
	 * 
	 * 可视元素的基类。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.consts.state.UIStateConsts;
	import cn.vision.events.StateEvent;
	import cn.vision.interfaces.IEnable;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.interfaces.IState;
	import cn.vision.pattern.data.Store;
	import cn.vision.states.core.ui.*;
	import cn.vision.utils.ClassUtil;
	import cn.vision.utils.IDUtil;
	import cn.vision.utils.StateUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class UI extends Sprite implements IEnable, IExtra, IID, IName, IState
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function UI()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 变量初始化。
		 * 
		 */
		
		protected function initializeVariables():void
		{
			vs::enabled = true;
			vs::state = UIStateConsts.INITIALIZE;
			vs::vid = IDUtil.generateID();
			
			stateStore = new Store;
		}
		
		
		/**
		 * 
		 * 状态初始化。
		 * 
		 */
		
		protected function initializeStates():void
		{
			stateStore.registData(UIStateConsts.INITIALIZE, new UIInitializeState);
			stateStore.registData(UIStateConsts.READY     , new UIReadyState);
		}
		
		
		/**
		 * 
		 * 初始化侦听器。
		 * 
		 */
		
		protected function initializeListeners():void
		{
		}
		
		
		/**
		 * 
		 * 初始化完毕。
		 * 
		 */
		
		protected function initializeComplete():void
		{
			state = UIStateConsts.READY;
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			initializeVariables();
			
			initializeStates();
			
			initializeComplete();
		}
		
		
		/**
		 * @private
		 */
		private function handlerRender($e:Event):void
		{
			trace("ui-render");
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className || (vs::className = ClassUtil.getClassName(this));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get enabled():Boolean
		{
			return Boolean(vs::enabled);
		}
		
		/**
		 * @private
		 */
		public function set enabled($value:Boolean):void
		{
			vs::enabled = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get extra():Object
		{
			return vs::extra || (vs::extra = {});
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get instanceName():String
		{
			return vs::instanceName;
		}
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::instanceName = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get lastState():String
		{
			return vs::lastState;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get state():String
		{
			return vs::state;
		}
		
		/**
		 * @private
		 */
		public function set state($value:String):void
		{
			if ($value != vs::state)
			{
				vs::lastState = vs::state;
				vs::state = $value;
				
				//冻结上一个状态并激活当前状态
				StateUtil.vs::changeState(lastState, state, stateStore);
				
				dispatchEvent(new StateEvent(StateEvent.STATE_CHANGE, vs::lastState, vs::state));
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get vid():uint
		{
			return vs::vid;
		}
		
		
		/**
		 * @private
		 */
		protected var stateStore:Store;
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var enabled:Boolean;
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var instanceName:String;
		
		/**
		 * @private
		 */
		vs var lastState:String;
		
		/**
		 * @private
		 */
		vs var state:String;
		
		/**
		 * @private
		 */
		vs var vid:uint;
		
	}
}
