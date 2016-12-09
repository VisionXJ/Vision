package cn.vision.utils
{
	
	/**
	 * 
	 * 定义了一些日期常用工具函数。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.errors.DateArgumentError;
	
	
	public final class DateUtil extends NoInstance
	{
		
		/**
		 * 
		 * 比较2个日期年月日的大小，只会比较年月日，不会比较时分秒。<br>
		 * 
		 * @param $date1:Date 第一个日期。
		 * @param $date2:Date 第二个日期。
		 * 
		 * @return int 值为 -1，$date1 早于 $date2；值为 0，$date1 等于 $date2；值为1，$date1 晚于 $date2。
		 * 
		 */
		
		public static function compareDate($date1:Date, $date2:Date):int
		{
			var v1:Boolean = validate($date1);
			var v2:Boolean = validate($date2);
			if (v1 && v2)
			{
				var result:int   = MathUtil.compare($date1.fullYear, $date2.fullYear);
				result = result || MathUtil.compare($date1.month   , $date2.month);
				result = result || MathUtil.compare($date1.date    , $date2.date);
			}
			else
			{
				throw new DateArgumentError;
			}
			return result;
		}
	
		
		
		/**
		 * 
		 * 比较2个日期年月日的大小，只会比较年月日，不会比较时分秒。<br>
		 * <br>
		 * 特别地，该方法允许$date1是一个非时间格式。如此，则表示为无限期。即直接返回为1。(一般为EndDate)
		 * 
		 * @param $date1:Date 第一个日期。可以非时间格式，但会被解析为无限期。
		 * @param $date2:Date 第二个日期。且必须为时间格式。
		 * 
		 * @return int 值为 -1，$date1 早于 $date2；值为 0，$date1 等于 $date2；值为1，$date1 晚于 $date2。
		 * 
		 */
		
		public static function compareDate_SP($date1:Date, $date2:Date):int
		{
			var v1:Boolean = validate($date1);
			var v2:Boolean = validate($date2);
			
			if (!v1) return 1;    //如果v1非时间类型，则表示无限期。
			else if (v2)
			{
				var result:int   = MathUtil.compare($date1.fullYear, $date2.fullYear);
				result = result || MathUtil.compare($date1.month   , $date2.month);
				result = result || MathUtil.compare($date1.date    , $date2.date);
			}
			else
			{
				throw new DateArgumentError;
			}
			return result;
		}
		
		
		/**
		 * 
		 * 比较2个日期时分秒的大小，只会比较时分秒，不会比较年月日。<br>
		 * 
		 * @param $date1:Date 第一个日期。
		 * @param $date2:Date 第二个日期。
		 * 
		 * @return int 值为 -1，$date1 小于 $date2；值为 0，$date1 等于 $date2；值为1，$date1 大于 $date2。
		 * 
		 */
		
		public static function compareTime($date1:Date, $date2:Date):int
		{
			var v1:Boolean = validate($date1);
			var v2:Boolean = validate($date2);
			if (v1 && v2)
			{
				var result:int   = MathUtil.compare($date1.hours  , $date2.hours);
				result = result || MathUtil.compare($date1.minutes, $date2.minutes);
				result = result || MathUtil.compare($date1.seconds, $date2.seconds);
			}
			else
			{
				result = v1 ? 1 : (v2 ? -1 : 0);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 比较2个日期大小。
		 * 
		 * @param $date1:Date 第一个日期。
		 * @param $date2:Date 第二个日期。
		 * 
		 * @return int 值为 -1，$date1 小于 $date2；值为 0，$date1 等于 $date2；值为1，$date1 大于 $date2。
		 * 
		 */
		
		public static function compare($date1:Date, $date2:Date):int
		{
			var v1:Boolean = validate($date1);
			var v2:Boolean = validate($date2);
			return v1 && v2
				? ($date1 < $date2 ? -1 : ($date2 < $date1  ? 1 : 0))
				: (v1 ? 1 : (v2 ? -1 : 0));
		}
		
		
		/**
		 * 
		 * 复制一个日期。
		 * 
		 * @param $date:Date 需要复制的日期。
		 * 
		 * @return Date 复制日期的拷贝。
		 * 
		 */
		
		public static function clone($date:Date):Date
		{
			return $date ? new Date($date.toString()) : null;
		}
		
		
		/**
		 * 
		 * 获取某日期是本月的第几周。
		 * 
		 * @param $date:Date 要判断的日期。
		 * @param $startDay:uint (default = 0) 以周几开始记为一周，0代表周日，1代表周一，以此类推。
		 * 
		 * @return uint 第几周。
		 * 
		 */
		
		public static function getWeekOfMonth($date:Date, $startDay:uint = 0):uint
		{
			if ($date.date == 1) 
			{
				var result:uint = 1;
			}
			else
			{
				var temp:Date = new Date($date.fullYear, $date.month, 1);
				var day:int = temp.day - ($startDay % 7);
				day = day < 0 ? day + 7 : day;
				var days:uint = 7 - (day + 1);
				var aday:int = $date.date + 7 - days;
				result = ($date.date <= days) 
					? 1 : aday / 7 + (aday % 7 > 0 ? 1 : 0);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 获取日期时间字符串。
		 * 
		 * @param $date:Date 日期数据。
		 * @param $time:Boolean (default = true) 是否附带时间
		 * @param $charLength:uint = 1 每个字符的位数，大于1时，如果字符长度不够，会在前面加0，如2000-01-04
		 * @param $dateSep:String (default = "-") 日期连接分隔符，如2000-10-23
		 * @param $join:String (default = " ") 日期与时间之间的连接符
		 * @param $timeSep:String (default = ":") 时间连接符，如：12:12:23
		 * 
		 * @return String 日期时间字符串
		 * 
		 */
		
		public static function getDateFormat($date:Date, $time:Boolean = true, $charLength:uint = 1, $dateSep:String = "-", $join:String = " ", $timeSep:String = ":"):String
		{
			$charLength = MathUtil.clamp($charLength, 1, 2);
			var result:String = "";
			result += StringUtil.formatUint($date.fullYear, $charLength) + $dateSep;
			result += StringUtil.formatUint($date.month   , $charLength) + $dateSep;
			result += StringUtil.formatUint($date.date    , $charLength);
			
			if ($time)
			{
				result += $join;
				result += StringUtil.formatUint($date.hours  , $charLength) + $timeSep;
				result += StringUtil.formatUint($date.minutes, $charLength) + $timeSep;
				result += StringUtil.formatUint($date.seconds, $charLength);
			}
			return result;
		}
		
		
		/**
		 * 
		 * 验证日期是否合法。
		 * 
		 * @param $date:Date 需要验证的日期。
		 * 
		 * @return Boolean true为合法，false为不合法。
		 * 
		 */
		
		public static function validate($date:Date):Boolean
		{
			return $date && ($date.toString() != "Invalid Date");
		}
		
	}
}