package clv.genome2d.components.renderables 
{
	import clv.gameDev.hexMap.tileEditor.data.TileTypes;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexMapProcessor 
	{
		
		public static function processAllLayers(map:GHexMap, dict:IGHexMapDict):void
		{
			for (var i:int = 0; i < dict.mocups.length; i++) 
			{
				checkLayerEdges(map, i);
				setLayerEdges(map, dict, i);
			}
			
			setTilesBG(map, dict);
		}
		
		public static function processLayer(map:GHexMap, dict:IGHexMapDict, layer:int):void
		{
			checkLayerEdges(map, layer);
			setLayerEdges(map, dict, layer);
			setTilesBG(map, dict);
		}
		
		public static function processTileLayer(map:GHexMap, dict:IGHexMapDict, tile:GHexTile, layer:int):void
		{
			if (dict.mocups[layer].processEdges)
			{
				var n:Vector.<GHexTile> = map.getNeighbors(tile);
				
				for (var i:int = 0; i < n.length; i++) 
				{
					if (n[i]) checkTileEdges(map, n[i], layer);
				}
				
				checkTileEdges(map, tile, layer);

				for (i = 0; i < n.length; i++) 
				{
					if (n[i]) 
					{
						setTileEdges(map, dict, n[i], layer);
						setTileBG(map, dict, n[i]);
					}
				}
				
				setTileEdges(map, dict, tile, layer);
				setTileBG(map, dict, tile);
			}
			else
			{
				if (tile.layers[layer].fill)
				{
					tile.layers[layer].edgeType = 67;
					dict.updateLayer(tile, layer);
				}
				else
				{
					tile.layers[layer].edgeType = 66;
					dict.updateLayer(tile, layer);
				}
			}
			
		}
		
		private static function checkLayerEdges(map:GHexMap, layer:int):void 
		{
			var tiles:Vector.<GHexTile> = map.tiles;
			for (var i:int = 0; i < tiles.length; i++) 
			{
				checkTileEdges(map, tiles[i], layer);
			}
		}
		
		
		private static function checkTileEdges(map:GHexMap, tile:GHexTile, layer:int):void 
		{
			var n:Vector.<GHexTile> = map.getNeighbors(tile);

			tile.layers[layer].edges.length = 0;
			
			for (var j:int = 0; j < n.length; j++) 
			{
				var nt:GHexTile = n[j];
				
				if (nt && nt.layers[layer].fill != tile.layers[layer].fill)
				{
					tile.layers[layer].edges.push(j);
				}
			}
		}
		
		private static function setLayerEdges(map:GHexMap, dict:IGHexMapDict, layer:int):void 
		{
			
			var tiles:Vector.<GHexTile> = map.tiles;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				var t:GHexTile = tiles[i];
				var l:GHexTileLayer = t.layers[layer];
				if (!l.fill) l.texture = null;
			}
			
			for (i = 0; i < tiles.length; i++) 
			{
				setTileEdges(map, dict, tiles[i], layer);
			}
		}
		
		private static function setTileEdges(map:GHexMap, dict:IGHexMapDict, tile:GHexTile, layer:int):void 
		{
			var l:GHexTileLayer = tile.layers[layer];
			
			var c:Object = getTypeAndRotation(l.edges);
			
			if (l.edges.length > 1 && l.fill)
			{
				l.edgeType = TileTypes.getID(c.t, c.r);
			}
			else if (l.edges.length > 1 && c.t != 13 && !l.fill)
			{
				if (c.t < 5) c.t += 5;
				else if (c.t == 14) c.t = 15;
				else if (c.t == 10) c.t = 11;
				
				
				l.edgeType = TileTypes.getID(c.t, c.r);
				
				l.alpha = getAlphaOfNeighbors(tile, layer, map);
			}
			else if (!l.fill)
			{
				l.edgeType = TileTypes.getID(12, 0);
			}
			else if (l.fill)
			{
				l.edgeType = TileTypes.getID(13, 0);
			}
			
			var n:Vector.<GHexTile> = map.getNeighbors2(tile);
			
			var s:String = "";
			
			for (var i:int = 0; i < n.length; i++) 
			{
				var nt:GHexTile = n[i];
				
				if (nt && nt.layers[layer].fill)
				{
					s = s + "1"; 
				}
				else
				{
					s = s + "0"; 
				}
			}
			
			i = parseInt(s, 2);
			
			l.edgeType2 = i;
			
			dict.updateLayer(tile, layer);
		}
		
		private static function setTilesBG(map:GHexMap, dict:IGHexMapDict):void
		{
			var tiles:Vector.<GHexTile> = map.tiles;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				setTileBG(map, dict, tiles[i]);
			}
		}
		
		private static function setTileBG(map:GHexMap, dict:IGHexMapDict, tile:GHexTile):void
		{
			tile.bgLayer = 0;
			
			for (var j:int = 0; j < tile.layers.length; j++) 
			{
				var l:GHexTileLayer = tile.layers[j];
				
				if (l.fill && l.alpha == 1 && dict.isBg(j, l.edgeType))
					tile.bgLayer = j;
			}
		}
		
		private static function getTypeAndRotation(v:Array):Object
		{
			var r:Array = [];
			
			var i:int = 0;
			
			while (i < v.length)
			{
				var l:int = edgeContinuity(v, i, 1);
				
				if (l > 1) r.push([i, l]);
				
				i += l;
				
			}
			
			var o:Object = { };
			
			if (r.length == 1)
			{
				
				if (r[0][1] == 6)
				{
					o.t = 14;
					o.r = 0;
				}
				else
				{
					o.r = v[r[0][0]];
					o.t = r[0][1] - 2;
				}
			}
			else if (r.length == 2)
			{
				if (r[0][1] > r[1][1])
				{
					o.r = v[r[0][0]];
					o.t = r[0][1] - 2;
				}
				else if (r[0][1] < r[1][1])
				{
					o.r = v[r[1][0]];
					o.t = r[1][1] - 2;
				}
				else
				{
					
					o.r = v[r[0][0]];
					
					if (o.r == 3) o.r = 0;
					if (o.r == 4) o.r = 1;
					if (o.r == 5) o.r = 2;
					
					o.t = 10;
				}
			}
			else
			{
				o.r = 0;
				o.t = 13;
			}
			
			return o;
			
		}
		
		private static function getAlphaOfNeighbors(t:GHexTile, layer:int, map:GHexMap):Number
		{
			var n:Vector.<GHexTile> = map.getNeighbors(t);
					
			var na:Number = 0;
			
			var nc:int;
			
			for (var k:int = 0; k < n.length; k++) 
			{
				if (n[k] && n[k].layers[layer].fill)
				{
					na += n[k].layers[layer].alpha;
					nc++;
				}
			}
			
			return na / nc;
		}
		
		private static function edgeContinuity(v:Array, start:int, l:int):int
		{
			if (l == 6) return l;
			
			var i:int = start % v.length;
			var mi:int = Math.floor( start / v.length);
			var j:int = (start + 1) % v.length;
			var mj:int =  Math.floor( (start + 1) / v.length);
			
			var p:int = v[j] + 6 * mj;
			var r:int =  v[i] + 6 * mi;
			
			if (p - r == 1) 
				return edgeContinuity(v, start + 1, l + 1);
			else return l;
			
		}
		
		
		
	}

}