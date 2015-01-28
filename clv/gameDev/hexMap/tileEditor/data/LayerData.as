package clv.gameDev.hexMap.tileEditor.data 
{
	import clv.gameDev.hexMap.tileEditor.content.BitmapReference;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LayerData implements IBitmapReferenceUpdater
	{
		
		public var tileData:TileData;
		
		public var visible:Boolean = true;
		
		public var edge:EdgeData;
		public var image:BitmapReference = new BitmapReference();
		public var imageAlpha:Number = 100;
		public var blend:String = BlendMode.NORMAL;
		
		public function LayerData() 
		{
			
		}
		
		public function bitmapUpdated(b:BitmapData):void
		{
			tileData.change.dispatch(tileData);
		}
	}

}