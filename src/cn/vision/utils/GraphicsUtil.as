package cn.vision.utils
{
	
	/**
	 * 
	 * <code>GraphicsUtil</code>定义了一些画图函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	
	public final class GraphicsUtil extends NoInstance
	{
		/**
		 * Draw a arc. before drawArc(), you need to call linestyle() to set line style.
		 * you can draw circle eclipse by change param arc, xRadius,yRaidus.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param rotateRadians:Number=0 Rotation of randians, default is 0.
		 * @param arcRadians:Number=0.7853981633974483 randians of arc default is Math.PI/4
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
		public static function drawArc(
			graphics:Graphics, 
			rotateRadians:Number=0, 
			arcRadians:Number=0.7853981633974483, 
			x:Number=0, 
			y:Number=0, 
			xRadius:Number=20,
			yRadius:Number=20):void
		{
			if (Math.abs(arcRadians) > Math.PI * 2) arcRadians = Math.PI * 2;
			var segs:Number = Math.ceil(Math.abs(arcRadians)/(Math.PI * .25));
			if (segs>0) {
				var theta:Number = -arcRadians/segs;
				var angle:Number = -rotateRadians;
				graphics.moveTo(
					x+Math.cos(rotateRadians)*xRadius, 
					y-Math.sin(rotateRadians)*yRadius);
				for (var i:int = 0; i<segs; i++) {
					angle += theta;
					var halfAngle:Number = angle-(theta*.5);
					graphics.curveTo(
						x+Math.cos(halfAngle)*(xRadius/Math.cos(theta*.5)), 
						y+Math.sin(halfAngle)*(yRadius/Math.cos(theta*.5)), 
						x+Math.cos(angle)*xRadius, y+Math.sin(angle)*yRadius);
				}
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
		 * @param rotateRadians:Number=0 Rotation of randians, default is 0.
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
		public static function drawBurst(
			graphics:Graphics, 
			vertex:uint=2, 
			rotateRadians:Number=0, 
			x:Number=0, 
			y:Number=0, 
			outerXRadius:Number=20, 
			outerYRadius:Number=20, 
			innerXRadius:Number=10, 
			innerYRadius:Number=10):void
		{
			var angle:Number = (Math.PI * 2) / vertex;
			var halfAngle:Number = angle*.5;
			var qtrAngle :Number = angle*.25;
			graphics.moveTo(
				x+(Math.cos(rotateRadians)*outerXRadius), 
				y-(Math.sin(rotateRadians)*outerYRadius));
			for (var i:int=1; i<=vertex; i++) {
				graphics.curveTo(
					x+Math.cos(rotateRadians+(angle*i)-(qtrAngle*3))*(innerXRadius/Math.cos(qtrAngle)), 
					y-Math.sin(rotateRadians+(angle*i)-(qtrAngle*3))*(innerYRadius/Math.cos(qtrAngle)), 
					x+Math.cos(rotateRadians+(angle*i)-halfAngle)*innerXRadius, 
					y-Math.sin(rotateRadians+(angle*i)-halfAngle)*innerYRadius);
				graphics.curveTo(
					x+Math.cos(rotateRadians+(angle*i)-qtrAngle)*(innerXRadius/Math.cos(qtrAngle)), 
					y-Math.sin(rotateRadians+(angle*i)-qtrAngle)*(innerXRadius/Math.cos(qtrAngle)), 
					x+Math.cos(rotateRadians+(angle*i))*outerXRadius, 
					y-Math.sin(rotateRadians+(angle*i))*outerYRadius);
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
				y-(Math.sin(gearRotateRadians+btrAngle)*outerYRadius));
			for (var i:int=1; i<=gearVertex; i++) {
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-(qtrAngle*3)+btrAngle)*innerXRadius, 
					y-Math.sin(gearRotateRadians+(angle*i)-(qtrAngle*3)+btrAngle)*innerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-(qtrAngle*2)+btrAngle)*innerXRadius, 
					y-Math.sin(gearRotateRadians+(angle*i)-(qtrAngle*2)+btrAngle)*innerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)-qtrAngle+btrAngle)*outerXRadius, 
					y-Math.sin(gearRotateRadians+(angle*i)-qtrAngle+btrAngle)*outerYRadius);
				graphics.lineTo(
					x+Math.cos(gearRotateRadians+(angle*i)+btrAngle)*outerXRadius, 
					y-Math.sin(gearRotateRadians+(angle*i)+btrAngle)*outerYRadius);
			}
			angle = (Math.PI*2)/holeVertex;
			graphics.moveTo(
				x+(Math.cos(holeRotateRadians)*holeXRadius), 
				y-(Math.sin(holeRotateRadians)*holeYRadius));
			for (i=1; i<=holeVertex; i++) {
				graphics.lineTo(
					x+Math.cos(holeRotateRadians+(angle*i))*holeXRadius, 
					y-Math.sin(holeRotateRadians+(angle*i))*holeYRadius);
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
		 * @param rotateRadians:Number=0 Rotation of randians, default is 0.
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
				y-(Math.sin(rotateRadius)*yRadius));
			for (var i:int=1; i<=vertex; i++) {
				graphics.lineTo(
					x+Math.cos(rotateRadius+(angle*i))*xRadius, 
					y-Math.sin(rotateRadius+(angle*i))*yRadius);
			}
		}
		
		/**
		 * 绘制任意形状。
		 * 
		 * @param $$graphics:Graphics
		 * @param ...$args Point集合。
		 * 
		 */
		public static function drawShape($graphics:Graphics, ...$args):void
		{
			if ($args && $args.length)
			{
				var points:* = ($args.length == 1 && ArrayUtil.validate($args[0]) ? $args[0] : $args).concat();
				var point:Point = ArrayUtil.shift(points);
				ArrayUtil.push(points, point);
				$graphics.moveTo(point.x, point.y);
				for each (point in points) $graphics.lineTo(point.x, point.y);
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
		 * @param rotateRadians:Number=0 Rotation of randians, default is 0.
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
			rotateRadians:Number=0, 
			x:Number=0, 
			y:Number=0, 
			outerXRadius:Number=20, 
			outerYRadius:Number=20, 
			innerXRadius:Number=10, 
			innerYRadius:Number=10):void
		{
			var angle:Number = (Math.PI*2)/vertex;
			var halfAngle:Number = angle*.5;
			graphics.moveTo(x+(Math.cos(rotateRadians)*outerXRadius), y-(Math.sin(rotateRadians)*outerYRadius));
			for (var i:int=1; i<=vertex; i++) {
				graphics.lineTo(
					x+Math.cos(rotateRadians+(angle*i)-halfAngle)*innerXRadius, 
					y-Math.sin(rotateRadians+(angle*i)-halfAngle)*innerYRadius);
				graphics.lineTo(
					x+Math.cos(rotateRadians+(angle*i))*outerXRadius, 
					y-Math.sin(rotateRadians+(angle*i))*outerYRadius);
			}
		}
		
		/**
		 * Draw a wedge shape. before drawWedge(), 
		 * you need to call linestyle(), lineGradientStyle(), 
		 * beginFill(), beginGradientFill() or beginBitmapFill() 
		 * to set line style and fill style.
		 * 
		 * @param graphics:Graphics Instance of <code>Graphics</code>，if null，throw <code>ArgumentError</code>.
		 * @param rotateRadians:Number=0 Rotation of randians, default is 0.
		 * @param arcRadians:Number=0.7853981633974483 randians of arc default is Math.PI/4
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
			rotateRadians:Number=0, 
			arcRadians:Number=0.7853981633974483, 
			x:Number=0, 
			y:Number=0, 
			xRadius:Number=20, 
			yRadius:Number=20):void
		{
			if (Math.abs(arcRadians)>Math.PI*2) arcRadians = Math.PI*2;
			var segs:int = Math.ceil(Math.abs(arcRadians)/(Math.PI*.25));
			if (segs>0) {
				var theta:Number = -arcRadians/segs;
				var angle:Number = -rotateRadians;
				graphics.moveTo(x, y);
				graphics.lineTo(
					x+Math.cos(rotateRadians)*xRadius, 
					y-Math.sin(rotateRadians)*yRadius);
				for (var i:int = 0; i<segs; i++) {
					angle += theta;
					var halfAngle:Number = angle-(theta*.5);
					graphics.curveTo(
						x+Math.cos(halfAngle)*(xRadius/Math.cos(theta*.5)), 
						y+Math.sin(halfAngle)*(yRadius/Math.cos(theta*.5)), 
						x+Math.cos(angle)*xRadius, y+Math.sin(angle)*yRadius);
				}
				graphics.lineTo(x, y);
			}
		}
		
		public static function getVertex(
			vertex:uint=2, 
			rotateRadians:Number=0, 
			x:Number = 0, 
			y:Number = 0, 
			xRadius:Number=20, 
			yRadius:Number=20):Array
		{
			var points:Array = [];
			var angle:Number = (Math.PI*2)/vertex;
			for (var i:int = 0; i<vertex; i++) {
				var point:Point = new Point(
					x+Math.cos(rotateRadians+angle*i)*xRadius, 
					y-Math.sin(rotateRadians+angle*i)*yRadius);
				points.push(point);
			}
			return points;
		}
	}
}