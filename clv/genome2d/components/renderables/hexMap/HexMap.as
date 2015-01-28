package clv.genome2d.components.renderables.hexMap 
{
	import clv.gameDev.hexMap.mapData.LayerData;
	import clv.gameDev.hexMap.mapData.MapData;
	import clv.gameDev.hexMap.mapData.TileData;
	import clv.gameDev.hexMap.mapData.TileTextureData;
	import clv.gameDev.hexMap.mapData.TileUtils;
	import clv.gameDev.hexMap.mapData.TypeData;
	import clv.gameDev.hexMap.tileEditor.data.BinaryEdges;
	import clv.games.theFew.assets.textures.strategy.map.mapTiles.MapTiles;
	import org.osflash.signals.Signal;
	
	import com.genome2d.components.GComponent;
	import com.genome2d.components.GTransform;
	import com.genome2d.components.renderables.IRenderable;
	import com.genome2d.context.GBlendMode;
	import com.genome2d.context.GContextCamera;
	import com.genome2d.context.IContext;
	import com.genome2d.textures.GTexture;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import zvr.zvrKeyboard.ZvrKeyboard;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexMap extends GComponent implements IRenderable
	{
		
		private var _mapData:MapData;
		
		public var mapWidth:int;
		public var mapHeight:int;
		
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		private var _mapWidthPx	:Number;
		private var _mapHeightPx:Number;
		
		
		public var rowHeight:Number;
		
		private var _viewWidth:int;
		private var _viewHeight:int;
		private var _viewX:Number = 0;
		private var _viewY:Number = 0;
		
		private var _scale:Number = 1;
		
		private var _tiles:Vector.<HexTile> = new Vector.<HexTile>();
		
		private var _c:HMRL = new HMRL;
		private var _t:HMRL = new HMRL;
		
		public var dynamicLayers:Vector.<IDynamicLayer>;
		
		private var renderOrder:Array;
		
		private var _invalidate:Boolean;
		
		public const onRendered:Signal = new Signal();
		
		public function HexMap() 
		{
			
		}
		
		public function validate():void
		{
			_invalidate = true;
		}
		
		public function redraw():void 
		{
			
			_tiles.length = 0;
			
			if (!_mapData) return;
			
			mapWidth = _mapData.width;
			mapHeight = _mapData.height;
			
			tileHeight = _mapData.tileHeight;
			tileWidth = _mapData.tileWidth;
			
			rowHeight = tileHeight * 0.75;
			
			_mapWidthPx = mapWidth * tileWidth;
			_mapHeightPx = mapHeight * rowHeight;
			
			renderOrder = mapData.renderOrder;
			dynamicLayers = new Vector.<IDynamicLayer>();
			dynamicLayers.length = mapData.dynmicLayers.length;
			
			var last:HexTile;
			
			var c:int;
			
			_tiles.length = 0;
			
			for (var j:int = 0; j < mapHeight; j++) 
			{
				for (var i:int = 0; i < mapWidth; i++) 
				{
					
					var t:HexTile;
					
					t = new HexTile();
					
					t.q = i;
					t.r = j;
					t.i = c;
					
					t.x = i * tileWidth + tileWidth * (j % 2 == 0 ? 0.5 : 1);
					t.y = j * rowHeight;
					
					
					c++;
					
					_tiles.push(t);
					
					for (var k:int = 0; k < _mapData.layers.length; k++) 
					{
						
						var m:LayerData = _mapData.layers[k];
						var tileData:TileData = m.tiles[i][j];
						var l:HexTileLayer = new HexTileLayer();
						
						l.alpha = isNaN(tileData.alpha) ? 0 : tileData.alpha;
						l.type = tileData.type;
						l.fill = tileData.fill;
						l.edge = tileData.edge;
						l.visible = m.visible;
						
						l.index = k;
						
						t.layers.push(l);
						
						var tileTexture:TileTextureData = getTileTexture(i, j, m);
						
						if (tileTexture)
						{
							l.texture = GTexture.getTextureById(tileTexture.atlas + "_" + tileTexture.texture);
							l.transparent = tileTexture.transparent;
						}
					}
					
					t.data = { };
					t.data.build = TileUtils.canBiuld(t, mapData);
				}
			}
			
			updateTilesLayersRender();
			
		}
		
		public function updateTilesLayersRender():void
		{
			var ro:Array = []
				
			for (var i:int = 0; i < _mapData.renderOrder.length; i++) 
			{
				var n:Array = _mapData.renderOrder[i];
				
				for (var j:int = 0; j < n.length; j++) 
				{
					var li:int = n[j];
					if (li >= 0) ro.push(li);
				}
			}
			
			
			for (i = 0; i < _tiles.length; i++) 
			{
				var t:HexTile = _tiles[i];
				
				var bg:Boolean = false;
				
				for (var k:int = ro.length-1; k >= 0; k--) 
				{
					
					var l:HexTileLayer = t.layers[ro[k]];
					
					l.render = !bg;
					
					if (l.texture && l.alpha == 1 && !l.transparent) 
					{
						bg = true;
					}
					
				}
				
			}
			
		}
		
		public function updateTileLayersRender(t:HexTile):void
		{
			
			var ro:Array = []
				
			for (var i:int = 0; i < _mapData.renderOrder.length; i++) 
			{
				var n:Array = _mapData.renderOrder[i];
				
				for (var j:int = 0; j < n.length; j++) 
				{
					var li:int = n[j];
					if (li >= 0) ro.push(li);
				}
			}
			
			var bg:Boolean = false;
			
			for (var k:int = ro.length-1; k >= 0; k--) 
			{
				
				var l:HexTileLayer = t.layers[ro[k]];
				
				l.render = !bg;
				
				if (l.texture && l.alpha == 1 && !l.transparent) 
				{
					bg = true;
				}
				
			}
			
		}
		
		public function updateMapData():void
		{
			_invalidate = true;
			
			for (var i:int = 0; i < _tiles.length; i++) 
			{
				var t:HexTile = _tiles[i];
				
				for (var j:int = 0; j < t.layers.length; j++) 
				{
					var l:HexTileLayer = t.layers[j];
					var m:LayerData = _mapData.layers[l.index];
					var tileData:TileData = m.tiles[t.q][t.r];
					
					l.alpha = isNaN(tileData.alpha) ? 0 : tileData.alpha;
					l.type = tileData.type;
					l.fill = tileData.fill;
					l.edge = tileData.edge;
					l.visible = m.visible;
					
					var tileTexture:TileTextureData = getTileTexture(t.q, t.r, m);
						
					if (tileTexture)
					{
						l.texture = GTexture.getTextureById(tileTexture.atlas + "_" + tileTexture.texture);
						l.transparent = tileTexture.transparent;
					}
					else
					{
						l.texture = null;
						l.transparent = false;
					}
					
				}
				
			}
			updateTilesLayersRender();
		}
		
		public function updateTileLayer(t:HexTile, d:LayerData):void
		{
			_invalidate = true;
			
			var li:int = _mapData.layers.indexOf(d);
			
			if (li == -1) return;
			
			var m:LayerData = _mapData.layers[li];
			var l:HexTileLayer = t.layers[li];
			
			var tileData:TileData = d.tiles[t.q][t.r];
			
			l.alpha = isNaN(tileData.alpha) ? 0 : tileData.alpha;
			l.type = tileData.type;
			l.fill = tileData.fill;
			l.edge = tileData.edge;
			l.visible = m.visible;
			
			var tileTexture:TileTextureData = getTileTexture(t.q, t.r, d);
				
			if (tileTexture)
			{
				l.texture = GTexture.getTextureById(tileTexture.atlas + "_" + tileTexture.texture);
				l.transparent = tileTexture.transparent;
			}
			else
			{
				l.texture = null;
				l.transparent = true;
			}
			
			
			updateTileLayersRender(t);
		}
		
		public function getTileTexture(q:int, r:int, m:LayerData):TileTextureData 
		{
			
			if (!m.asset) return null;
			
			var t:TileData = m.tiles[q][r];
			
			var type:TypeData =  m.asset.types[t.type];
			
			var tt:TileTextureData;
			
			if (type.textures.length == 58)
			{
				var e:uint =  t.edge << 1;
				if (t.fill) e ++;
				e =  BinaryEdges.edgesToIndex[e];
				return type.textures[e];
			}
			else if (type.textures.length == 1 && t.fill) 
				return type.textures[0];
			
			return null;
			
			//return 
		}
		
		public function render(p_camera:GContextCamera, p_useMatrix:Boolean):void 
		{
			if (!_mapData) return;
			
			if (_invalidate)
			{
				invalidate();
				_invalidate = false;
			}
			
			var cos:Number = 1;
			var sin:Number = 0;
			
			if (node.transform.g2d_worldRotation != 0)
			{
				cos = Math.cos(node.transform.g2d_worldRotation);
				sin = Math.sin(node.transform.g2d_worldRotation);
			}
			
			var transform:GTransform = node.transform;
			
			var dx:Number = transform.g2d_worldX - _viewX - mapWidth * tileWidth / 2;
			var dy:Number = transform.g2d_worldY - _viewY - mapHeight * rowHeight / 2;
			
			var c:IContext = node.core.g2d_context;

			for ( var hmr:HMR = _c.head; hmr; hmr = hmr.next)
			{
				if (hmr.l)
				{
					renderTile(hmr.t, hmr.l, sin, cos, dx, dy, transform, c);
				}
				else
				{
					hmr.d.renderTile(hmr.t, sin, cos, dx, dy, transform, this, c);
				}
			}
			
			onRendered.dispatch();
		}
		
		private function invalidate():void 
		{
			//trace("invalidate");
			
			if (_c.head)
			{
				_c.head.previous = _t.tail;
				
				if (_t.tail)
				{
					_t.tail.next = _c.head;
					_t.tail = _c.tail;
				}
				else
				{
					_t.head = _c.head;
					_t.tail = _c.tail;
				}
				
				_c.head = null;
				_c.tail = null;
			}
			
			var vw:Number = _viewWidth / _scale;
			var vh:Number = _viewHeight / _scale;
			
			var vx:Number = _viewX;
			var vy:Number = _viewY;
			
			var mapHalfWidth:Number = tileWidth * mapWidth * .5;
			var mapHalfHeight:Number = rowHeight * mapHeight * .5;
			
			// Position of top left tile from map center
			var firstX:Number = -mapHalfWidth + tileWidth;
			var firstY:Number = -mapHalfHeight;
			
			// Index of top left visible tile
			var indexX:int = (vx - firstX) / tileWidth;
			if (indexX < 0) indexX = 0;
			
			var indexY:int = (vy - firstY) / rowHeight;
			if (indexY < 0) indexY = 0;		
			
			var endX:Number = vx + vw;
			var endY:Number = vy + vh;
		
			var indexWidth:int = (endX - firstX) / tileWidth - indexX + 2;
			
			if (indexWidth > mapWidth - indexX) indexWidth = mapWidth - indexX;
			
			var indexHeight:int = (endY - firstY) / rowHeight - indexY + 2;
			
			if (indexHeight > mapHeight - indexY) indexHeight = mapHeight - indexY;
			
			var tileCount:int = indexWidth * indexHeight;
			
			var dynamicOnceLayers:Array = [];
			
			for (var j:int = 0; j < renderOrder.length; j++) 
			{
				
				var rl:Array = renderOrder[j];
				
				for (var i:int = 0; i < tileCount; ++i)
				{
					var index:int = indexY * mapWidth + indexX + int(i / indexWidth) * mapWidth + i % indexWidth;
					
					var t:HexTile = _tiles[index];
					
					for (var k:int = 0; k < rl.length; k++) 
					{
						
						var li:int = rl[k];
						
						if (li < 0) 
						{
							var dl:IDynamicLayer = dynamicLayers[ -li - 1];
							
							if (dl && dl.render) 
							{
								
								if (dl.hex)
								{
									rd(t, dl);
									continue;
								}
								
								if (dynamicOnceLayers.indexOf(dl) == -1)
								{
									dynamicOnceLayers.push(dl);
									rd(t, dl);
								}
								
							}
							//dynamicLayers[ -li - 1].renderTile(t, sin, cos, dx, dy, transform, this, c);
							continue;
						}
						
						var l:HexTileLayer = t.layers[li];
						
						if (l.render && l.visible && l.texture && l.alpha != 0) 
						{
							r(t, l); //renderTile(t, l, sin, cos, dx, dy, transform, c);
						}
						
					}
					
				}
				
			}
			
		}
		
		
		/* INTERFACE com.genome2d.components.renderables.IRenderable */
		
		private function renderTile(tile:HexTile, l:HexTileLayer, sin:Number, cos:Number, dx:Number, dy:Number, transform:GTransform, c:IContext):void 
		{
			
			/*if (!l.texture) return;
			if (l.alpha == 0) return;*/
			
			
			var tx:Number = (tile.x * cos - tile.y * sin) * transform.g2d_worldScaleX + dx;//+ transform.g2d_worldX - viewX - mapWidth * tileWidth / 2;
			var ty:Number = (tile.y * cos + tile.x * sin) * transform.g2d_worldScaleY + dy;//+ transform.g2d_worldY - viewY - mapHeight * rowHeight / 2;
			
			

			c.draw(
				l.texture,
				tx * _scale,
				ty * _scale, 
				transform.g2d_worldScaleX * _scale,
				transform.g2d_worldScaleY * _scale,
				transform.g2d_worldRotation, 
				transform.g2d_worldRed, 
				transform.g2d_worldGreen, 
				transform.g2d_worldBlue,
				transform.g2d_worldAlpha * l.alpha
			);
			
		}
		
		public function getMapUnderPoint(px:Number, py:Number):HexTile
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
	
			return getTile(q, r);
			
		}
		
		public function getTile(q:int, r:int):HexTile
		{
			var i:int = r * mapWidth + q;
			
			if (i < 0) return null;
			if (i >= _tiles.length) return null;
			
			return _tiles[i];	
		
		}
		
		public function getBounds(p_target:Rectangle = null):Rectangle 
		{
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
		
		public function getNeighbors(t:HexTile):Vector.<HexTile>
		{

			var v:Vector.<HexTile> 
			
			
			if (t.r % 2)
			{			
				v = new <HexTile>[
					
					getTile(t.q + 1, t.r + 0),
					getTile(t.q + 1, t.r + 1),
					getTile(t.q + 0, t.r + 1),
					getTile(t.q - 1, t.r + 0),
					getTile(t.q + 0, t.r - 1),
					getTile(t.q + 1, t.r - 1)
				];
			}
			else
			{
				v = new <HexTile>[
					getTile(t.q + 1, t.r + 0),
					getTile(t.q + 0, t.r + 1),
					getTile(t.q - 1, t.r + 1),
					getTile(t.q - 1, t.r + 0),
					getTile(t.q - 1, t.r - 1),
					getTile(t.q + 0, t.r - 1)
				];
			}
			
			return v;
			
		}
		
		private function rd(t:HexTile, d:IDynamicLayer):void 
		{
			var h:HMR;
			
			if (_t.head)
				h = _t.remove(_t.head);
			else
				h = new HMR();
			
			h.t = t;
			h.d = d;
			h.l = null;
			_c.add(h);
		}
		
		public function r(t:HexTile, l:HexTileLayer):void
		{
			var h:HMR;
			
			if (_t.head)
				h = _t.remove(_t.head);
			else
				h = new HMR();
			
			h.t = t;
			h.l = l;
			h.d = null;
			
			_c.add(h);
		}
		
		public function d(h:HMR):void
		{
			h.l = null;
			h.t = null;
			h.d = null;
			
			_t.add(_c.remove(h));
		}
		
		public function get mapData():MapData 
		{
			return _mapData;
		}
		
		public function set mapData(value:MapData):void 
		{
			_mapData = value;
			
			viewX = 0;
			viewY = 0;
			scale = 1;
			
			
			var t:int = getTimer();
			
			redraw();
			
			trace("map redraw:", getTimer() - t);
			
		}
		
		public function get tiles():Vector.<HexTile> 
		{
			return _tiles;
		}
		
		public function get viewWidth():int 
		{
			return _viewWidth;
		}
		
		public function set viewWidth(value:int):void 
		{
			if (_viewWidth == value) return;
			
			_viewWidth = value;
			_invalidate = true;
		}
		
		public function get viewHeight():int 
		{
			return _viewHeight;
		}
		
		public function set viewHeight(value:int):void 
		{
			if (_viewHeight == value) return;
			
			_viewHeight = value;
			_invalidate = true;
		}
		
		public function get viewX():Number 
		{
			return _viewX;
		}
		
		public function set viewX(value:Number):void 
		{
			if (_viewX == value) return;
			
			_viewX = value;
			_invalidate = true;
		}
		
		public function get viewY():Number 
		{
			return _viewY;
		}
		
		public function set viewY(value:Number):void 
		{
			if (_viewY == value) return;
			
			_viewY = value;
			_invalidate = true;
		}
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			if (_scale == value) return;
			
			_scale = value;
			_invalidate = true;
		}
		
		public function get mapWidthPx():Number 
		{
			return _mapWidthPx;
		}
		
		public function get mapHeightPx():Number 
		{
			return _mapHeightPx;
		}
		
		public function setInvalidate():void 
		{
			_invalidate = true;
		}
	}

}