package clv.gameDev.hexMap.tileEditor.ui.controls 
{
	import clv.gameDev.hexMap.tileEditor.UI;
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.ListedWindowMD;
	import zvr.zvrGUI.components.minimalDark.SliderUIMD;
	import zvr.zvrGUI.components.minimalDark.ToggleButtonMD;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeDistortOptions extends ListedWindowMD 
	{
		public var enabled		:ToggleButtonMD;
		
		public var image		:ButtonMD;
		
		public var amount		:SliderUIMD;
		
		
		public function EdgeDistortOptions() 
		{
			
			childrenPadding.padding = 10;
			
			bar.label.text = "Edge Distort Options";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 10;
			
			enabled = new ToggleButtonMD();
			enabled.label.text = "Enabled";
			enabled.percentWidth = 100;
			addChild(enabled);
			
			image = new ToggleButtonMD();
			image.label.text = "Load Distortion Map";
			image.percentWidth = 100;
			addChild(image);
			
			amount	 	= new SliderUIMD();
			
			amount	.percentWidth = 100;
			
			amount.slider.min = 0
			amount.slider.max = 100;
			amount.slider.step = 1;
			amount.title.text = "amount";
			
			addChild(amount  );
			
			enabled		.change.add(change);
			amount		.slider.change.add(change);
			
		}
		
		private function change(v:Number):void 
		{
			UI.edgeDistortChange.dispatch();
		}
	}

}