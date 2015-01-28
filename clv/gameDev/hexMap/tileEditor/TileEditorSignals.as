package clv.gameDev.hexMap.tileEditor 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileEditorSignals 
	{
		
		public static const projectLoaded	:Signal = new Signal();
		
		public static const projectUpdate	:Signal = new Signal();
		
		public static const tileChange		:Signal = new Signal();
		
		public static const layerChange		:Signal = new Signal();
		
		public static const edgeLayerChange	:Signal = new Signal();
		
		
		
		
		public function TileEditorSignals() 
		{
			
		}
		
	}

}