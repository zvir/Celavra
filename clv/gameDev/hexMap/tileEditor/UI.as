package clv.gameDev.hexMap.tileEditor 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import clv.gameDev.hexMap.tileEditor.ui.BitmapWidow;
	import clv.gameDev.hexMap.tileEditor.ui.ItemsMenu;
	import clv.gameDev.hexMap.tileEditor.ui.LayersWindow;
	import clv.gameDev.hexMap.tileEditor.ui.EdgeLayers;
	import clv.gameDev.hexMap.tileEditor.ui.MainMenu;
	import clv.gameDev.hexMap.tileEditor.ui.PreviewWindow;
	import clv.gameDev.hexMap.tileEditor.ui.Properities;
	import clv.gameDev.hexMap.tileEditor.ui.TilesList;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class UI 
	{
		
		public static const projectOptionsChange	:Signal = new Signal();
		public static const edgeOptionsChange		:Signal = new Signal();
		public static const edgeDistortChange		:Signal = new Signal();
		public static const imageOptionsChange		:Signal = new Signal();
		static public const edgeLayersChange		:Signal = new Signal();
		static public const tileOptionsChange		:Signal = new Signal();
		
		public static const onSetTile				:Signal = new Signal(TileData);
		public static const onSetLayer				:Signal = new Signal(LayerData);
		public static const onSetEdgeLayer			:Signal = new Signal(EdgeLayer);
		
		
		
		public static const bitmapWidow 	:BitmapWidow 	= new BitmapWidow();
		public static const tilesList 		:TilesList 		= new TilesList();
		public static const previewWindow 	:PreviewWindow 	= new PreviewWindow();
		public static const properities		:Properities	= new Properities();
		public static const layersWindow 	:LayersWindow 	= new LayersWindow();
		public static const mainMenu 		:MainMenu 		= new MainMenu();
		public static const itemsMenu 		:ItemsMenu 		= new ItemsMenu();
		public static const edgeLayers 		:EdgeLayers 	= new EdgeLayers();
		
		
		
		
	}

}