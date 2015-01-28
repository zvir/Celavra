package clv.gameDev.hexMap.tileEditor 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeData;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.outputs.HexeEdges;
	import clv.gameDev.hexMap.tileEditor.processors.HexEdgeBitmapGenerator;
	import clv.gameDev.hexMap.tileEditor.processors.HexShapeGenerator;
	import clv.gameDev.hexMap.tileEditor.storage.LastPoroject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import zvr.zvrGUI.core.ZvrApplication;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	import zvr.zvrKeyboard.ZvrKeyboard;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileEditor extends ZvrApplication
	{
		
		public function TileEditor() 
		{
			super();
			
			ZvrKeyboard.init(stage);
			
			HexShapeGenerator.init();
			HexEdgeBitmapGenerator.init();
			
			Project.data = LastPoroject.init();
			
			var t:TileEditorManager = new TileEditorManager();
			t.start();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			childrenPadding.padding = 10;
			
			UI.properities.top = 50;
			UI.properities.bottom = 160;
			UI.properities.width = 200;
			UI.properities.left = 0;
			
			UI.tilesList.bottom = 0;
			UI.tilesList.left = 0;
			UI.tilesList.right = 0;
			UI.tilesList.height = 150;
			
			UI.bitmapWidow.top = 50;
			UI.bitmapWidow.right = 0;
			ZvrComponentUtils.setPanelSizeToContent(UI.bitmapWidow, 200, 200);
			
			UI.layersWindow.top = UI.bitmapWidow.bounds.bottom + 10;
			UI.layersWindow.width = UI.bitmapWidow.width;
			UI.layersWindow.right = 0;
			UI.layersWindow.bottom = 320;
			
			UI.edgeLayers.bottom = 160;
			UI.edgeLayers.height = 150;
			UI.edgeLayers.width = UI.bitmapWidow.width;
			UI.edgeLayers.right = 0;
			
			
			UI.previewWindow.right = 210;
			UI.previewWindow.top = 50;
			UI.previewWindow.bottom = 160;
			UI.previewWindow.left = UI.bitmapWidow.width + 10;
			
			UI.itemsMenu.right = 0;
			
			addChild(UI.bitmapWidow 	);
			addChild(UI.tilesList 		);
			addChild(UI.previewWindow 	);
			addChild(UI.properities		);
			addChild(UI.layersWindow 	);
			addChild(UI.mainMenu 		);
			addChild(UI.itemsMenu 		);
			addChild(UI.edgeLayers 		);
			
			//UI.init();
			
			
			
			/*var hexEdges:HexeEdges = HexEdgeBitmapGenerator.getNewEdges();
			HexEdgeBitmapGenerator.drawMasks(new EdgeData(), hexEdges);*/
			
			
			/*
			for (var i:int = 0; i < hexEdges.edges.length; i++) 
			{
				
				var b:Bitmap = new Bitmap(hexEdges.edges[i].mask);
				b.smoothing = true;
				b.scaleX = 0.4;
				b.scaleY = 0.4;
				b.y = (b.height + 5) * Math.floor(i/10);
				b.x = (b.width + 5) * i - (Math.floor(i/10) * (b.width + 5) * 10);
				stage.addChild(b);
				
			}
			*/
			
			
			
		}
		
	}

}