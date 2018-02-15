package cn.vision.geom.plane
{
	import cn.vision.core.vs;
	
	/**
	 * 平面向量。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class Vector2D extends Line
	{
		/**
		 * 构造函数，传入参数并解析成向量，
		 * 如果不传入任何参数，则表示为X轴的单位向量(1, 0)。<br>
		 * 
		 * @copy cn.vision.geom.plane.Vector#parse()
		 * 
		 */
		public function Vector2D(...$args)
		{
			super($args);
		}
		
		
		/**
		 * Vector的解析传入参数有以下方式：<br>
		 * 1：传入起始点，长度，以及与X轴的夹角；<br>
		 * 2：传入起始点，终止点；<br>
		 * 3：传入一个Point；<br>
		 * 4；传入u，v。<br>
		 * 
		 * @param ...$args 传入参数。
		 * 
		 */
		override protected function parse(...$args):void
		{
			
		}
		
		vs var u:Number;
		
		vs var v:Number;
		
	}
}