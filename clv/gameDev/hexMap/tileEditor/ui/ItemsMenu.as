package clv.gameDev.hexMap.tileEditor.ui 
{
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.layouts.ZvrHorizontalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ItemsMenu extends ZvrGroup
	{
		public var newHex				:ButtonMD;
		public var newLayer				:ButtonMD;
		public var newMaskLayer			:ButtonMD;
		
		public function ItemsMenu() 
		{
			setLayout(ZvrHorizontalLayout);
			ZvrHorizontalLayout(layout).gap = 3;
			autoSize = ZvrAutoSize.CONTENT;
			
			newHex 			= new ButtonMD();
			newLayer 		= new ButtonMD();
			newMaskLayer	= new ButtonMD();

			newHex			.label.text = "Add Hex";
			newLayer		.label.text = "Add Layer";
			newMaskLayer	.label.text = "Add Mask Layer";

			addChild(newHex				);
			addChild(newLayer			);
			addChild(newMaskLayer		);
		}
		
	}

}