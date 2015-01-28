package clv.gameDev.texture 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ClvGraphAsset 
	{
		public var name:String;
		
		public var width:uint;
		public var height:uint;
		
		public var pixels:ByteArray;
		
		public var transparet:Boolean;
		
		public var sprites:Vector.<ClvGraphAssetSprite> = new Vector.<ClvGraphAssetSprite>();
		
		public var fonts:Vector.<ClvGraphAssetFont> = new Vector.<ClvGraphAssetFont>();
		
		public var animations:Vector.<ClvGraphAssetAnimation> = new Vector.<ClvGraphAssetAnimation>();
		
		private var _bitmapData:BitmapData;
		
		public function getBitmap():BitmapData
		{
			if (!_bitmapData)
			{
				_bitmapData = new BitmapData(width, height, transparet);
				pixels.position = 0;
				_bitmapData.setPixels(_bitmapData.rect, pixels);
			}
			
			return _bitmapData;
		}
		
		public function ClvGraphAsset() 
		{
			
		}
		
		public function dispose(disposeBitmap:Boolean = true):void
		{
			pixels.clear();
			sprites = null;
			fonts = null;
			animations = null;
			
			if (_bitmapData && disposeBitmap) 
			{
				_bitmapData.dispose();
			}
			_bitmapData = null;
		}
		
	}

}