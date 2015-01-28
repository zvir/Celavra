package clv.gameDev.hexMap.tileEditor.ui.controls 
{
	import clv.gameDev.hexMap.tileEditor.UI;
	import clv.gameDev.hexMap.tileEditor.ui.elements.BlendModeControl;
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.ListedWindowMD;
	import zvr.zvrGUI.components.minimalDark.SliderUIMD;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.layouts.ZvrAlignment;
	import zvr.zvrGUI.layouts.ZvrComplexLayout;
	import zvr.zvrGUI.layouts.ZvrLayoutDistribution;
	import zvr.zvrGUI.layouts.ZvrVerticalAlignment;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeLayerOptions extends ListedWindowMD 
	{
		public var image		:ButtonMD;
		public var reload		:ButtonMD;
		public var remove		:ButtonMD;
		
		public var up			:ButtonMD;
		public var down			:ButtonMD;
		
		public var amount		:SliderUIMD;
		
		public var blend		:BlendModeControl;
		
		
		
		
		public function EdgeLayerOptions() 
		{
			childrenPadding.padding = 10;
			
			bar.label.text = "Edge Layer Options";
			
			setLayout(ZvrVerticalLayout);
			ZvrVerticalLayout(layout).gap = 10;
			
			image = new ButtonMD();
			image.label.text = "Load Image";
			image.percentWidth = 100;
			addChild(image);
			
			reload = new ButtonMD();
			reload.label.text = "Reload Image";
			reload.percentWidth = 100;
			addChild(reload);
			
			remove = new ButtonMD();
			remove.label.text = "Delete Image";
			remove.percentWidth = 100;
			addChild(remove);
			
			amount = new SliderUIMD();
			amount.percentWidth = 100;
			amount.slider.min = 0
			amount.slider.max = 100;
			amount.slider.step = 1;
			amount.slider.position = 100;
			amount.title.text = "Alpha";
			addChild(amount  );
			
			var g:ZvrGroup = new ZvrGroup();
			g.percentWidth = 100;
			g.autoSize = ZvrAutoSize.CONTENT_HEIGHT;
			g.setLayout(ZvrComplexLayout);
			ZvrComplexLayout(g.layout).disrtibution = ZvrLayoutDistribution.EAVEN;
			ZvrComplexLayout(g.layout).alignment = ZvrAlignment.HORIZONTAL;
			ZvrComplexLayout(g.layout).verticalAlign = ZvrVerticalAlignment.TOP;

			
			up = new ButtonMD();
			up.autoSize = ZvrAutoSize.MANUAL;
			up.height = 20;
			up.label.text = "Up";
			up.percentWidth = 100;
			g.addChild(up);
			
			down = new ButtonMD();
			down.autoSize = ZvrAutoSize.MANUAL;
			down.height = 20;
			down.label.text = "Down";
			down.percentWidth = 100;
			g.addChild(down);
			
			addChild(g);
			
			blend = new BlendModeControl();
			blend.percentWidth = 100;
			addChild(blend);
			
			
			amount.slider.change.add(change);
			blend.slider.change.add(change);
		}
		
		private function change(v:Number):void 
		{
			UI.edgeLayersChange.dispatch();
		}
	}

}