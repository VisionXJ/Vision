package cn.vision.geom
{
	import cn.vision.core.VSObject;
	import cn.vision.core.vs;
	import cn.vision.errors.ArgumentInvalidError;
	import cn.vision.errors.ArgumentNumError;
	import cn.vision.utils.MathUtil;
	
	/**
	 * 行列式，前一个系数代表行，后一个系数代表列。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public dynamic class Determinant extends VSObject
	{
		
		/**
		 * 构造函数。
		 * 
		 * @copy cn.vision.geom.Determinant#parse()
		 * 
		 */
		public function Determinant(...$args)
		{
			super();
			while ($args.length == 1 && $args[0] is Array) $args = $args[0];
			parse.apply(null, $args);
		}
		
		
		/**
		 * 根据传入参数解析行列式，传入的参数有以下几种形式：<br>
		 * 1-传入一系列参数，如：a11, a12, ..., a1n, a21, a22, ..., a2n, ..., an1, an2, ..., ann；<br>
		 * 2-传入多个一维数组，如：[a11, a12, ..., a1n], [a21, a22, ..., a2n], ..., [an1, an2, ..., ann]；<br>
		 * 3-传入一个二位数组，如：[[a11, a12, ..., a1n], [a21, a22, ..., a2n], ..., [an1, an2, ..., ann]]。
		 * 
		 * @param ...$args 传入参数。
		 */
		public function parse(...$args):void
		{
			var item:Array;
			dirty = true;
			if ($args[0] is Number) source = $args;
			else if (source is Array)
				for each(item in $args) source = source.concat(item);
			else throw new ArgumentInvalidError;
			
			var l:int = source.length, d:Number = Math.sqrt(l);
			if (d > 1 && MathUtil.integer(d)) vs::dimension = d;
			else throw new ArgumentNumError(d > 2 ? Math.pow(int(d), 2) : 4);
		}
		
		
		/**
		 * 根据传入的行列系数获取对应的值。<br>
		 * 如果行列系数超过维度，会引发参数不合法异常。
		 * 
		 * @param $row:uint 行系数，从0开始。
		 * @param $column:uint 列系数，从0开始。
		 * 
		 */
		public function getItem($row:uint, $column:uint):Number
		{
			if (dimension > $row && dimension > $column)
			{
				return getNum($row, $column);
			}
			else throw new ArgumentInvalidError;
		}
		
		
		/**
		 * 设置某一行某一列的值。<br>
		 * 如果行列系数超过维度，会引发参数不合法异常。
		 * 
		 * @param $row:uint 行系数，从0开始。
		 * @param $column:uint 列系数，从0开始。
		 * @param $value:Number 值。
		 * 
		 */
		public function setItem($row:uint, $column:uint, $value:Number):void
		{
			if (dimension > $row && dimension > $column)
			{
				source[$row * vs::dimension + $column] = $value;
				dirty = true;
			}
			else throw new ArgumentInvalidError;
		}
		
		
		/**
		 * @private
		 */
		private function getNum($r:uint, $c:uint):Number
		{
			return source[$r * vs::dimension + $c];
		}
		
		/**
		 * @private
		 */
		private function setNum($r:uint, $c:uint, $num:Number):Number
		{
			return source[$r * vs::dimension + $c] = $num;
		}
		
		
		/**
		 * 行列式的代数和。<br>
		 * 运算公式：D = S1 - S2 <br>
		 * S1 = d0,0 * d1,1 * ... * dn-1,n-1 + d0,1 * d1,2 * ... * dn-1,1 + ... + d0,n-1 * d1,0 * ... * dn-1,n-2<br>
		 * S2 = d0,0 * d1,n-1 * ... * dn-1,1 + d0,1 * d1,0 * ... * dn-1,2 + ... + d0,n-1 * d1,n-2 * ... * dn-1,0<br>
		 * 
		 */
		public function get algebraSum():Number
		{
			if (dirty)
			{
				dirty = false;
				if (vs::dimension == 2)
					vs::algebraSum = source[0] *source[3] - source[2] * source[1];
				else
				{
					vs::algebraSum = 0;
					var i:int, j:int, p:Number = 1;
					for (i = 0; i < vs::dimension; i++, p = 1)
					{
						for (j = 0; j < vs::dimension; j++)
							p *= getNum(j, (i + j) % vs::dimension);
						vs::algebraSum += p;
					}
					for (i = 0; i < vs::dimension; i++, p = 1)
					{
						for (j = 0; j < vs::dimension; j++)
							p *= getNum(j, (vs::dimension + i - j) % vs::dimension);
						vs::algebraSum -= p;
					}
				}
			}
			return vs::algebraSum;
		}
		
		
		/**
		 * 行列式的度，行数或列数，行列式的行数和列数是相同的。
		 */
		public function get dimension():uint
		{
			return vs::dimension;
		}
		
		
		/**
		 * @private
		 */
		private var source:Array = [];
		
		/**
		 * @private
		 */
		private var dirty:Boolean;
		
		
		/**
		 * @private
		 */
		vs var algebraSum:Number;
		
		/**
		 * @private
		 */
		vs var dimension:uint;
		
	}
}