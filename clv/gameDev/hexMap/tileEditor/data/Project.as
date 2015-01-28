package clv.gameDev.hexMap.tileEditor.data 
{
	import clv.gameDev.hexMap.tileEditor.outputs.HexeEdges;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.gameDev.hexMap.tileEditor.processors.HexEdgeBitmapGenerator;
	import clv.gameDev.hexMap.tileEditor.processors.HexTextureGenerator;
	import clv.gameDev.hexMap.tileEditor.storage.LastPoroject;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class Project 
	{
		
		private static var _data:ProjectData;
		
		private static var _tile:TileData;
		
		private static var _layer:LayerData;
		
		private static var _edgeLayer:EdgeLayer;
		
		private static var _tilesO2D:Dictionary;
		private static var _tilesD2O:Dictionary;
		private static var _tilesOutputs:Vector.<TileOutput> = new Vector.<TileOutput>();;
		
		static public function get data():ProjectData 
		{
			return _data;
		}
		
		static public function set data(value:ProjectData):void 
		{
			_data = value;
			
			LastPoroject.project = _data;
			
			_tile = _data.tiles[_data.tile];
			_layer = _tile.layers[_data.layer];
			_edgeLayer = _tile.layers[_data.layer].edge.layers > 0 ? _tile.layers[_data.layer].edge.layers[_data.endgeLayer] : null;
			
			_tilesO2D = new Dictionary();
			_tilesD2O = new Dictionary();
			_tilesOutputs.length = 0;
			
			TileOutput.queene = 0;
			
			for (var i:int = 0; i < _data.tiles.length; i++) 
			{
				registerTile(_data.tiles[i]);
				
			}
			
		}
		
		public static function registerTile(td:TileData):void
		{
			var to:TileOutput = new TileOutput();
			to.data = td;
			
			for (var i:int = 0; i < td.layers.length; i++) 
			{

				var el:EdgeLayer;

				if (!td.layers[i].edge.edgeMask)
				{
					el = new EdgeMask();
					el.tileData = td;
					td.layers[i].edge.layers.push(el);
				}
				
				if (!td.layers[i].edge.hexMask)
				{
					el = new HexEdgeMask();
					el.tileData = td;
					td.layers[i].edge.layers.push(el);
				}
				
				var e:HexeEdges = HexEdgeBitmapGenerator.getNewEdges();
				HexEdgeBitmapGenerator.drawMasks(td.layers[i].edge, e);
				to.edges.push(e);
				
			}
			
			_tilesO2D[to] = td;
			_tilesD2O[td] = to;
			
			_tilesOutputs.push(to);
			
		}
		
		public static function registerLayer(l:LayerData):void 
		{
			var e:HexeEdges = HexEdgeBitmapGenerator.getNewEdges();
			
			HexEdgeBitmapGenerator.drawMasks(l.edge, e);
			
			Project.getTileOutput(l.tileData).edges.push(e);
				
		}
		
		
		static public function get tile():TileData 
		{
			return _tile;
		}
		
		static public function set tile(value:TileData):void 
		{
			_tile = value;
		}
		
		static public function get layer():LayerData 
		{
			return _layer;
		}
		
		static public function set layer(value:LayerData):void 
		{
			_layer = value;
		}
		
		static public function get edgeLayer():EdgeLayer 
		{
			return _edgeLayer;
		}
		
		static public function set edgeLayer(value:EdgeLayer):void 
		{
			_edgeLayer = value;
		}
		
		static public function get tilesOutputs():Vector.<TileOutput> 
		{
			return _tilesOutputs;
		}
		
		
		public static function getTileOutput(d:TileData):TileOutput
		{
			return _tilesD2O[d];
		}
		
		
	}

}