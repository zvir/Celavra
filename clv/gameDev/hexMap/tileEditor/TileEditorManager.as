package clv.gameDev.hexMap.tileEditor 
{
	import clv.gameDev.hexMap.tileEditor.content.BitmapReference;
	import clv.gameDev.hexMap.tileEditor.content.FileChooser;
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.data.ProjectData;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import clv.gameDev.hexMap.tileEditor.outputs.Exporter;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.gameDev.hexMap.tileEditor.processors.HexEdgeBitmapGenerator;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileEditorManager 
	{
		
		public function TileEditorManager() 
		{
			
		}
		
		public function start():void
		{
			updateUI();
			
			UI.projectOptionsChange	.add(projectOptionsChange);
			UI.tileOptionsChange	.add(tileOptionsChange);	
			UI.edgeOptionsChange	.add(edgeOptionsChange);	
			UI.edgeDistortChange	.add(edgeDistortChange);	
			UI.imageOptionsChange	.add(imageOptionsChange);	
			UI.edgeLayersChange		.add(edgeLayerChange);	
			
			
			UI.projectOptionsChange	.add(tileChange);
			UI.edgeOptionsChange	.add(tileChange);	
			UI.edgeDistortChange	.add(tileChange);	
			UI.imageOptionsChange	.add(tileChange);
			UI.edgeLayersChange		.add(tileChange);
			
			UI.onSetTile			.add(setTile);
			UI.onSetLayer           .add(setlayer);	
			UI.onSetEdgeLayer       .add(setEdgeLayer);	
			
			UI.itemsMenu.newHex.addEventListener(MouseEvent.CLICK, newHexClick);
			UI.itemsMenu.newLayer.addEventListener(MouseEvent.CLICK, newLayerClick);
			UI.itemsMenu.newMaskLayer.addEventListener(MouseEvent.CLICK, newMaskLayerClick);
			
			UI.properities.imageOptions.up.addEventListener(MouseEvent.CLICK, layerUpClick);
			UI.properities.imageOptions.down.addEventListener(MouseEvent.CLICK, layerDownClick);
			
			UI.mainMenu.newProject.addEventListener(MouseEvent.CLICK, newProjectClick);
			UI.mainMenu.export.addEventListener(MouseEvent.CLICK, export);
			UI.mainMenu.exportTempates.addEventListener(MouseEvent.CLICK, exportTemplates);
			
			UI.properities.imageOptions.image.addEventListener(MouseEvent.CLICK, loadImage);
			UI.properities.edgeDistortOptions.image.addEventListener(MouseEvent.CLICK, loadEdgeDistortImage);
			
		}
		
		private function exportTemplates(e:MouseEvent):void 
		{
			Exporter.exportTemplates();
		}
		
		private function export(e:MouseEvent):void 
		{
			Exporter.export();
		}
		
		private function layerUpClick(e:MouseEvent):void 
		{
			ProjectData.moveMoveLayer(Project.tile, Project.layer, -1);
			UI.layersWindow.data.update();
			Project.getTileOutput(Project.tile).updateDelay();
		}
		
		private function layerDownClick(e:MouseEvent):void 
		{
			ProjectData.moveMoveLayer(Project.tile, Project.layer, 1);
			UI.layersWindow.data.update();
			Project.getTileOutput(Project.tile).updateDelay();
		}
		
		private function loadEdgeDistortImage(e:MouseEvent):void 
		{
			FileChooser.select(
			
				function(f:File):void
				{
					Project.layer.edge.displacementMap.path = f.nativePath;
				}
			
			);
		}
		
		private function tileChange():void 
		{
			trace("tileChange");
			
			if (!Project.tile) return;
			
			Project.getTileOutput(Project.tile).updateDelay();
			
		}
		
		private function loadImage(e:MouseEvent):void 
		{
			FileChooser.select(
			
				function(f:File):void
				{
					Project.layer.image.path = f.nativePath;
				}
			
			);
			
			
		}
		
		private function updateUI():void
		{
			updateProjectUI();
			updateEdgeUI();
			updateEdgeDispUI();
			updateEdgeLayerUI();
			updateImageUI();
			updateTileUI();
			UI.previewWindow.update();
			
			UI.tilesList.data.data = Project.data.tiles;
			UI.layersWindow.data.data = Project.tile.layers;
			UI.edgeLayers.data.data = Project.layer.edge.layers;
			
		}
		
		private function newProjectClick(e:MouseEvent):void 
		{
			Project.data = ProjectData.getNewProject();
			updateUI();
		}
		
		//////////////////////
		
		private function newHexClick(e:MouseEvent):void 
		{
			Project.registerTile(ProjectData.addNewTile(Project.data))
			UI.tilesList.data.update();
		}
		
		private function newLayerClick(e:MouseEvent):void 
		{
			
			var l:LayerData = ProjectData.addNewLayer(Project.tile);
			
			Project.registerLayer(l);
			
			UI.layersWindow.data.update();
		}
		
		private function newMaskLayerClick(e:MouseEvent):void 
		{
			ProjectData.addNewMaskLayer(Project.layer.edge);
			UI.edgeLayers.data.update();
		}
		
		public function updateAllTiles():void
		{
			for (var i:int = 0; i < Project.tilesOutputs.length; i++) 
			{
				Project.tilesOutputs[i].updateDelay();
			}
		}
		
		/////////////////////
		
		private function setTile(v:TileData):void 
		{
			Project.tile = v;
			setlayer(Project.tile.layers[0]);
			updateTileUI();
		}
		
		private function setlayer(v:LayerData):void 
		{
			Project.layer = v;
			Project.edgeLayer = Project.layer.edge.layers.length > 0 ?  Project.layer.edge.layers[0] : null;
			
			updateImageUI();
			updateEdgeUI();
			updateEdgeDispUI();
			updateEdgeLayerUI();
			
			UI.previewWindow.update();
			
			UI.layersWindow.data.data	= Project.tile.layers;
			UI.edgeLayers.data.data		= Project.layer.edge.layers;
			
		}
		
		private function setEdgeLayer(v:EdgeLayer):void 
		{
			Project.edgeLayer = v;
			updateEdgeUI();
			updateEdgeLayerUI();
			
			UI.previewWindow.update();
			
		}
		
		//////////////////////
		
		private function projectOptionsChange():void 
		{
			Project.data.tileWidth		= Number(UI.properities.projectOptions.tileWidth.value);
			Project.data.tileScale		= Number(UI.properities.projectOptions.tileScaleY.value);
			Project.data.name			= UI.properities.projectOptions.projectName.value;
			Project.data.previewTile	= UI.properities.projectOptions.frame.slider.value;
			
			updateAllTiles();
			
		}
		
		
		private function updateProjectUI():void
		{
			UI.properities.projectOptions.tileWidth.value		= Project.data.tileWidth.toString();
			UI.properities.projectOptions.tileScaleY.value		= Project.data.tileScale.toString();
			UI.properities.projectOptions.projectName.value		= Project.data.name;
			UI.properities.projectOptions.frame.slider.value	= Project.data.previewTile;
		}
		//////////////////////
		
		private function updateTileUI():void 
		{
			UI.properities.tileOptions.imageName.value = Project.tile.name;
		}
		
		private function tileOptionsChange():void 
		{
			Project.tile.name			= UI.properities.tileOptions.imageName.value;
		}
		
		//////////////////////
		private function updateEdgeLayerUI():void 
		{
			if (!Project.edgeLayer) return;
			
			UI.properities.edgeLayerOptions.blend.blend				= Project.edgeLayer.blend;	
			UI.properities.edgeLayerOptions.amount.slider.value		= Project.edgeLayer.alpha;	
		}
		
		private function edgeLayerChange():void 
		{
			if (!Project.edgeLayer) return;
			
			Project.edgeLayer.blend		= UI.properities.edgeLayerOptions.blend.blend;
			Project.edgeLayer.alpha		= UI.properities.edgeLayerOptions.amount.slider.value;
			
			
		}
		
		//////////////////////
		
		private function updateEdgeUI():void 
		{
			if (!Project.layer) return;
			
			UI.properities.edgeOptions.blur.slider.value		 = Project.layer.edge.blur;	
			UI.properities.edgeOptions.brightness.slider.value	 = Project.layer.edge.brightness;	
			UI.properities.edgeOptions.contrast.slider.value	 = Project.layer.edge.contrast;
			//UI.properities.edgeOptions.enabled.value			 = Project.layer.edge.edgeProcess;
		}
		
		private function edgeOptionsChange():void 
		{
			if (!Project.layer) return;

			Project.layer.edge.blur 		= UI.properities.edgeOptions.blur.slider.value;
			Project.layer.edge.brightness 	= UI.properities.edgeOptions.brightness.slider.value;
			Project.layer.edge.contrast 	= UI.properities.edgeOptions.contrast.slider.value;
			//Project.layer.edge.edgeProcess 	= UI.properities.edgeOptions.enabled.value;
			
		}
		
		///////////////////////////////
		
		private function updateEdgeDispUI():void 
		{
			if (!Project.layer) return;
			
			UI.properities.edgeDistortOptions.amount.slider.value	= Project.layer.edge.displacementMapAmount;
			UI.properities.edgeDistortOptions.enabled.value			= Project.layer.edge.displacementMapEnabled; 	
		}
		
		private function edgeDistortChange():void 
		{
			if (!Project.layer) return;

			Project.layer.edge.displacementMapAmount 	= UI.properities.edgeDistortOptions.amount.slider.value;
			Project.layer.edge.displacementMapEnabled 	= UI.properities.edgeDistortOptions.enabled.value;
		}
		
		//////////////////////////////////
		
		private function updateImageUI():void 
		{
			if (!Project.layer) return;
			
			UI.properities.imageOptions.amount.slider.value = Project.layer.imageAlpha;
			UI.properities.imageOptions.blend.blend         = Project.layer.blend;	
		}
		
		private function imageOptionsChange():void 
		{
			if (!Project.layer) return;
			
			Project.layer.imageAlpha 	= UI.properities.imageOptions.amount.slider.value;
			Project.layer.blend 		= UI.properities.imageOptions.blend.blend;
		}
		
	}

}