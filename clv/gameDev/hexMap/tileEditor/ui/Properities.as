package clv.gameDev.hexMap.tileEditor.ui 
{
	import clv.gameDev.hexMap.tileEditor.ui.controls.EdgeLayerOptions;
	import clv.gameDev.hexMap.tileEditor.ui.controls.ImageOptions;
	import clv.gameDev.hexMap.tileEditor.ui.controls.EdgeDistortOptions;
	import clv.gameDev.hexMap.tileEditor.ui.controls.EdgeOptions;
	import clv.gameDev.hexMap.tileEditor.ui.controls.ProjectOptions;
	import clv.gameDev.hexMap.tileEditor.ui.controls.TileOptions;
	import zvr.zvrGUI.behaviors.ZvrDragScrolable;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class Properities extends WindowMD
	{
		
		public var projectOptions:ProjectOptions;
		public var tileOptions:TileOptions;
		public var edgeOptions:EdgeOptions;
		public var edgeDistortOptions:EdgeDistortOptions;
		public var imageOptions:ImageOptions;
		public var edgeLayerOptions:EdgeLayerOptions;
		
		public function Properities() 
		{
			ZvrComponentUtils.setupStaticWindow(this);
			title.text = "Properities";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 2;
			
			panel.scroller.behaviors.getBehavior(ZvrDragScrolable.NAME).enabled = false;
			
			projectOptions = new ProjectOptions();
			addChild(projectOptions);
			
			tileOptions = new TileOptions();
			addChild(tileOptions);
			
			imageOptions = new ImageOptions();
			addChild(imageOptions);
			
			edgeLayerOptions = new EdgeLayerOptions();
			addChild(edgeLayerOptions);
			
			edgeOptions = new EdgeOptions();
			addChild(edgeOptions);
			
			edgeDistortOptions = new EdgeDistortOptions();
			addChild(edgeDistortOptions);
			
			
			
			
		}
		
	}

}