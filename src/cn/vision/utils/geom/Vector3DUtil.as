package cn.vision.utils.geom
{
	import cn.vision.core.NoInstance;
	import cn.vision.utils.ArrayUtil;
	
	import flash.geom.Vector3D;
	
	public class Vector3DUtil extends NoInstance
	{
		
		/**
		 * 返回两个或多个 Vector3D 对象之间的距离，当有多个顶点时，计算每相邻的两个点之间的距离之和。
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
		
		
		/**
		 * 获取三维空间直线上的点集合。
		 * 
		 * @param $start:Vector3D 起始点。
		 * @param $end:Vector3D 结束点。
		 * @param $seg:Number 直线段。
		 * @param $front:Number 开始距离。
		 * @param $back:Number 结束距离。
		 * 
		 * @return Vector.<Vector3D> 点集合。
		 * 
		 */
		public static function getVector3Ds($start:Vector3D, $end:Vector3D, $seg:Number, $front:Number = 0, $back:Number = 0):Vector.<Vector3D>
		{
			const dis:Number = Vector3D.distance($start, $end);
			const per:Number = $seg / (dis - $front - $back);
			const fro:Number = $front / dis;
			const bac:Number = (1 - $back / dis);
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			if (0 < per && per <= 1)
			{
				for (var tmp:Number = fro; tmp < bac; tmp += per)
					ArrayUtil.push(points, interpolate($end, $start, tmp));
			}
			return points;
		}
		
		
		/**
		 * 确定两个指定点之间的点。参数 f 确定新的内插点相对于参数 pt1 和 pt2 指定的两个端点所处的位置。
		 * 参数 f 的值越接近 1，则内插点就越接近第一个点（参数 pt1）。
		 * 参数 f 的值越接近 0，则内插点就越接近第二个点（参数 pt2）。
		 * 
		 * @param $pt1:Vector3D 第一个点。
		 * @param $pt2:Vector3D 第二个点。
		 * @param $f:Number 两个点之间的内插级别。
		 * 表示新点将位于 pt1 和 pt2 连成的直线上的什么位置。
		 * 如果 f=1，则返回 pt1；如果 f=0，则返回 pt2。
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
		
		public static function offset($pt:Vector3D, $offset:Number, $long:Number, $lat:Number):Vector3D
		{
			var xy:Number = $offset * Math.cos($lat);
			var z:Number = $offset * Math.sin($lat);
			var x:Number = xy * Math.cos($long);
			var y:Number = xy * Math.sin($long);
			return $pt.add(new Vector3D(x, y, z));
		}
		
		/**
		 * 计算向量在三维空间绕坐标轴旋转一定角度后 得到的点位置
		 * 
		 * @param $point: 被操作点
		 * @param $axis: 坐标轴
		 * @param $radian:旋转弧度数
		 * 
		 */
		public static function vectorRotate3d($vector:Vector3D,$axis:Vector3D,$radian:Number):Vector3D
		{
			var x_axisVec:Vector3D=new Vector3D(1,0,0);
			var y_axisVec:Vector3D=new Vector3D(0,1,0);
			var z_axisVec:Vector3D=new Vector3D(0,0,1);
			var result:Vector3D;
			switch($axis)
			{
				case x_axisVec:
					result.x = $vector.x*Math.cos($radian) + $vector.y*Math.sin($radian);
					result.y = $vector.x*(-(Math.sin($radian))) + $vector.y*Math.cos($radian);
					result.z = $vector.z;
					break;
				case y_axisVec:
					result.x = $vector.x;
					result.y = $vector.y*Math.cos($radian) + $vector.z*Math.sin($radian);
					result.z = $vector.y*(-(Math.sin($radian))) + $vector.z*Math.cos($radian);
					break;
				case z_axisVec:
					result.x = $vector.x*Math.cos($radian)+$vector.z*(-(Math.sin($radian)));
					result.y = $vector.y;
					result.z = $vector.x * Math.sin($radian) + $vector.z*Math.cos($radian);
			}
			return result;
		}
		
	}
}