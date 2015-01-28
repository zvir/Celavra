package clv.gameDev.hexMap.tileEditor.ui 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.games.theFew.gui.components.button.ToggleButton;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.ToggleButtonMD;
	import zvr.zvrGUI.components.minimalDark.WindowMD;
	import zvr.zvrGUI.core.relays.ZvrSwitchGroup;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrBitmap;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.events.ZvrSelectedEvent;
	import zvr.zvrGUI.layouts.ZvrBitmapAutoSize;
	import zvr.zvrGUI.layouts.ZvrHorizontalLayout;
	import zvr.zvrGUI.utils.ZvrComponentUtils;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class PreviewWindow extends WindowMD 
	{
		
		private static const R:Number = 1.1547;
		
		static public const MASK		:String = "mask";		
		static public const MASK_LAYER	:String = "maskLayer";	
		static public const LAYER		:String = "layer";		
		static public const TILE		:String = "tile";		
		static public const EXAMPLE		:String = "example";	
		
		
		private var _mask			:ToggleButtonMD;
		private var _maskLayer		:ToggleButtonMD;
		private var _layer			:ToggleButtonMD;
		private var _tile			:ToggleButtonMD;
		private var _example		:ToggleButtonMD;
			
		private var _menu			:ZvrSwitchGroup;
			
		private var _zoom			:ToggleButtonMD;
		private var _smoothing		:ToggleButtonMD;
		
		private var _bitmap			:ZvrBitmap;
		private var _tileOutput		:TileOutput;
		
		public var _mode		:String
		
		
		private var _ex:BitmapData
		
		public function PreviewWindow() 
		{
			ZvrComponentUtils.setupStaticWindow(this);
			title.text = "PreviewWindow";
			
			contentPadding.padding = 10;
			
			_mode = TILE;
			
			_menu = new ZvrSwitchGroup();
			
			_menu.setLayout(ZvrHorizontalLayout);
			ZvrHorizontalLayout(_menu.layout).gap = 3;
			_menu.autoSize = ZvrAutoSize.CONTENT;
			
			_mask		= new ToggleButtonMD();
			_maskLayer	= new ToggleButtonMD();
			_layer		= new ToggleButtonMD();
			_tile		= new ToggleButtonMD();
			_example	= new ToggleButtonMD();
			
			_mask		.label.text = "Mask";
			_maskLayer	.label.text = "Mask Layer";
			_layer		.label.text = "Layer";
			_tile	    .label.text = "Tile";
			_example	.label.text = "Example";
			
			_mask		.autoSize = ZvrAutoSize.MANUAL;
			_maskLayer	.autoSize = ZvrAutoSize.MANUAL;
			_layer		.autoSize = ZvrAutoSize.MANUAL;
			_tile	    .autoSize = ZvrAutoSize.MANUAL;
			_example	.autoSize = ZvrAutoSize.MANUAL;
			
			_mask		.height = 30;
			_maskLayer	.height = 30;
			_layer		.height = 30;
			_tile	    .height = 30;
			_example	.height = 30;
			
			_mask		.width = 120;
			_maskLayer	.width = 120;
			_layer		.width = 120;
			_tile	    .width = 120;
			_example	.width = 120;
			
			_menu.addChild(_tile		);
			_menu.addChild(_layer		);
			_menu.addChild(_mask		);
			_menu.addChild(_maskLayer	);
			_menu.addChild(_example		);
			
			addChild(_menu);
			
			
			_bitmap = new ZvrBitmap();
			_bitmap.top = 40;
			_bitmap.bottom = 0;
			_bitmap.right = 0;
			_bitmap.left = 0;
			_bitmap.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			
			addChild(_bitmap);
			
			_tile.selected = true;
			
			_menu.addEventListener(ZvrSelectedEvent.SELECTED_CHANGE, selectedChange);
			
			var g:ZvrGroup;
			
			g = new ZvrGroup();
			g.setLayout(ZvrHorizontalLayout);
			g.autoSize = ZvrAutoSize.CONTENT;
			g.top = 0;
			g.right = 0;
			
			_zoom = new ToggleButtonMD();
			_zoom.autoSize = ZvrAutoSize.MANUAL;
			_zoom.width = 80;
			_zoom.height = 30;
			_zoom.label.text = "Zoom";
			g.addChild(_zoom);
			_zoom.selected = true;
			_zoom.addEventListener(ZvrSelectedEvent.SELECTED_CHANGE, zoomChange);
			
			_smoothing = new ToggleButtonMD();
			_smoothing.autoSize = ZvrAutoSize.MANUAL;
			_smoothing.width = 80;
			_smoothing.height = 30;
			_smoothing.label.text = "Soothing";
			
			_smoothing.addEventListener(ZvrSelectedEvent.SELECTED_CHANGE, smoothingChange);
			
			g.addChild(_smoothing);
			
			
			addChild(g);
			
			_ex = new BitmapData(1000, 1000, true, 0);
			
			
			
		}
		
		private function zoomChange(e:ZvrSelectedEvent):void 
		{
			if (_zoom.selected)
			{
				_bitmap.resetComponent();
				_bitmap.top = 40;
				_bitmap.bottom = 0;
				_bitmap.right = 0;
				_bitmap.left = 0;
				_bitmap.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			}
			else
			{
				_bitmap.resetComponent();
				_bitmap.verticalCenter = 15;
				_bitmap.horizontalCenter = 0;
				_bitmap.scaleMode = ZvrBitmapAutoSize.AUTO_TO_NO_SCALE;
			}
		}
		
		private function smoothingChange(e:ZvrSelectedEvent):void 
		{
			_bitmap.bitmap.smoothing = _smoothing.selected;
		}
		
		private function selectedChange(e:ZvrSelectedEvent):void 
		{
			if (!e.selected) return;
			
			switch (e.component) 
			{
				case _tile		:	_mode = TILE		; break;
				case _layer		:	_mode = LAYER		; break;
				case _mask		:	_mode = MASK		; break;
				case _maskLayer	:	_mode = MASK_LAYER	; break;
				case _example	:	_mode = EXAMPLE		; break;
			}
			update();
		}
		
		public function update():void
		{
			
			if (_tileOutput) 
			{
				_tileOutput.updated.remove(tileUpdated);
			}
			
			_tileOutput =  Project.getTileOutput(Project.tile);
			
			if (!_tileOutput) return;
			
			if (_tileOutput.bitmaps.length == 0) return;
			
			
			_tileOutput.updated.add(tileUpdated);
			
			switch (_mode) 
			{
				case MASK		: _bitmap.bitmapData = _tileOutput.edges[_tileOutput.data.layers.indexOf(Project.layer)].edges[Project.data.previewTile].mask; break;
				case MASK_LAYER	: _bitmap.bitmapData =  Project.edgeLayer.bitmapData;  break;
				case LAYER		: _bitmap.bitmapData = _tileOutput.layers[_tileOutput.data.layers.indexOf(Project.layer)][Project.data.previewTile]; break;
				case TILE		: _bitmap.bitmapData = _tileOutput.bitmaps[Project.data.previewTile]; break;
				case EXAMPLE	: _bitmap.bitmapData =  drawExample(); break;
			}
			
			_bitmap.bitmap.smoothing = _smoothing.selected;
		}
		
		private function tileUpdated(t:TileOutput):void 
		{
			update();
		}
		
		
		private function drawExample():BitmapData
		{
			
		/*	ExampleData.map.sortOn(["3", "2"], [Array.NUMERIC, Array.NUMERIC]);
			
			var a:Array = ExampleData.map;
			*/
			
			
			var m:Matrix = new Matrix();
			
			var w:Number = Project.data.tileWidth;
			var h:Number = Math.floor(Project.data.tileWidth * Project.data.tileScale * R * 0.75);
			
			_ex = new BitmapData(w * 8.5, Project.data.tileWidth * Project.data.tileScale * R * 8, true, 0);
			_ex.fillRect(_ex.rect, 0);
			
			for (var i:int = 0; i < ExampleData.map.length; i++) 
			{
				var v:Array = ExampleData.map[i];
				
				m.identity();
				
				var ro:Number = v[3] % 2 ? w * 0.5 : 0;
				
				m.translate(v[2] * w - ro, v[3] * h);
				
				_ex.draw(_tileOutput.getTileBitmap(v[0], v[1]), m);
			}
			
			return _ex;
			
		}
		
	}

}

/*

*/