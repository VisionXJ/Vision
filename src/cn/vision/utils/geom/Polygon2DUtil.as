package cn.vision.utils.geom
{
	import cn.vision.consts.MathConsts;
	import cn.vision.core.NoInstance;
	import cn.vision.geom.Line2D;
	import cn.vision.geom.Polygon2D;
	import cn.vision.geom.Vector2D;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.ObjectUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 定义了一些多边形函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Polygon2DUtil extends NoInstance
	{
		
		/**
		 * 求多边形的面积。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * 
		 * @return Number 多边形面积。
		 * 
		 */
		public static function acreage($polygon:Polygon2D):Number
		{
			return Math.abs(clockAcreage($polygon));
		}
		
		
		/**
		 * 获取多边形包围盒。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * 
		 * @return Rectangle 包围盒矩形。
		 * 
		 */
		public static function bounds($polygon:Polygon2D):Rectangle
		{
			var minX:Number = Number.MAX_VALUE, minY:Number = Number.MAX_VALUE;
			var maxX:Number = Number.MIN_VALUE, maxY:Number = Number.MIN_VALUE;
			for each (var point:Point in $polygon.vertexes)
			{
				minX = Math.min(minX, point.x);
				minY = Math.min(minY, point.y);
				maxX = Math.max(maxX, point.x);
				maxY = Math.max(maxY, point.y);
			}
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		
		/**
		 * 判断多边形点集是否按顺时针排列。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * 
		 * @return Boolean true 为顺时针。
		 * 
		 */
		public static function clockwise($polygon:Polygon2D):Boolean
		{
			return clockAcreage($polygon) > 0;
		}
		
		/**
		 * @private
		 */
		private static function clockAcreage($polygon:Polygon2D):Number
		{
			var i:int = 1, l:int = $polygon.numVertexes, vertexes:Array = $polygon.vertexes;
			var area:Number = vertexes[0].y * (vertexes[l - 1].x - vertexes[1].x);
			for(i; i < l; i++) area += vertexes[i].y * (vertexes[i - 1].x - vertexes[(i + 1) % l].x);
			return .5 * area;
		}
		
		
		/**
		 * 返回一个正凸多边形。
		 * 
		 * @param $radiusX:Number X半径。
		 * @param $radiusY:Number Y半径。
		 * @param $offsetRadian:Number (default = 0) 初始点与X轴的夹角，弧度为单位，默认为0。
		 * @param $x:Number (default = 0) 中心点X坐标，默认为0。
		 * @param $y:Number (default = 0) 中心点Y坐标，默认为0。
		 * @param $numVertexes:uint (default = 4) 顶点个数，默认为4。
		 * @param $clockwise:Boolean (default = false) 是否为顺时针，默认为false。
		 * 
		 */
		public static function convex(
			$radiusX:Number, 
			$radiusY:Number, 
			$offsetRadian:Number = 0, 
			$x:Number = 0, 
			$y:Number = 0, 
			$numVertexes:uint = 4,
			$clockwise:Boolean = false):Polygon2D
		{
			$numVertexes = Math.max(3, $numVertexes);
			const split:Number = Math.PI * 2 / $numVertexes;
			var vertexes:Array = [];
			var radian:Number = $offsetRadian, i:int = 0;
			for (; i < $numVertexes; i++)
			{
				radian = $offsetRadian + split * ($clockwise ? i : -i);
				vertexes[vertexes.length] = new Point(
					$x + Math.cos(radian) * $radiusX,
					$y + Math.sin(radian) * $radiusY);
			}
			return new Polygon2D(vertexes);
		}
		
		
		/**
		 * 返回一个矩形。
		 * 
		 * @param $width:Number 宽度。
		 * @param $height:Number 高度。
		 * @param $x:Number (default = 0) 中心点X坐标，默认为0。
		 * @param $y:Number (default = 0) 中心点Y坐标，默认为0。
		 * @param $clockwise:Boolean (default = false) 是否为顺时针，默认为false。
		 * 
		 */
		public static function rect($width:Number, $height:Number, $x:Number = 0, $y:Number = 0, $clockwise:Boolean = false):Polygon2D
		{
			const hw:Number = .5 * $width;
			const hh:Number = .5 * $height;
			const minX:Number = $x - hw, minY:Number = $y - hh;
			const maxX:Number = $x + hw, maxY:Number = $y + hh;
			return new Polygon2D(
				new Point(minX, maxY), new Point(minX, minY), 
				new Point(maxX, minY), new Point(maxX, maxY));
		}
		
		
		/**
		 * 多边形扩张或缩小一定厚度，并返回一个新的多边形。<br>
		 * 当多边形为顺时针时，厚度为正数，表示向内缩小，为逆时针时，厚度为正数，表示向外扩张。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * @param $thickness:Number 厚度。
		 * 
		 */
		public static function increase($polygon:Polygon2D, $thickness:Number):Polygon2D
		{
			var vertexes:Array = $polygon.vertexes, vectors:Array = [];
			var i:int, l:int = vertexes.length;
			for (i = 0; i < l; i++)
			{
				var v:Vector2D = new Vector2D(vertexes[i], i == l - 1 ? vertexes[0] : vertexes[i + 1]);
				var t:Vector2D = v.clone();
				t.angle += MathConsts.PI_2;
				t.length = $thickness;
				Geom2DUtil.move(v, t.u, t.v);
				vectors[i] = v;
			}
			vertexes.length = 0;
			for (i = 0; i < l; i++)
			{
				
				var vf:Vector2D = vectors[i == 0 ? l - 1 : i - 1];
				var vb:Vector2D = vectors[i];
				vertexes[i] = Line2DUtil.intersect(vf, vb);
				
				if (!vertexes[i]) vertexes[i] = vb.start;
			}
			return new Polygon2D(vertexes);
		}
		
		
		/**
		 * 多边形与直线的交点。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * @param $line:Line2D 直线。
		 * 
		 * @return * 返回值如下：<br>
		 * 1. 如返回null，代表没有交点；<br>
		 * 2. 返回一个Object，表示直线经过多变行的其中一个顶点，包含x，y坐标属性及棱的序号index；<br>
		 * 3. 返回Array，表示直线与多边形相交，数组元素为Object，包含x，y，和棱序号index。<br>
		 * 
		 */
		public static function intersectLine($polygon:Polygon2D, $line:Line2D):*
		{
			return intersectLineOrSegment($polygon, Line2DUtil.intersectSegment, $line);
		}
		
		
		/**
		 * 多边形与线段的交点。
		 * 
		 * @param $polygon:Polygon2D 多边形。
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * 
		 * @return * 返回值如下：<br>
		 * 1. 如返回null，代表没有交点；<br>
		 * 2. 返回一个Object，表示直线经过多变行的其中一个顶点，包含x，y坐标属性及棱的序号index；<br>
		 * 3. 返回Array，表示直线与多边形相交，数组元素为Object，包含x，y，和棱序号index。<br>
		 * 
		 */
		public static function intersectSegment($polygon:Polygon2D, $a:Point, $b:Point):*
		{
			return intersectLineOrSegment($polygon, Segment2DUtil.intersect, $a, $b);
		}
		
		/**
		 * @private
		 */
		private static function intersectLineOrSegment($polygon:Polygon2D, $handler:Function, ...$args):*
		{
			var temp:Object = {}, point:Point, curr:Object, last:Object, result:*, vertexes:Array = $polygon.vertexes, args:Array;
			for (var i:int = 0, l:int = $polygon.numVertexes; i < l; i++)
			{
				args = $args.concat();
				ArrayUtil.push(args, vertexes[i], vertexes[i == l - 1 ? 0 : i + 1]);
				point = $handler.apply(null, args);
				if (point)
				{
					curr = {x:point.x, y:point.y, p:point, index:i};
					if(!ObjectUtil.compare(curr, last))
						ObjectUtil.push(temp, "points", curr);
				}
				last = curr;
			}
			result = temp.points;
			if (result is Array) result.sortOn("x", Array.NUMERIC);
			delete temp.points;
			temp = null;
			return result;
		}
		
		
		/**
		 * 检测2个多边形的关系。<br>
		 * 0：不相交；1：相交；2：a包含b；3：b包含a。
		 * 
		 * @param $a:Polygon2D 第一个多边形的顺时针点集。
		 * @param $b:Polygon2D 第二个多边形的顺时针点集。
		 * 
		 * @return int 关系数值。
		 * 
		 */
		public static function nexus($a:Polygon2D, $b:Polygon2D):int
		{
			var la:int = $a.numVertexes, lb:int = $b.numVertexes;
			var va:Array = $a.vertexes, vb:Array = $b.vertexes;
			var ia:int, ja:int, ib:int, jb:int ;
			for (ia = 0, ja = ia + 1; ia < la - 1, ja < la; ia++, ja++)
			{
				for (ib = 0, jb = ib +1; ib < lb - 1,jb < lb; ib++, jb++)
				{
					if (Segment2DUtil.nexus(va[ia], va[ja], vb[ib], vb[jb])) return 1;
				}
				if(Segment2DUtil.nexus(va[ia],va[ja],vb[0],vb[3])) return 1;
			}
			for(ib = 0, jb = ib + 1; ib < lb - 1, jb < lb; ib++, jb++)
			{
				if (Segment2DUtil.nexus(va[0], va[3], vb[ib], vb[jb])) return 1;
			}
			if (Segment2DUtil.nexus(va[0], va[3], vb[0], vb[3])) return 1;
			if (nexusPoint($a, vb[0]) == 1) return 2;
			else if (nexusPoint($b, va[0]) == 1) return 3;
			return 0;
		}
		
		
		/**
		 * 判断点与多边形的位置关系。<br>
		 * 从当前点往任意方向发出一条射线，判断射线与多边形的边相交的次数，如果是奇数，则表示在多边形内部。
		 * 
		 * @param $polygon:Vector.<Point> 多边形顺时针或逆时针点集。
		 * 
		 * @return int 表明点与多边形位置关系的一个int值<br>
		 * -1 - 点在多边形外部；<br>
		 * 0  - 点在多边形边界；<br>
		 * 1  - 点在多边形内部。<br>
		 * 
		 */
		public static function nexusPoint($polygon:Polygon2D, $p:Point):int
		{
			var i:int, j:int, crossing:int;
			var l:int = $polygon.numVertexes;
			var vertexes:Array = $polygon.vertexes;
			
			//在边界上，返回0
			for (i = 0; i < l; i++)
			{
				if (Segment2DUtil.nexusPoint(vertexes[i], 
					vertexes[i == l - 1 ? 0 : i + 1], $p)) return 0;
			}
			
			//判断在内部或是外部
			for (i = 0, j = l - 1; i < l; j = i++)
			{
				//x[j] < x < x[i] && y0 >= y
				if ((vertexes[i].x >= $p.x) != (vertexes[j].x >= $p.x) && 
					($p.y <= Point2DUtil.slope(vertexes[i], vertexes[j]) * 
						($p.x - vertexes[i].x) + vertexes[i].y)) crossing++;
			}
			return MathUtil.even(crossing) ? -1 : 1;
		}
		
		
		/**
		 * 多边形分割，分割元素为直线。
		 * 
		 * @param $polygon:Polygon2D 被分割的多边形。
		 * @param $line:Line2D 分割的直线。
		 * 
		 * @return Array 分割后的多边形数组.
		 * 
		 */
		public static function splitLine($polygon:Polygon2D, $line:Line2D):Array
		{
			return splitLineOrSegment($polygon, intersectLine, $line);
		}
		
		
		/**
		 * 多边形分割，分割元素为线段。
		 * 
		 * @param $polygon:Polygon2D 被分割的多边形。
		 * @param $a:Point 线段起点。
		 * @param $b:Point 线段终点。
		 * 
		 * @return Array 分割后的多边形数组.
		 * 
		 */
		public static function splitSegment($polygon:Polygon2D, $a:Point, $b:Point):Array
		{
			return splitLineOrSegment($polygon, intersectSegment, $a, $b);
		}
		
		/**
		 * @private
		 */
		private static function splitLineOrSegment($polygon:Polygon2D, $handler:Function, ...$args):Array
		{
			ArrayUtil.unshift($args, $polygon);
			var points:* = $handler.apply(null, $args), p:Point;
			var result:Array = [$polygon], curr:Polygon2D, temp:*;
			var i:int, j:int, l:int, m:int, min:int, max:int;
			var vertexes:Array, obj:Object, p1:Array, p2:Array;
			if (points is Array)
			{
				for (i = 0, l = points.length - 1; i < l; i++)
				{
					//检测线段是否在多边形内部（检测线段的中点是否在多边形内部）
					p = Point.interpolate(points[i].p, points[i + 1].p, .5);
					curr = null;
					for (j = 0, m = result.length; j < m; j++)
					{
						if (nexusPoint(result[j], p) == 1)
						{
							curr = result[j];
							result.splice(j, 1);
							break;
						}
					}
					if (curr)
					{
						temp = curr == $polygon
							? [points[0], points[1]]
							: intersectSegment(curr, points[i].p, points[i + 1].p);
						if (temp.length == 2)
						{
							vertexes = curr.vertexes;
							min = Math.min(temp[0].index, temp[1].index);
							max = Math.max(temp[0].index, temp[1].index);
							obj = {};
							obj[min] = temp[0].index == min ? temp[0] : temp[1];
							obj[max] = temp[0].index == max ? temp[0] : temp[1];
							//第一个多边形
							p1 = vertexes.slice(min + 1, max + 1);
							ArrayUtil.unshift(p1, obj[max].p, obj[min].p);
							//第二个多边形
							p2 = vertexes.concat();
							p2.splice(min + 1, max - min, obj[min].p, obj[max].p);
							ArrayUtil.push(result, new Polygon2D(p1), new Polygon2D(p2));
						}
					}
				}
			}
			return result;
		}
		
	}
}