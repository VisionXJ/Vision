package cn.vision.utils
{
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.geom.Point2DUtil;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 定义了一些画图函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class GraphicsUtil extends NoInstance
	{
		
		/**
		 * Draw a arc. before drawArc(), you need to call linestyle() to set line style.
		 * you can draw circle eclipse by change param arc, xRadius, yRaidus.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param rotateRadian:Number (default = 0) Rotation of randians, default is 0.
		 * @param arcRadian:Number=0.7853981633974483 randians of arc default is Math.PI / 4.
		 * @param x:Number (default = 0) Center of x, default is 0.
		 * @param y:Number (default = 0) Center of y, default is 0.
		 * @param xRadius:Number (default = 10) Radius of x, default is 20.
		 * @param yRadius:Number (default = 10) Radius of y, default is 20.
		 * 
		 */
		public static function drawArc(
			graphics:Graphics, 
			rotateRadian:Number = 0, 
			arcRadian:Number = 0.7853981633974483, 
			x:Number = 0, 
			y:Number = 0, 
			xRadius:Number = 20,
			yRadius:Number = 20):void
		{
			if (Math.abs(arcRadian) > Math.PI * 2) arcRadian = Math.PI * 2;
			var segs:Number = Math.ceil(Math.abs(arcRadian) / (Math.PI * .25));
			if (segs > 0)
			{
				var theta:Number = arcRadian / segs;
				var angle:Number = rotateRadian, halfAngle:Number;
				graphics.moveTo(
					x + Math.cos(rotateRadian) * xRadius, 
					y + Math.sin(rotateRadian) * yRadius);
				for (var i:int = 0; i<segs; i++)
				{
					angle += theta;
					halfAngle = angle - theta * .5;
					graphics.curveTo(
						x + Math.cos(halfAngle) * (xRadius / Math.cos(theta * .5)), 
						y + Math.sin(halfAngle) * (yRadius / Math.cos(theta * .5)), 
						x + Math.cos(angle) * xRadius, y + Math.sin(angle) * yRadius);
				}
			}
		}
		
		
		/**
		 * 绘制椭圆。
		 * 
		 * @param graphics:Graphics Graphics实例。
		 * @param a:Number 椭圆X半径。
		 * @param b:Number 椭圆Y半径。
		 * @param h:Number (default = 0) 椭圆中心X，默认为0。
		 * @param k:Number (default = 0) 椭圆中心Y，默认为0。
		 * @param angle:Number (default = 0) 椭圆旋转角度。
		 * @param yRadius:Number (default = 10) Radius of y, default is 20.
		 * 
		 */
		public static function drawEllipse(
			graphics:Graphics, 
			a:Number,
			b:Number,
			h:Number = 0,
			k:Number = 0,
			angle:Number = 0
		):void
		{
			var arcRadian:Number = Math.PI * 2;
			var segs:Number = 8;
			var theta:Number = arcRadian / segs;
			var rotate:Number = 0, halfRotate:Number;
			
			var x:Number = h + Math.cos(rotate) * a;
			var y:Number = k + Math.sin(rotate) * b;
			
			const cos:Number = Math.cos(angle);
			const sin:Number = Math.sin(angle);
			
			var sbx:Number = x - h;
			var sby:Number = y - k;
			
			graphics.moveTo(
				sbx * cos - sby * sin + h, 
				sbx * sin + sby * cos + k);
			
			var tx:Number, ty:Number, cx:Number, cy:Number;
			
			for (var i:int = 0; i < segs; i++)
			{
				rotate += theta;
				halfRotate = rotate - theta * .5;
				//curve point
				tx = h + Math.cos(halfRotate) * (a / Math.cos(theta * .5));
				ty = k + Math.sin(halfRotate) * (b / Math.cos(theta * .5));
				sbx = tx - h;
				sby = ty - k;
				cx = sbx * cos - sby * sin + h;
				cy = sbx * sin + sby * cos + k;
				//aim point
				tx = h + Math.cos(rotate) * a;
				ty = k + Math.sin(rotate) * b;
				sbx = tx - h;
				sby = ty - k;
				graphics.curveTo(cx, cy,
					sbx * cos - sby * sin + h,
					sbx * sin + sby * cos + k);
			}
		}
		
		/**
		 * Draw a burst shape. before drawBurst(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param vertex:uint=2 Number of vertex, default is 2，if less than 2，throw <code>ArgumentError</code>.
		 * @param rotateRadian:Number=0 Rotation of randians, default is 0.
		 * @param x:Number=0 Center of shape x，default is 0.
		 * @param y:Number=0 Center of shape y，default is 0.
		 * @param outerXRadius:Number=20 Outer Radius of shape x, default is 20.
		 * @param outerYRadius:Number=20 Outer Radius of shape y, default is 20.
		 * @param innerXRadius:Number=10 Inner Radius of shape x，default is 10.
		 * @param innerYRadius:Number=10 Inner Radius of shape y，default is 10.
		 * 
		 */
		public static function drawBurst(
			graphics:Graphics, 
			vertex:uint = 2, 
			rotateRadian:Number = 0, 
			x:Number = 0, 
			y:Number = 0, 
			outerXRadius:Number = 20, 
			outerYRadius:Number = 20, 
			innerXRadius:Number = 10, 
			innerYRadius:Number = 10):void
		{
			var angle:Number = (Math.PI * 2) / vertex;
			var halfAngle:Number = angle*.5;
			var qtrAngle :Number = angle*.25;
			graphics.moveTo(
				x+(Math.cos(rotateRadian)*outerXRadius), 
				y+(Math.sin(rotateRadian)*outerYRadius));
			for (var i:int=1; i<=vertex; i++) {
				graphics.curveTo(
					x+Math.cos(rotateRadian+(angle*i)-(qtrAngle*3))*(innerXRadius/Math.cos(qtrAngle)), 
					y+Math.sin(rotateRadian+(angle*i)-(qtrAngle*3))*(innerYRadius/Math.cos(qtrAngle)), 
					x+Math.cos(rotateRadian+(angle*i)-halfAngle)*innerXRadius, 
					y+Math.sin(rotateRadian+(angle*i)-halfAngle)*innerYRadius);
				graphics.curveTo(
					x+Math.cos(rotateRadian+(angle*i)-qtrAngle)*(innerXRadius/Math.cos(qtrAngle)), 
					y+Math.sin(rotateRadian+(angle*i)-qtrAngle)*(innerXRadius/Math.cos(qtrAngle)), 
					x+Math.cos(rotateRadian+(angle*i))*outerXRadius, 
					y+Math.sin(rotateRadian+(angle*i))*outerYRadius);
			}
		}
		
		
		/**
		 * 画虚线。
		 * 
		 * @param $graphics:Graphics 需要绘制的Graphics对象。
		 * @param $start:Point 起始点。
		 * @param $end:Point 终止点。
		 * @param $wdith:Number (default = 5) 虚线分段宽度。
		 * @param $grap:Number (default = 5) 虚线间隔。
		 * 
		 */
		public static function drawDash($graphics:Graphics, $start:Point, $end:Point, $wdith:Number = 5, $grap:Number = 5):void
		{
			if (!$graphics || !$start || !$end || $wdith <= 0 || $grap <= 0) return;
			
			var ox:Number = $start.x;
			var oy:Number = $start.y;
			
			var radian:Number = Math.atan2($end.y - oy, $end.x - ox);
			var cos:Number = Math.cos(radian), sin:Number = Math.sin(radian);
			var totalLen:Number = Point.distance($start, $end);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = ox + cos * currLen;
				y = oy + sin * currLen;
				$graphics.moveTo(x, y);
				
				currLen = Math.min(currLen + $wdith, totalLen);
				
				x = ox + cos * currLen;
				y = oy + sin * currLen;
				$graphics.lineTo(x, y);
				
				currLen += $grap;
			}
		}
		
		
		/**
		 * Draw a gear shape. before drawGear(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param gearVertex:uint=2 Number of gear vertex, default is 2，if less than 2，throw <code>ArgumentError</code>.
		 * @param holeVertex:uint=2 Number of hole vertex, default is 2，if less than 2，throw <code>ArgumentError</code>.
		 * @param gearRotateRadians:Number=0 Gear rotation randians, default is 0.
		 * @param holeRotateRadians:Number=0 Hole rotation randians, default is 0.
		 * @param x:Number=0 Center of shape x，default is 0.
		 * @param y:Number=0 Center of shape y，default is 0.
		 * @param outerXRadius:Number=20 Outer Radius of shape x, default is 20.
		 * @param outerYRadius:Number=20 Outer Radius of shape y, default is 20.
		 * @param innerXRadius:Number=10 Inner Radius of shape x，default is 10.
		 * @param innerYRadius:Number=10 Inner Radius of shape y，default is 10.
		 * @param holeXRadius:Number=10 Hole Radius of shape x，default is 5.
		 * @param holeYRadius:Number=10 Hole Radius of shape y，default is 5.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9
		 * @playerversion AIR 1.1
		 * @productversion vision 1.0
		 */
		public static function drawGear(
			graphics:Graphics, 
			gearVertex:uint=2, 
			holeVertex:uint=2, 
			gearRotateRadians:Number=0, 
			holeRotateRadians:Number=0, 
			x:Number=0, 
			y:Number=0, 
			outerXRadius:Number=20, 
			outerYRadius:Number=20, 
			innerXRadius:Number=10, 
			innerYRadius:Number=10, 
			holeXRadius:Number=5, 
			holeYRadius:Number=5):void
		{
			var angle:Number = (Math.PI*2)/gearVertex;
			var qtrAngle:Number = angle/4;
			var btrAngle:Number = angle/8;
			graphics.moveTo(
				x+(Math.cos(gearRotateRadians+btrAngle)*outerXRadius), 
				y+(Math.sin(gearRotateRadians+btrAngle)*outerYRadius));
			for (var i:int=1; i<=gearVertex; i++) {
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-(qtrAngle*3)+btrAngle)*innerXRadius, 
					y+Math.sin(gearRotateRadians+(angle*i)-(qtrAngle*3)+btrAngle)*innerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-(qtrAngle*2)+btrAngle)*innerXRadius, 
					y+Math.sin(gearRotateRadians+(angle*i)-(qtrAngle*2)+btrAngle)*innerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-qtrAngle+btrAngle)*outerXRadius, 
					y+Math.sin(gearRotateRadians+(angle*i)-qtrAngle+btrAngle)*outerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)+btrAngle)*outerXRadius, 
					y+Math.sin(gearRotateRadians+(angle*i)+btrAngle)*outerYRadius);
			}
			angle = (Math.PI*2)/holeVertex;
			graphics.moveTo(
				x+(Math.cos(holeRotateRadians)*holeXRadius), 
				y+(Math.sin(holeRotateRadians)*holeYRadius));
			for (i=1; i<=holeVertex; i++) {
				graphics.lineTo(
					x+Math.cos(holeRotateRadians+(angle*i))*holeXRadius, 
					y+Math.sin(holeRotateRadians+(angle*i))*holeYRadius);
			}
		}
		
		/**
		 * Draw a polygon shape. before drawPolygon(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param vertex:uint=2 Number of vertex, default is 2，if less than 2，throw <code>ArgumentError</code>.
		 * @param rotateRadian:Number=0 Rotation of randians, default is 0.
		 * @param x:Number=0 Center of shape x，default is 0.
		 * @param y:Number=0 Center of shape y，default is 0.
		 * @param xRadius:Number=20 Outer Radius of shape x, default is 20.
		 * @param yRadius:Number=20 Outer Radius of shape y, default is 20.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9
		 * @playerversion AIR 1.1
		 * @productversion vision 1.0
		 */
		public static function drawPolygon(
			graphics:Graphics, 
			vertex:uint=2, 
			rotateRadius:Number=0, 
			x:Number=0, 
			y:Number=0, 
			xRadius:Number=20, 
			yRadius:Number=20):void
		{
			var angle:Number = (Math.PI*2)/vertex;
			graphics.moveTo(
				x+(Math.cos(rotateRadius)*xRadius), 
				y+(Math.sin(rotateRadius)*yRadius));
			for (var i:int=1; i<=vertex; i++) {
				graphics.lineTo(
					x+Math.cos(rotateRadius+(angle*i))*xRadius, 
					y+Math.sin(rotateRadius+(angle*i))*yRadius);
				break;
			}
		}
		
		
		/**
		 * 根据传入的点集绘制形状。
		 * 
		 * @param $graphics:Graphics
		 * @param $close:Boolean (default = true) 最后一个点是否闭合到起始点。
		 * @param ...$args Point集合。
		 * 
		 */
		public static function drawShape($graphics:Graphics, $close:Boolean = true, ...$args):void
		{
			if ($args && $args.length)
			{
				var points:* = ($args.length == 1 && ArrayUtil.validate($args[0]) ? $args[0] : $args).concat();
				if (points.length)
				{
					var point:Point = ArrayUtil.shift(points);
					if ($close) points[points.length] = point;
					$graphics.moveTo(point.x, point.y);
					for each (point in points) $graphics.lineTo(point.x, point.y);
				}
			}
		}
		
		
		/**
		 * Draw a star shape. before drawStar(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param vertex:uint=2 Number of vertex, default is 2，if less than 2，throw <code>ArgumentError</code>.
		 * @param rotateRadian:Number=0 Rotation of randians, default is 0.
		 * @param x:Number=0 Center of shape x，default is 0.
		 * @param y:Number=0 Center of shape y，default is 0.
		 * @param outerXRadius:Number=20 Outer Radius of shape x, default is 20.
		 * @param outerYRadius:Number=20 Outer Radius of shape y, default is 20.
		 * @param innerXRadius:Number=10 Inner Radius of shape x，default is 10.
		 * @param innerYRadius:Number=10 Inner Radius of shape y，default is 10.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9
		 * @playerversion AIR 1.1
		 * @productversion vision 1.0
		 */
		public static function drawStar(
			graphics:Graphics, 
			vertex:uint=2, 
			rotateRadian:Number=0, 
			x:Number=0, 
			y:Number=0, 
			outerXRadius:Number=20, 
			outerYRadius:Number=20, 
			innerXRadius:Number=10, 
			innerYRadius:Number=10):void
		{
			var angle:Number = (Math.PI * 2) / vertex;
			var halfAngle:Number = angle * .5;
			graphics.moveTo(
				x + Math.cos(rotateRadian) * outerXRadius, 
				y + Math.sin(rotateRadian) * outerYRadius);
			for (var i:int = 1; i <= vertex; i++)
			{
				graphics.lineTo(
					x + Math.cos(rotateRadian+(angle * i) - halfAngle) * innerXRadius, 
					y + Math.sin(rotateRadian+(angle * i) - halfAngle) * innerYRadius);
				graphics.lineTo(
					x + Math.cos(rotateRadian + (angle * i)) * outerXRadius, 
					y + Math.sin(rotateRadian + (angle * i)) * outerYRadius);
			}
		}
		
		/**
		 * Draw a wedge shape. before drawWedge(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param rotateRadian:Number=0 Rotation of randians, default is 0.
		 * @param arcRadian:Number=0.7853981633974483 randians of arc default is Math.PI/4
		 * @param x:Number=0 Center of x，default is 0.
		 * @param y:Number=0 Center of y，default is 0.
		 * @param xRadius:Number=10 Radius of x，default is 20.
		 * @param yRadius:Number=10 Radius of y, default is 20.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9
		 * @playerversion AIR 1.1
		 * @productversion vision 1.0
		 */
		public static function drawWedge(
			graphics:Graphics, 
			rotateRadian:Number=0, 
			arcRadian:Number=0.7853981633974483, 
			x:Number=0, 
			y:Number=0, 
			xRadius:Number=20, 
			yRadius:Number=20):void
		{
			arcRadian = MathUtil.clamp(arcRadian, -Math.PI * 2, Math.PI * 2);
			var segs:int = Math.ceil(Math.abs(arcRadian) / (Math.PI * .25));
			if (segs > 0)
			{
				var theta:Number = arcRadian / segs;
				var angle:Number = rotateRadian;
				graphics.moveTo(x, y);
				graphics.lineTo(
					x + Math.cos(rotateRadian) * xRadius, 
					y + Math.sin(rotateRadian) * yRadius);
				for (var i:int = 0; i<segs; i++)
				{
					angle += theta;
					var halfAngle:Number = angle - (theta * .5);
					graphics.curveTo(
						x + Math.cos(halfAngle) * (xRadius / Math.cos(theta * .5)), 
						y + Math.sin(halfAngle) * (yRadius / Math.cos(theta * .5)), 
						x + Math.cos(angle) * xRadius, y + Math.sin(angle) * yRadius);
				}
				graphics.lineTo(x, y);
			}
		}
		
	}
}