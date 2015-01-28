package clv.gameDev.hexMap.tileEditor.data 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexEdgeMask extends EdgeLayer
	{
		
		private var _bitmapData:BitmapData;
		
		public function HexEdgeMask() 
		{
			blend = BlendMode.MULTIPLY;
		}
		
		public function getBitmapData():BitmapData 
		{
			return _bitmapData;
		}
		
		public function setBitmapData(value:BitmapData):void 
		{
			_bitmapData = value;
			bitmapUpdated(_bitmapData);
		}
		
		override public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
	}

}