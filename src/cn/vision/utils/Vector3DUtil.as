package cn.vision.utils
{
	
	/**
	 * 
	 * <code>Vector3DUtil</code>定义了一些Vector3D操作函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.geom.Vector3D;
	
	
	public final class Vector3DUtil extends NoInstance
	{
		
		/**
		 * 
		 * 确定两个指定点之间的点。参数 f 确定新的内插点相对于参数 pt1 和 pt2 
		 * 指定的两个端点所处的位置。参数 f 的值越接近 1.0，则内插点就越接近第
		 * 一个点（参数 pt1）。参数 f 的值越接近 0，则内插点就越接近第二个点（
		 * 参数 pt2）。
		 * 
		 * @param $pt1:Vector3D 第一个点。
		 * @param $pt1:Vector3D 第二个点。
		 * @param $f:Number 两个点之间的内插级别。表示新点将位于 pt1 和 pt2 
		 * 连成的直线上的什么位置。如果 f=1，则返回 pt1；如果 f=0，则返回 pt2。
		 * 
		 * @return Vector3D 两点之间的点。
		 * 
		 */
		
		public static function interpolate($pt1:Vector3D, $pt2:Vector3D, $f:Number):Vector3D
		{
			var v:Vector3D = $pt1.subtract($pt2);
			v.scaleBy($f);
			return v.add($pt2);
		}
		
		/**
		 * 
		 * 返回两个或多个 Vector3D 对象之间的距离。
		 * 
		 * @param $pt1:Vector3D 第一个点。
		 * @param $pt1:Vector3D 第二个点。
		 * @param $args 其余的点。
		 * 
		 * @return Number 距离。
		 * 
		 */
		
		public static function distance($pt1:Vector3D, $pt2:Vector3D, ...$args):Number
		{
			var result:Number = Vector3D.distance($pt1, $pt2);
			var t:Vector3D = $pt2;
			for each (var v:Vector3D in $args)
			{
				result += Vector3D.distance(t, v);
				t = v;
			}
			return result;
		}
		
	}
}