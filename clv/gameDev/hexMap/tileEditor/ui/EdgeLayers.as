package clv.gameDev.hexMap.tileEditor.ui 
{
	import clv.gameDev.hexMap.tileEditor.ui.lists.edgeLayer.EdgeDataList;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeLayers extends WindowMD
	{
		public var data:EdgeDataList;
		
		public function EdgeLayers() 
		{
			super();
			
			ZvrComponentUtils.setupStaticWindow(this);
			title.text = "Edges Layers Window";
			
			panel.scroller.customScroll = true;
			
			data = new EdgeDataList(panel.scroller.verticalScroll, panel.scroller.horizontalScroll);
			data.percentWidth = 100;
			data.percentHeight = 100;
			addChild(data);
			
			data.update();
			
		}
		
	}

}