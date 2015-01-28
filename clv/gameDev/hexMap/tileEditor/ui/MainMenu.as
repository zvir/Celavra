package clv.gameDev.hexMap.tileEditor.ui 
{
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.layouts.ZvrHorizontalLayout;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class MainMenu  extends ZvrGroup
	{
		public var save				:ButtonMD;
		public var load				:ButtonMD;
		public var export			:ButtonMD;
		public var newProject		:ButtonMD;
		
		public var exportTempates	:ButtonMD;
		
		
		public function MainMenu() 
		{
			setLayout(ZvrHorizontalLayout);
			ZvrHorizontalLayout(layout).gap = 3;
			autoSize = ZvrAutoSize.CONTENT;
			
			save 			= new ButtonMD();
			load 			= new ButtonMD();
			newProject		= new ButtonMD();
			
			export			= new ButtonMD();
			exportTempates	= new ButtonMD();
			
			export.left = 20;
			export.childrenPadding.left = 10;
			export.childrenPadding.right = 10;
			
			exportTempates.left = 20;
			
			save			.label.text = "Save Project";
			load			.label.text = "Load Project";
			newProject		.label.text = "New Project";
			export			.label.text = "Export";
			exportTempates	.label.text = "Export Masks";
			
			addChild(save			);
			addChild(load			);
			addChild(newProject		);
			addChild(export			);
			addChild(exportTempates	);
		}
		
	}

}