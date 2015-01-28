package clv.genome2d.components.renderables 
{
	import clv.gameDev.hexMap.tileEditor.data.TileTypes;
	import clv.genome2d.components.renderables.HexMapLayer;
	import clv.games.theFew.assets.textures.strategy.map.mapTiles.MapTiles;
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.IRenderable;
	import com.genome2d.context.filters.GBloomPassFilter;
	import com.genome2d.context.filters.GBlurPassFilter;
	import com.genome2d.context.filters.GDesaturateFilter;
	import com.genome2d.context.filters.GFilter;
	import com.genome2d.context.filters.GHDRPassFilter;
	import com.genome2d.context.GBlendMode;
	import com.genome2d.context.GContextCamera;
	import com.genome2d.context.IContext;
	import com.genome2d.node.GNode;
	import com.genome2d.textures.GTexture;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import utils.color.getRGB;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class GHexMap extends GComponent implements IRenderable
	{
		public var xOffset:int;
		public var yOffset:int;
		
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		public var rowHeight:Number;
		
		private var _tiles:Vector.<GHexTile> = new Vector.<GHexTile>();
		
		private var _tilesCords:Array = [];
		
		private var _mapWidth:int;
		private var _mapHeight:int;
		
		private var dict:IGHexMapDict;
		private var filter:GFilter;
		
		public var viewWidth:int;
		public var viewHeight:int;
		
		public var viewX:Number = 0;
		public var viewY:Number = 0;
		
		public var scale:Number = 1;

		public var fillType:Array = [];
		
		private var chashed:Array = [];
		
		public function GHexMap()
		{
			super();
		}
		
		
		public function redraw():void 
		{
			var last:GHexTile;
			var c:int;
			
			_tiles.length = 0;
			_tilesCords.length = _mapHeight;
			
			for (var j:int = 0; j < _mapHeight; j++) 
			{
				
				_tilesCords[j] = new Array(_mapWidth);
				
				for (var i:int = 0; i < _mapWidth; i++) 
				{
					
					var t:GHexTile;
					
					t = new GHexTile(this, i, j, c);
					
					c++;
					
					_tilesCords[j][i] = t;
					
					_tiles.push(t);
					
					for (var k:int = 0; k < dict.mocups.length; k++) 
					{
						
						var m:HexMapLayer = dict.mocups[k];
						
						var l:GHexTileLayer = new GHexTileLayer();
						
						l.alpha = m.getAlpha(i, j);
						l.type = m.getType(i, j);
						l.fill = m.getFill(i, j);
						l.edgeType = m.getEdge(i, j);
						l.edgeType2 = m.getEdge2(i, j);
						
						l.index = k;
						
						t.layers.push(l);
						dict.updateLayer(t, k, m.getTile(i, j));
					}
				}
			}
		}
		
		public function process():void
		{
			HexMapProcessor.processAllLayers(this, dict);
		}
		
		public function processLayer(l:int):void
		{
			HexMapProcessor.processLayer(this, dict, l);
		}
		
		public function processTile(l:int, tile:GHexTile):void
		{
			HexMapProcessor.processTileLayer(this, dict, tile, l);
		}
		
		public function initMap(mapWidth:int, mapHeight:int, tileWidth:Number, tileHeight:Number, dict:IGHexMapDict):void
		{
			this.dict = dict;
			this.tileHeight = tileHeight;
			this.tileWidth = tileWidth;
			
			this.rowHeight = tileHeight * 0.75;
			
			_mapWidth = mapWidth;
			_mapHeight = mapHeight;
			
			redraw();
		}
		
		public function render(p_camera:GContextCamera, p_useMatrix:Boolean):void 
		{
			
			var vw:Number = viewWidth / scale;
			var vh:Number = viewHeight / scale;
			
			var mapHalfWidth:Number = tileWidth * _mapWidth * .5;
			var mapHalfHeight:Number = rowHeight * _mapHeight * .5;
			
			// Position of top left tile from map center
			var firstX:Number = -mapHalfWidth + tileWidth;
			var firstY:Number = -mapHalfHeight;
			
			// Index of top left visible tile
			var indexX:int = (viewX - firstX) / tileWidth;
			if (indexX < 0) indexX = 0;
			
			var indexY:int = (viewY - firstY) / rowHeight;
			if (indexY < 0) indexY = 0;		
			
			
			var endX:Number = viewX + vw;
			
			var endY:Number = viewY + vh;
		
			var indexWidth:int = (endX - firstX) / tileWidth - indexX + 2;
			
			if (indexWidth > _mapWidth - indexX) indexWidth = _mapWidth - indexX;
			
			var indexHeight:int = (endY - firstY) / rowHeight - indexY + 2;
			
			if (indexHeight > _mapHeight - indexY) indexHeight = _mapHeight - indexY;
			
			var tileCount:int = indexWidth * indexHeight;
			
			var cos:Number = Math.cos(node.transform.g2d_worldRotation);
			var sin:Number = Math.sin(node.transform.g2d_worldRotation);
			
			var layers:Array = dict.layers;
			
			
			
			for (var j:int = 0; j < layers.length; j++) 
			{
				for (var i:int = 0; i < tileCount; ++i)
				{
					var index:int = indexY * _mapWidth + indexX + int(i / indexWidth) * _mapWidth + i % indexWidth;
					
					var t:GHexTile = _tiles[index]
					
					for (var k:int = 0; k < layers[j].length; k++) 
					{
						if (t && j >= t.bgLayer) 
						{
							renderTile(t, layers[j][k], sin, cos);
							
							
							
						}
					}
				}
			}
			
		}
		
		private function renderTile(tile:GHexTile, layer:int, sin:Number, cos:Number):void 
		{
			
			var l:GHexTileLayer = tile.layers[layer];
			
			if (!l.texture) return;
			if (l.alpha == 0) return;
			
			var tx:Number = (tile.x * cos - tile.y * sin) * node.transform.g2d_worldScaleX  + node.transform.g2d_worldX - viewX - _mapWidth * tileWidth / 2;
			var ty:Number = (tile.y * cos + tile.x * sin) * node.transform.g2d_worldScaleY  + node.transform.g2d_worldY - viewY - _mapHeight * rowHeight / 2;
			
			var c:IContext = node.core.g2d_context;

			//GBloomPassFilter(filter).texture = l.texture;
			
			c.draw(
				l.texture,
				tx * scale,
				ty * scale, 
				node.transform.g2d_worldScaleX * scale,
				node.transform.g2d_worldScaleY * scale,
				node.transform.g2d_worldRotation, 
				node.transform.g2d_worldRed, 
				node.transform.g2d_worldGreen, 
				node.transform.g2d_worldBlue,
				node.transform.g2d_worldAlpha * l.alpha,
				GBlendMode.NORMAL, filter
			);
			
			//filter.clear(c);
		}
		
		public function getGHexTile(collumn:int, row:int):GHexTile
		{
			var i:int = row * _mapWidth + collumn;
			
			if (i < 0) return null;
			if (i >= _tiles.length) return null;
			
			return _tiles[i];	
		}
		
		public function getMapUnderPoint(px:Number, py:Number):GHexTile
		{
			// tile offset fix
			px -= tileWidth / 2;
			
			// tile scale fix
			px *= (Math.sqrt(3) / 2 * tileHeight) / tileWidth;
			
			
			// Approximate location, axial
			var q:Number = (1 / 3 * Math.sqrt(3) * px - 1 / 3 * py) / (tileHeight/2);
			var r:Number = 2 / 3 * py / (tileHeight/2);
			
			
			// axial to cube
			var x:Number = q;
			var z:Number = r;
			var y:Number = -x - z;
			
			
			// rounding cube
			var rx:Number = Math.round(x);
			var ry:Number = Math.round(y);
			var rz:Number = Math.round(z);

			var x_diff:Number = Math.abs(rx - x);
			var y_diff:Number = Math.abs(ry - y);
			var z_diff:Number = Math.abs(rz - z);

			if (x_diff > y_diff && x_diff > z_diff)
				rx = -ry-rz
			else if (y_diff > z_diff)
				ry = -rx-rz
			else
				rz = -rx - ry
				
			// cube to odd-r
			q = rx + (rz - (rz % 2)) / 2;
			r = rz
	
			return getGHexTile(q, r);
			
		}
		
		public function get mapHeight():int 
		{
			return _mapHeight;
		}
		
		public function get mapWidth():int 
		{
			return _mapWidth;
		}
		
		public function getTileByIndex(i:int):GHexTile
		{
			return _tiles[i];
		}
		
		public function getBounds(p_target:Rectangle = null):Rectangle 
		{
			
			trace(p_target);
			
			var w:int = mapWidth * tileWidth
			var h:int = mapHeight * rowHeight;
			
			if (p_target)
			{
				p_target.x = -w * 0.5;
				p_target.x = -h * 0.5;
				p_target.width = w;
				p_target.height = h;
				
				return p_target;
			}
			
			
			return new Rectangle(-w * 0.5 , -h * 0.5, w, h);
		}
		
		public function get tilesNum():int
		{
			return _tiles.length;
		}
		
		public function get tiles():Vector.<GHexTile> 
		{
			return _tiles;
		}
		
		public function get layers():IGHexMapDict 
		{
			return dict;
		}
		
		public function getNeighbors(t:GHexTile):Vector.<GHexTile>
		{

			var v:Vector.<GHexTile> 
			
			if (t.row % 2)
			{			
				v = new <GHexTile>[
					
					getTileAtCords(t.collumn + 1, t.row + 1),
					getTileAtCords(t.collumn + 0, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 0),
					getTileAtCords(t.collumn + 0, t.row - 1),
					getTileAtCords(t.collumn + 1, t.row - 1),
					getTileAtCords(t.collumn + 1, t.row + 0)
				];
			}
			else
			{
				v = new <GHexTile>[
					getTileAtCords(t.collumn + 0, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 0),
					getTileAtCords(t.collumn - 1, t.row - 1),
					getTileAtCords(t.collumn + 0, t.row - 1),
					getTileAtCords(t.collumn + 1, t.row + 0)
				];
			}
			
			return v;
			
		}
		
		public function getNeighbors2(t:GHexTile):Vector.<GHexTile>
		{

			var v:Vector.<GHexTile> 
			
			
			if (t.row % 2)
			{			
				v = new <GHexTile>[
					
					getTileAtCords(t.collumn + 1, t.row + 0),
					getTileAtCords(t.collumn + 1, t.row + 1),
					getTileAtCords(t.collumn + 0, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 0),
					getTileAtCords(t.collumn + 0, t.row - 1),
					getTileAtCords(t.collumn + 1, t.row - 1)
				];
			}
			else
			{
				v = new <GHexTile>[
					getTileAtCords(t.collumn + 1, t.row + 0),
					getTileAtCords(t.collumn + 0, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 1),
					getTileAtCords(t.collumn - 1, t.row + 0),
					getTileAtCords(t.collumn - 1, t.row - 1),
					getTileAtCords(t.collumn + 0, t.row - 1)
				];
			}
			
			return v;
			
		}
		
		public function getTileAtCords(c:int, r:int):GHexTile
		{
			
			if (r < 0 || r >= _tilesCords.length) return null;
			if (c < 0 || c >= _tilesCords[r].length) return null;
			
			return _tilesCords[r][c];
			
		}
		
	}

}