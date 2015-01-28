package clv.gameDev.hexMap.tileEditor.ui 
{
	import clv.gameDev.hexMap.tileEditor.ui.lists.layer.LayerDataList;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LayersWindow  extends WindowMD
	{
		public var data:LayerDataList;
		
		public function LayersWindow() 
		{
			super();
			
			ZvrComponentUtils.setupStaticWindow(this);
			title.text = "LayersWindow";
			
			panel.scroller.customScroll = true;
			
			data = new LayerDataList(panel.scroller.verticalScroll, panel.scroller.horizontalScroll);
			data.percentWidth = 100;
			data.percentHeight = 100;
			addChild(data);
			
			data.update();
		}
		
	}

}