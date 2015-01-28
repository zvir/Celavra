package clv.gameDev.hexMap.tileEditor.data 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileData 
	{
		public var layers:Vector.<LayerData> = new Vector.<LayerData>();
		public var name:String = "HexTile";
		
		private var _change:Signal = new Signal(TileData);
		
		public function TileData() 
		{
			
		}
		
		public function get change():Signal 
		{
			return _change;
		}
		
	}

}