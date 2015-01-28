package clv.genome2d.components.renderables.hexMap 
{
	import clv.gameDev.hexMap.aStar.HexAStar;
	import clv.gameDev.hexMap.mapData.LayerData;
	import clv.gameDev.hexMap.mapData.TileData;
	import clv.gameDev.hexMap.tileEditor.data.BinaryEdges;
	/**
	 * ...
	 * @author Zvir
	 */
	public class HexMapUtils 
	{
		private static var _randoms:Array = [];
		
		public function HexMapUtils() 
		{
			
		}
		
		public static function draw(map:HexMap, q:int, r:int, l:LayerData, brushType:int, brushAlpha:Number):void
		{
			
			if (!l) return;
			
			var t:TileData = l.tiles[q][r];
			
			t.fill = true;
			t.alpha = brushAlpha;
			
			var e:Boolean = processEdges(l);
			
			if (e)
			{
				t.edge = HexMapProcessor.getEdge(q, r, l);
				t.type = l.autoType ? getRandomTypeForEdge(map, q, r, l, t.edge, t.fill) : brushType;
				updateNeightbours(map, q, r, l, brushType);
			}
			else
			{
				t.edge = 0;
				t.type = l.autoType ? getRandom(map, q, r, l) : brushType;
			}
			
			
			updateRender(map, e, q, r, l);
			
		}
		
		public static function erase(map:HexMap, q:int, r:int, layer:LayerData, brushType:int):void
		{
			
			var t:TileData = layer.tiles[q][r];
			
			t.fill = false;

			var e:Boolean = processEdges(layer)
			
			if (e)
			{
				t.edge = HexMapProcessor.getEdge(q, r, layer);
				updateNeightbours(map, q, r, layer, brushType);
				t.alpha = HexMapProcessor.getAlpha(q, r, layer);
			}
			else
			{
				t.edge = 0;
				t.alpha = 0;
			}
			
			t.type = 0;
			
			updateRender(map, e, q, r, layer);
			
		}
		
		private static function processEdges(l:LayerData):Boolean
		{
			if (!l.asset) return false;
			
			for (var i:int = 0; i < l.asset.types.length; i++) 
			{
				if (l.asset.types[i].textures.length == 58) return true;
			}
			return false;
		}
		
		private static function updateRender(map:HexMap, e:Boolean, q:int, r:int, layer:LayerData):void 
		{
			var t:HexTile = map.getTile(q, r);
			
			map.updateTileLayer(t, layer);
			
			if (!e) return;
			
			var n:Vector.<HexTile> = map.getNeighbors(t);
			
			for (var i:int = 0; i < n.length; i++) 
			{
				if (n[i])
				{
					map.updateTileLayer(n[i], layer);
				}
			}
		}
		
		private static function updateNeightbours(map:HexMap, q:int, r:int, l:LayerData, brushType:int):void 
		{
			var n:Vector.<TileData> = HexMapProcessor.getNeighbors(q, r, l);
			var c:Array				= HexMapProcessor.getNeighborsCoords(q, r);
			
			for (var i:int = 0; i < n.length; i++) 
			{
				var t:TileData = n[i];
				
				if (!t) continue;
				
				t.edge = HexMapProcessor.getEdge(c[i][0], c[i][1], l);
				
				t.type = l.autoType ? getRandomTypeForEdge(map, c[i][0], c[i][1], l, t.edge, t.fill) : brushType;
				
				if (!t.fill) t.alpha = HexMapProcessor.getAlpha(c[i][0], c[i][1], l);
			}
			
		}
		
		private static function getRandomTypeForEdge(map:HexMap, q:int, r:int, l:LayerData, edge:int, fill:Boolean):int 
		{
			
			var e:uint =  edge << 1;
			if (fill) e ++;
			e =  BinaryEdges.edgesToIndex[e];
			
			var a:Array = [];
			
			for (var j:int = 0; j < l.asset.types.length; j++) 
			{
				if (e < l.asset.types[j].textures.length && l.asset.types[j].textures[e]);
				{
					a.push(j);
				}
			}
			
			if (a.length == 1) 
			{
				return a[0];
			}
			
			if (a.length > _randoms.length || _randoms[a.length] == undefined)
			{
				_randoms[a.length] = HexMapProcessor.getRandomValues(map.mapData.width, map.mapData.height, a.length);	
			}
			
			
			return a[_randoms[a.length][q][r]];
			
		}
		
		private static function getRandom(map:HexMap, q:int, r:int, l:LayerData):int
		{
			
			var i:int = l.asset.types.length;
			
			if (i > _randoms.length || _randoms[i] == undefined)
			{
				_randoms[i] = HexMapProcessor.getRandomValues(map.mapData.width, map.mapData.height, i);	
			}
			
			return _randoms[i][q][r];
		}
	}

}