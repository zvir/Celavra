package clv.gameDev.hexMap.tileEditor.ui.controls 
{
	import clv.gameDev.hexMap.tileEditor.UI;
	import zvr.zvrGUI.components.minimalDark.ListedWindowMD;
	import zvr.zvrGUI.components.minimalDark.SliderUIMD;
	import zvr.zvrGUI.components.minimalDark.ToggleButtonMD;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeOptions extends ListedWindowMD 
	{
		
		public var brightness	:SliderUIMD;
		public var contrast		:SliderUIMD;
		public var blur			:SliderUIMD;
		
		
		public function EdgeOptions() 
		{
			
			childrenPadding.padding = 10;
			
			bar.label.text = "Edge Options";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 10;
			
			/*enabled = new ToggleButtonMD();
			enabled.label.text = "Enabled";
			enabled.percentWidth = 100;
			addChild(enabled);*/
			
			brightness	 = new SliderUIMD();
			contrast     = new SliderUIMD();
			blur         = new SliderUIMD();
			
			brightness	.percentWidth = 100;
			contrast    .percentWidth = 100;
			blur        .percentWidth = 100;
			
			brightness.slider.min = -100
			brightness.slider.max = 100;
			brightness.slider.step = 1;
			
			contrast.slider.min = -200
			contrast.slider.max = 500;
			contrast.slider.step = 1;
			
			blur.slider.min = 0
			blur.slider.max = 100;
			blur.slider.step = 1;
			
			brightness		.title.text = "brightness";
			contrast		.title.text = "contrast";
			blur			.title.text = "blur";
			
			addChild(brightness  );
			addChild(contrast     );
			addChild(blur         );
			
			brightness	.slider.change.add(change);
			contrast	.slider.change.add(change);
			blur		.slider.change.add(change);
			//enabled		.change.add(change);
			
		}
		
		private function change(v:Number):void 
		{
			UI.edgeOptionsChange.dispatch();
		}
		
	}

}