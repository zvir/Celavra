package clv.gameDev.hexMap.tileEditor.ui 
{
	import clv.gameDev.hexMap.tileEditor.ui.lists.tiles.TilesDataList;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TilesList extends WindowMD 
	{
		public var data:TilesDataList;
		
		public function TilesList() 
		{
			ZvrComponentUtils.setupStaticWindow(this);
			title.text = "TilesList";
			
			panel.scroller.customScroll = true;
			
			data = new TilesDataList(panel.scroller.verticalScroll, panel.scroller.horizontalScroll);
			data.percentWidth = 100;
			data.percentHeight = 100;
			addChild(data);
			
			data.update();
			
		}
		
	}

}