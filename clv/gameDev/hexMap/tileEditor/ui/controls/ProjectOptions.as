package clv.gameDev.hexMap.tileEditor.ui.controls 
{
	import clv.gameDev.hexMap.tileEditor.UI;
	import zvr.zvrGUI.components.minimalDark.ListedWindowMD;
	import zvr.zvrGUI.components.minimalDark.SliderUIMD;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	import zvr.zvrGUI.skins.zvrMinimalDark.InputLabelMD;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ProjectOptions extends ListedWindowMD 
	{
		
		public var tileWidth	:InputLabelMD;
		public var tileScaleY	:InputLabelMD;
		public var projectName	:InputLabelMD;
		
		public var frame		:SliderUIMD;
		
		public function ProjectOptions() 
		{
			childrenPadding.padding = 10;
			
			bar.label.text = "Project Options";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 10;
			
			projectName = new InputLabelMD();
			projectName.label.text = "Project Name:";
			projectName.label.width = 80;
			projectName.input.text = "0";
			
			addChild(projectName);
			
			tileWidth = new InputLabelMD();
			tileWidth.label.text = "Tile Width:";
			tileWidth.label.width = 80;
			tileWidth.input.text = "0";
			
			addChild(tileWidth);
			
			tileScaleY = new InputLabelMD();
			tileScaleY.label.text = "Tile Scale:";
			tileScaleY.label.width = 80;
			tileScaleY.input.text = "0";
			
			addChild(tileScaleY);
			
			frame = new SliderUIMD();
			
			frame.percentWidth = 100;
			
			frame.slider.min = 0
			frame.slider.max = 69;
			frame.slider.step = 1;
			
			frame.slider.position = 67;
			
			addChild(frame);
			
			projectName.change.add(change);
			tileScaleY.change.add(change);
			tileWidth.change.add(change);
			frame.slider.change.add(change);
		}
		
		private function change(v:String):void 
		{
			UI.projectOptionsChange.dispatch();
		}
			
		
		
	}

}