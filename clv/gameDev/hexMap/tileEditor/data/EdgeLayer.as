package clv.gameDev.hexMap.tileEditor.data 
{
	import clv.gameDev.hexMap.tileEditor.content.BitmapReference;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeLayer implements IBitmapReferenceUpdater
	{
		
		public var tileData:TileData;
		
		public var bitmap:BitmapReference;
		
		public var blend:String = BlendMode.SCREEN;
		
		public var alpha:Number = 100;
		
		public var visible:Boolean = true;
		
		public function EdgeLayer() 
		{
			
		}
		
		public function bitmapUpdated(b:BitmapData):void
		{
			tileData.change.dispatch(tileData);
		}
		
		public function get bitmapData():BitmapData
		{
			return bitmap.bitmapData;
		}
		
	}

}