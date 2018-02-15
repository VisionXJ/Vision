package cn.vision.consts
{
	
	import cn.vision.core.vs;
	
	
	/**
	 * 定义了一些错误常量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class ErrorConsts extends Consts
	{
		
		/**
		 * 无实例日期参数。
		 */
		vs static const ARGUMENT_DATE:String = "日期参数无效！";
		
		/**
		 * 参数个数错误。
		 */
		vs static const ARGUMENT_NOT_SUB_CLASS:String = "参数 {$self1} 不是 {$self2} 的子类！";
		
		/**
		 * 参数个数错误。
		 */
		vs static const ARGUMENT_NOT_NULL:String = "参数 {$self} 不能为空！";
		
		/**
		 * 参数个数错误。
		 */
		vs static const ARGUMENT_NUM:String = "参数个数不正确，最多为 {$self} 个！";
		
		/**
		 * 无实例类。
		 */
		vs static const CLASS_PATTERN:String = "{$self} 是无实例类，不能实例化！";
		
		/**
		 * 命令未注册。
		 */
		vs static const UNAVAILABLE:String = " {$self} 不可用，请检查需要检测的参数，属性是否合法，符合 available 调用规则！";
		
		/**
		 * 销毁Holder异常，如果不为空，不能销毁。
		 */
		vs static const DESTROY_NOT_EMPTIED:String = "在销毁 {$self} 之前，必须先清空该对象，保证他的 length 为0！";
		
		/**
		 * 正在执行的队列不能被销毁。
		 */
		vs static const DESTROY_QUEUE_EXECUTING:String = "在销毁 {$self} 之前，必须确保队列不在执行！";
		
		/**
		 * 主程序启动异常。
		 */
		vs static const PRESENTER_STARTED_ERROR:String = "{$self} 主程序处理器已启动，不能启动第二个主程序处理器！";
		
		/**
		 * 单例异常。
		 */
		vs static const SINGLE_TON:String = "{$self} 是单例模式，请访问 {$self}.instance 获取 {$self} 的唯一实例！";
		
	}
}