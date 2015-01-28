package clv.gameDev.hexMap.tileEditor.ui.controls 
{
	import clv.gameDev.hexMap.tileEditor.UI;
	import zvr.zvrGUI.components.minimalDark.ListedWindowMD;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	import zvr.zvrGUI.skins.zvrMinimalDark.InputLabelMD;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileOptions extends ListedWindowMD 
	{
		public var imageName	:InputLabelMD;
		
		public function TileOptions() 
		{
			childrenPadding.padding = 10;
			
			bar.label.text = "Tile Options";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 10;
			
			imageName = new InputLabelMD();
			imageName.label.text = "Image Name:";
			imageName.label.width = 80;
			imageName.input.text = "0";
			
			addChild(imageName);
			
			imageName.change.add(change);
		}
		
		private function change(v:String):void 
		{
			UI.tileOptionsChange.dispatch();
		}
	}

}