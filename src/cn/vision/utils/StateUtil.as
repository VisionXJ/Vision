package cn.vision.utils
{
	
	/**
	 * 
	 * 定义了状态内部使用的一些常用方法。
	 * 
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.core.vs;
	import cn.vision.core.State;
	import cn.vision.collections.Holder;
	
	
	public final class StateUtil extends NoInstance
	{
		
		/**
		 * 
		 * 从状态商店中找出并冻结一个状态，内部方法，外部不可调用。
		 * 
		 * @param $name:String 名称。
		 * @param $store:Store 状态商店。
		 * 
		 */
		
		vs static function freezeState($name:String, $store:Holder):void
		{
			var state:State = $store.retrieveData($name);
			if (state) state.freeze();
		}
		
		
		/**
		 * 
		 * 从状态商店中找出并激活一个状态，内部方法，外部不可调用。
		 * 
		 * @param $name:String 名称。
		 * @param $store:Store 状态商店。
		 * 
		 */
		
		vs static function activeState($name:String, $store:Holder):void
		{
			var state:State = $store.retrieveData($name);
			if (state) state.active();
		}
		
		/**
		 * 
		 * 切换状态，从状态商店中找出上一个状态与当前状态，冻结上一个状态，
		 * 并激活当前状态，内部方法，外部不可调用。
		 * 
		 * @param $old:String 上一个状态名称。
		 * @param $new:String 新状态名称。
		 * @param $store:Store 状态商店。
		 * 
		 */
		
		vs static function changeState($old:String, $new:String, $store:Holder):void
		{
			var oldState:State = $store.retrieveData($old);
			var newState:State = $store.retrieveData($new);
			if (oldState) oldState.freeze();
			if (newState) newState.active();
		}
	}
}