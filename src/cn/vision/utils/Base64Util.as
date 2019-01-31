package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.utils.ByteArray;
	
	/**
	 * 定义Base64加密解密函数。
	 * 
	 * @author exyjen
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class Base64Util extends NoInstance
	{
		
		/**
		 * 对BASE64字符串进行解密，返回原始字符串。
		 * 
		 * @param data:String
		 * 
		 * @return String
		 * 
		 */
		public static function decode(data:String):String
		{
			if (data)
			{
				// Decode data to ByteArray   
				var bytes:ByteArray = decodeToByteArray(data);   
				// Convert to string and return   
				var result:String = bytes.readUTFBytes(bytes.length);
			}
			return result;
		}   
		
		
		/**
		 * 对BASE64字符串进行解密，返回一个UTF ByteArray字节流。
		 * 
		 * @param data:String
		 * 
		 * @return ByteArray
		 * 
		 */
		public static function decodeToByteArray(data:String):ByteArray
		{   
			// Initialise output ByteArray for decoded data
			var output:ByteArray = new ByteArray;
			// Create data and output buffers
			var dataBuffer:Array = new Array(4);
			var outputBuffer:Array = new Array(3);
			var length:uint, i:int, j:int, k:int;
			
			// While there are data bytes left to be processed
			length = data.length;
			for (i = 0; i < length; i += 4)
			{
				// Populate data buffer with position of Base64 characters for
				// next 4 bytes from encoded data
				for (j = 0; j < 4 && i + j < length; j++)
				{
					dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
				}
				
				// Decode data buffer back into bytes   
				outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
				outputBuffer[1] =((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);
				outputBuffer[2] =((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
				
				// Add all non-padded bytes in output buffer to decoded data
				for (k = 0; k < 3; k++)
				{   
					if (dataBuffer[k+1] == 64) break;   
					output.writeByte(outputBuffer[k]);   
				}   
			}   
			
			// Rewind decoded data ByteArray   
			output.position = 0;   
			// Return decoded data   
			return output;   
		}
		
		
		/**
		 * 对字符串进行加密，返回BASE64字符串。
		 * 
		 * @param data:String
		 * 
		 * @return String
		 * 
		 */
		public static function encode(data:String):String
		{
			if (data)
			{
				// Convert string to ByteArray
				var bytes:ByteArray = new ByteArray;
				bytes.writeUTFBytes(data);
				
				// Return encoded ByteArray
				var result:String = encodeByteArray(bytes);
			}
			return result;
		}
		
		
		/**
		 * 对字符串进行加密，返回一个BASE64 UTF字节流。
		 * 
		 * @param data:ByteArray
		 * 
		 * @return String
		 * 
		 */
		public static function encodeByteArray(data:ByteArray):String
		{   
			// Initialise output
			var output:String = "";
			
			// Create data and output buffers
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			var length:uint, i:int, j:int, k:int;
			
			// Rewind ByteArray
			data.position = 0;
			
			// while there are still bytes to be processed
			while (data.bytesAvailable > 0)
			{
				// Create new data buffer and populate next 3 bytes from data
				dataBuffer = [];
				for (i = 0; i < 3 && data.bytesAvailable > 0; i++) dataBuffer[i] = data.readUnsignedByte();
				
				// Convert to data buffer Base64 character positions and    
				// store in output buffer   
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] =((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] =((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] =  dataBuffer[2] & 0x3f;
				
				// If data buffer was short (i.e not 3 characters) then set
				// end character indexes in data buffer to index of '=' symbol.
				// This is necessary because Base64 data is always a multiple of 
				// 4 bytes and is basses with '=' symbols.
				for (j = dataBuffer.length; j < 3; j++) outputBuffer[j + 1] = 64;
				
				// Loop through output buffer and add Base64 characters to
				// encoded data string for each character.
				length = outputBuffer.length;
				for (k = 0; k < length; k++) output += BASE64_CHARS.charAt(outputBuffer[k]);
			}
			
			// Return encoded data   
			return output;   
		}
		
		
		/**
		 * @private
		 */
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";   
		
	}
}