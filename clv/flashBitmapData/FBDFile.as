package clv.flashBitmapData 
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class FBDFile 
	{
		
		private static var _initialized:Boolean;
		
		public var width:int;
		public var height:int;
		public var pixels:ByteArray;
		public var transparet:Boolean;
		
		
		public function FBDFile() 
		{
			
		}
		
		static private function init():void 
		{
			registerClassAlias("clv.flashBitmapData.FBDFile", FBDFile);
		}
		
		public static function formBitmapData(b:BitmapData):FBDFile
		{
			var f:FBDFile = new FBDFile();
			f.width = b.width;
			f.height = b.height;
			f.pixels = b.getPixels(b.rect);
			f.pixels.position = 0;
			f.transparet = b.transparent;
			return f;
		}
		
		public static function toBitmapData(f:FBDFile):BitmapData
		{
			var b:BitmapData = new BitmapData(f.width, f.height, f.transparet);
			f.pixels.position = 0;
			b.setPixels(b.rect, f.pixels);
			return b;
		}
		
		public static function toByteArray(f:FBDFile):ByteArray
		{
			if (!_initialized) init();

			var b:ByteArray = new ByteArray();
			b.writeObject(f);
			b.position = 0;
			b.compress();
			return b;
		}
		
		public static function fromByteArray(b:ByteArray):FBDFile
		{
			if (!_initialized) init();
			
			b.uncompress();
			b.position = 0;
			var f:FBDFile = b.readObject() as FBDFile;
			return f;
		}
		
		public static function fromFile(file:File):FBDFile
		{
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);
			var f:FBDFile = fromByteArray(bytes);
			stream.close();
			return f;
		}
		
		public static function toFile(file:File, f:FBDFile):void
		{
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			stream.open(file, FileMode.WRITE);
			var b:ByteArray = toByteArray(f);
			stream.writeBytes(b, 0, b.length);
			stream.close();
		}
		
		
	}
	
}