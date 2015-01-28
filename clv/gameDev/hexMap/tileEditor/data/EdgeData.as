package clv.gameDev.hexMap.tileEditor.data 
{
	import clv.gameDev.hexMap.tileEditor.content.BitmapReference;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeData implements IBitmapReferenceUpdater
	{
		
		public var tileData:TileData;
		
		//public var edgeProcess:Boolean = true;
		
		public var blur:Number = 20;
		public var brightness:Number = 0
		public var contrast:Number = 0;
		
		public var displacementMap:BitmapReference = new BitmapReference();
		public var displacementMapAmount:Number = 1;
		public var displacementMapEnabled:Boolean = false;
		
		public var layers:Vector.<EdgeLayer> = new Vector.<EdgeLayer>();
		
		
		public function EdgeData() 
		{
			
		}
		
		public function bitmapUpdated(b:BitmapData):void
		{
			tileData.change.dispatch(tileData);
		}
		
		public function get hexMask():HexEdgeMask
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				if (layers[i] is HexEdgeMask) return layers[i] as HexEdgeMask;
			}
			return null;
		}
		
		public function get edgeMask():EdgeMask
		{
			for (var i:int = 0; i < layers.length; i++) 
			{
				if (layers[i] is EdgeMask) return layers[i] as EdgeMask;
			}
			return null;
		}
		
	}

}