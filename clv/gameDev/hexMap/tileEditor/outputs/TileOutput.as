package clv.gameDev.hexMap.tileEditor.outputs 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.EdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.HexEdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import clv.gameDev.hexMap.tileEditor.data.TileTypes;
	import clv.gameDev.hexMap.tileEditor.processors.HexEdgeBitmapGenerator;
	import clv.gameDev.hexMap.tileEditor.processors.HexTextureGenerator;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileOutput 
	{
		private const R:Number = 1.1547;
		
		private var _data:TileData;
		
		public var bitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		public var edges:Vector.<HexeEdges> = new Vector.<HexeEdges>();
		
		public var updated:Signal = new Signal(TileOutput);
		
		private var updItv:int;
		
		private var updating:Boolean;
		
		public var layers:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>();
		
		public static var queene:int;
		
		public function TileOutput() 
		{
			
		}
		
		public function update():void
		{
			if (!ready()) return;
			generate(this);
			updated.dispatch(this);
			updating = false;
			queene--;
			
		}
		
		public function ready():Boolean 
		{
			for (var i:int = 0; i < data.layers.length; i++) 
			{
				if (!data.layers[i].image.bitmapData) return false;
				
				
				
				for (var j:int = 0; j < data.layers[i].edge.layers.length; j++) 
				{
					var el:EdgeLayer = data.layers[i].edge.layers[j];
					if (!(el is EdgeMask) && !(el is HexEdgeMask) && !el.bitmap.bitmapData) return false;
				}
				
				if (data.layers[i].edge.displacementMapEnabled && data.layers[i].edge.displacementMap && !data.layers[i].edge.displacementMap.bitmapData) return false;
			
				
				
			}
			
			return true;
			
		}
		
		public function generate(v:TileOutput):void
		{

			//if (!v.ready()) return;

			var output:Vector.<BitmapData> = new Vector.<BitmapData>();
			output.length = 70;
			
			layers.length = 0;
			
			
			
			var rectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
			rectangles.length = 70;
			
			for (var i:int = 0; i < v.data.layers.length; i++)
			{
				
				HexEdgeBitmapGenerator.drawMasks(v.data.layers[i].edge, v.edges[i]);
				
				var ls:Vector.<BitmapData> = generateLayer(v.data.layers[i], v.edges[i]);
				layers.push(ls);
				
				for (var k:int = 0; k < ls.length; k++) 
				{
					if (rectangles[k] == null) rectangles[k] = new Rectangle();
					if (rectangles[k].width < ls[k].width) rectangles[k].width = ls[k].width;
					if (rectangles[k].height < ls[k].height) rectangles[k].height = ls[k].height;
				}
			}
			
			for (var j:int = 0; j < layers.length; j++) 
			{
				
				for (var m:int = 0; m < layers[j].length; m++) 
				{
					
					var r:Rectangle = rectangles[m];
					var l:BitmapData = layers[j][m];
					if (output[m] == null)
					{
						var b:BitmapData = new BitmapData(r.width, r.height, true, 0x00000000);
						output[m] = b;
					}
					
					b = output[m];
					
					b.draw(l, null, null, v.data.layers[j].blend, null, true);
				
				}
			}
			
			v.bitmaps = output;
			
		}
		
		public function updateDelay():void 
		{
			clearTimeout(updItv);
			updItv = setTimeout(update, 300  + 20 * queene);
			
			if (!updating)
				queene++;
			updating = true;
			
		}
		
		
		private function generateLayer(l:LayerData, e:HexeEdges):Vector.<BitmapData>
		{
			
			var v:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			if (!l.image.bitmapData)
				return v;
			
			if (!e.edges[0].mask)
				return v;
			
			var r:Rectangle = getTextureSize(l);
			
			var pw:Number = Project.data.tileWidth;
			var ph:Number = Project.data.tileWidth * R * Project.data.tileScale;
			
			var w:Number = pw// : l.image.bitmapData.width;
			var h:Number = ph// : l.image.bitmapData.height;
			
		
			
			for (var i:int = 0; i < e.edges.length; i++)
			{
				var b:BitmapData = new BitmapData(w, h, true, 0x00000000);
				
				var ix:Number = -l.image.bitmapData.width * 0.5 + w * 0.5;
				var iy:Number = -l.image.bitmapData.height * 0.5 + h * 0.5;
				
				b.copyPixels(l.image.bitmapData, l.image.bitmapData.rect, new Point(ix, iy));
				
				var mx:Number = -e.edges[i].mask.width * 0.5 + w * 0.5;
				var my:Number = -e.edges[i].mask.height * 0.5 + h * 0.5;
				
				var r:Rectangle = new Rectangle(pw, ph, pw, ph);
	
				b.copyChannel(e.edges[i].mask, e.edges[i].mask.rect, new Point(mx, my), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
				
				//b.copyPixels(e.edges[i].mask, e.edges[i].mask.rect, new Point(mx, my));
				
				 var matrix:Array = new Array();
					matrix = matrix.concat([1, 0, 0, 0, 0]); // red
					matrix = matrix.concat([0, 1, 0, 0, 0]); // green
					matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
					matrix = matrix.concat([0, 0, 0, l.imageAlpha/100, 0]); // alpha
				var c:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				
				b.applyFilter(b, b.rect, new Point(), c);
				
				v.push(b);
			}
			
			return v;
		
		}
		
		private function getTextureSize(l:LayerData):Rectangle
		{
			return new Rectangle(0, 0, Project.data.tileWidth, Project.data.tileWidth * R * Project.data.tileScale);
		}
		
		public function get data():TileData 
		{
			return _data;
		}
		
		public function set data(value:TileData):void 
		{
			_data = value;
			
			_data.change.add(onDataChange);
		}
		
		private function onDataChange(v:TileData):void 
		{
			updateDelay();
		}
		
		
		public function getTileBitmap(type:int, rotation:int):BitmapData
		{
			return bitmaps[TileTypes.getID(type, rotation)];
		}
		
	}

}