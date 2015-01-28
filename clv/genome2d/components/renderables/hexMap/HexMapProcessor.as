package clv.genome2d.components.renderables.hexMap 
{
	import clv.gameDev.hexMap.mapData.LayerData;
	import clv.gameDev.hexMap.mapData.MapData;
	import clv.gameDev.hexMap.mapData.TileData;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexMapProcessor 
	{
		
		public static function processAllLayers(map:HexMap, mapData:MapData):void
		{
			for (var i:int = 0; i < mapData.layers.length; i++) 
			{
				checkLayerEdges(map, i);
				setLayerEdges(map, mapData, i);
			}
			
			setTilesBG(map, mapData);
		}
		
		public static function processLayer(map:HexMap, mapData:MapData, layer:int):void
		{
			checkLayerEdges(map, layer);
			setLayerEdges(map, mapData, layer);
			setTilesBG(map, mapData);
		}
		
		public static function processTileLayer(map:HexMap, mapData:MapData, tile:HexTile, layer:int):void
		{
			if (mapData.layers[layer].processEdges)
			{
				var n:Vector.<HexTile> = map.getNeighbors(tile);
				
				for (var i:int = 0; i < n.length; i++) 
				{
					if (n[i]) checkTileEdges(map, n[i], layer);
				}
				
				checkTileEdges(map, tile, layer);

				for (i = 0; i < n.length; i++) 
				{
					if (n[i]) 
					{
						setTileEdges(map, mapData, n[i], layer);
						setTileBG(map, mapData, n[i]);
					}
				}
				
				setTileEdges(map, mapData, tile, layer);
				setTileBG(map, mapData, tile);
			}
			else
			{
				if (tile.layers[layer].fill)
				{
					tile.layers[layer].edgeType = 67;
					//mapData.updateLayer(tile, layer);
				}
				else
				{
					tile.layers[layer].edgeType = 66;
					//mapData.updateLayer(tile, layer);
				}
			}
			
		}
		
		private static function checkLayerEdges(map:HexMap, layer:int):void 
		{
			var tiles:Vector.<HexTile> = map.tiles;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				checkTileEdges(map, tiles[i], layer);
			}
		}
		
		
		private static function checkTileEdges(map:HexMap, tile:HexTile, layer:int):void 
		{
			var n:Vector.<HexTile> = map.getNeighbors(tile);

			tile.layers[layer].edges.length = 0;
			
			for (var j:int = 0; j < n.length; j++) 
			{
				var nt:HexTile = n[j];
				
				if (nt && nt.layers[layer].fill != tile.layers[layer].fill)
				{
					tile.layers[layer].edges.push(j);
				}
			}
		}
		
		private static function setLayerEdges(map:HexMap, mapData:MapData, layer:int):void 
		{
			
			var tiles:Vector.<HexTile> = map.tiles;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				var t:HexTile = tiles[i];
				var l:HexTileLayer = t.layers[layer];
				if (!l.fill) l.texture = null;
			}
			
			for (i = 0; i < tiles.length; i++) 
			{
				setTileEdges(map, mapData, tiles[i], layer);
			}
		}
		
		private static function setTileEdges(map:HexMap, mapData:MapData, tile:HexTile, layer:int):void 
		{
			var l:HexTileLayer = tile.layers[layer];
			
			/*var c:Object = getTypeAndRotation(l.edges);
			
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
			}*/
			
			var n:Vector.<HexTile> = map.getNeighbors(tile);
			
			var s:String = "";
			
			for (var i:int = 0; i < n.length; i++) 
			{
				var nt:HexTile = n[i];
				
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
			
			l.edge = i;
			
			if (!l.fill) l.alpha = getAlphaOfNeighbors(tile, layer, map);
			
			//mapData.updateLayer(tile, layer);
		}
		
		private static function setTilesBG(map:HexMap, mapData:MapData):void
		{
			var tiles:Vector.<HexTile> = map.tiles;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				setTileBG(map, mapData, tiles[i]);
			}
		}
		
		private static function setTileBG(map:HexMap, mapData:MapData, tile:HexTile):void
		{
			/*tile.bgLayer = 0;
			
			for (var j:int = 0; j < tile.layers.length; j++) 
			{
				var l:HexTileLayer = tile.layers[j];
				
				if (l.fill && l.alpha == 1 && mapData.isBg(j, l.edgeType))
					tile.bgLayer = j;
			}*/
		}
		
		
		private static function getAlphaOfNeighbors(t:HexTile, layer:int, map:HexMap):Number
		{
			var n:Vector.<HexTile> = map.getNeighbors(t);
					
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
		
		/*private static function edgeContinuity(v:Array, start:int, l:int):int
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
			
		}*/
		
		public static function getEdge(q:int, r:int, layer:LayerData):int 
		{

			var n:Vector.<TileData> = getNeighbors(q, r, layer);
			
			var s:String = "";
			
			for (var i:int = 0; i < n.length; i++) 
			{
				var nt:TileData = n[i];
				
				if (nt && nt.fill)
				{
					s = s + "1"; 
				}
				else
				{
					s = s + "0"; 
				}
			}
			
			
			i = parseInt(s, 2);
			
			return i;
			
		}
		
		public static function getNeighbors(q:int, r:int, l:LayerData):Vector.<TileData>
		{

			var v:Vector.<TileData> 
			
			
			if (r % 2)
			{			
				v = new <TileData>[
					
					getLayerDataTile(q + 1, r + 0, l),
					getLayerDataTile(q + 1, r + 1, l),
					getLayerDataTile(q + 0, r + 1, l),
					getLayerDataTile(q - 1, r + 0, l),
					getLayerDataTile(q + 0, r - 1, l),
					getLayerDataTile(q + 1, r - 1, l)
				];
			}
			else
			{
				v = new <TileData>[
					getLayerDataTile(q + 1, r + 0, l),
					getLayerDataTile(q + 0, r + 1, l),
					getLayerDataTile(q - 1, r + 1, l),
					getLayerDataTile(q - 1, r + 0, l),
					getLayerDataTile(q - 1, r - 1, l),
					getLayerDataTile(q + 0, r - 1, l)
				];
			}
			
			return v;
			
		}
		
		private static function getLayerDataTile(q:int, r:int, l:LayerData):TileData
		{
			if (!l) return null;
			
			if (q < 0 || l.tiles.length <= q) return null;
			if (r < 0 || l.tiles[q].length <= r) return null;
			
			return l.tiles[q][r];
		}
		
		public static function getNeighborsCoords(q:int, r:int):Array
		{

			var v:Array
			
			
			if (r % 2)
			{			
				v = [
						[q + 1,r + 0],
						[q + 1,r + 1],
						[q + 0,r + 1],
						[q - 1,r + 0],
						[q + 0,r - 1],
						[q + 1,r - 1]
				];
			}
			else
			{
				v = [
						[q + 1,r + 0],
						[q + 0,r + 1],
						[q - 1,r + 1],
						[q - 1,r + 0],
						[q - 1,r - 1],
						[q + 0,r - 1]
				];
			}
			
			return v;
			
		}
		
		static public function getAlpha(q:int, r:int, l:LayerData):Number 
		{
			var t:TileData = l.tiles[q][r];
			
			if (t.fill) return t.alpha;
			
			var n:Vector.<TileData> = getNeighbors(q, r, l);
					
			var na:Number = 0;
			
			var nc:int;
			
			for (var k:int = 0; k < n.length; k++) 
			{
				if (n[k] && n[k].fill)
				{
					na += n[k].alpha;
					nc++;
				}
			}
			
			return na / nc;
			
			
		}
		
		public static function getRandomValues(w:int, h:int, max:int):Array
		{
			var a:Array = new Array(w);
			
			for (var q:int = 0; q < w; q++) 
			{
				a[q] = new Array(h);
			}
			
			for (var r:int = 0; r < h; r++) 
			{
				for (q = 0; q < w; q++) 
				{
					a[q][r] = getUniqueRandomExept(getNeghboursValues(q, r, a), max, r * w + q);
				}
			}
			
			return a;
			
		}
		
		private static function getUniqueRandomExept(a:Array, l:int, z:int):int
		{
			var b:Array = [];
			
			for (var i:int = 0; i < l; i++) 
			{
				if (a.indexOf(i) == -1)	b.push(i);
			}
			
			var r:int = Math.abs(Math.sin(z)) * b.length;
			
			r = b[r];
			
			return r;
		}
		
		private static function getNeghboursValues(q:int,r:int, a:Array):Array
		{
			
			 var neighbors:Array = [
			   [ [ 0, -1], [-1, -1], [-1,  0] ],
			   [ [+1, -1], [ 0, -1], [-1,  0] ]
			]
			
			var n:Array = r % 2 ? neighbors[1] : neighbors[0];
			
			var ar:Array = [];
			
			for (var i:int = 0; i < n.length; i++) 
			{
				var qn:int = q + n[i][0];
				var rn:int = r + n[i][1];
				
				if (qn < 0 || rn < 0 || qn >= a.length || a[qn] == undefined || rn >= a[qn].length) continue;
				
				if (a[qn][rn] != undefined)	ar.push(a[qn][rn]);
				
			}
			
			return ar;
		}
		
		
		
	}

}