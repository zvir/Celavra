package clv.genome2d.components.renderables 
{
	import clv.gameDev.hexMap.tileEditor.HexTileData;
	import com.adobe.images.PNGEncoder;
	import com.terrynoya.image.PNG.PNGDecoder;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexMapLayer 
	{
		
		public var data:Array;
		
		public var name:String;
		
		public var processEdges:Boolean;
		
		public function HexMapLayer() 
		{
			
		}
		
		public function getAlpha(x:int, y:int):Number
		{
			return HexTileData(data[x][y]).alpha;
		}
		
		public function getType(x:int, y:int):int
		{
			return HexTileData(data[x][y]).type;
		}
		
		public function getEdge(x:int, y:int):int
		{
			return HexTileData(data[x][y]).edge;
		}
		
		public function getEdge2(x:int, y:int):int
		{
			return HexTileData(data[x][y]).edge2;
		}
		
		public function getFill(x:int, y:int):Boolean
		{
			return HexTileData(data[x][y]).fill;
		}
		
		public function set(x:int, y:int, a:Number, t:int, e:int, f:Boolean, e2:int):void
		{
			if (data[x][y] == undefined) 
			{
				data[x][y] = new HexTileData();
			}
			
			HexTileData(data[x][y]).alpha = a;
			HexTileData(data[x][y]).type = t;
			HexTileData(data[x][y]).edge = e;
			HexTileData(data[x][y]).fill = f;
			HexTileData(data[x][y]).edge2 = e2;
			
		}
		
		public function get height():Number
		{
			return data.length;
		}
		
		public function get width():Number
		{
			return data[0].length;
		}
		
		public function getTile(x:int, y:int):HexTileData
		{
			return data[x][y];
		}
		
		public static function newLayer(width:int, height:int):HexMapLayer
		{
			var l:HexMapLayer = new HexMapLayer();
			
			l.data = [];
			
			for (var i:int = 0; i < width; i++) 
			{
				
				l.data[i] = [];
				
				for (var j:int = 0; j < height; j++) 
				{
					l.data[i][j] = new HexTileData();
				}
			}
			
			return l;
		}
		
		public static function fromBitmap(b:BitmapData):HexMapLayer
		{
			var l:HexMapLayer = new HexMapLayer();
			
			l.data = [];
			
			for (var i:int = 0; i < b.width; i++) 
			{
				
				l.data[i] = [];
				
				for (var j:int = 0; j < b.height; j++) 
				{
					
					var p:uint = b.getPixel32(i, j);
						
					var v:Number = ((p >> 16 & 0xFF) + (p >> 8 & 0xFF) + (p & 0xFF)) / 765;
					
					var t:HexTileData = new HexTileData();
					t.alpha = v;
					
					l.data[i][j] = t;
				}
			}
			
			return l;
			
		}
		
		public static function loadFile(path:String):HexMapLayer
		{

			var file:File = new File(path);
			
			if (!file.exists) return HexMapLayer.newLayer(100, 100);
			
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);
			
			bytes.uncompress();
			
			var l:HexMapLayer = bytes.readObject() as HexMapLayer;
			
			/////////////////////
			
			/*for (var i:int = 0; i < l.data.length; i++) 
			{
				for (var j:int = 0; j < l.data[i].length; j++) 
				{
					if (l.data[i][j] is HexTileData)
					{
						var t:HexTileData = l.data[i][j];
						t.q = i;
						t.r = j;
						t.type = 0;
					}
				}
			}*/
			
			////////////////////
			
			return l;
			
		}
		
		public static function saveFile(path:String, layer:HexMapLayer):void
		{

			var byteArray:ByteArray = new ByteArray()
			
			byteArray.writeObject(layer);
			byteArray.compress();
			
			var file:File = new File(path);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
			
		}
		
		public static function saveBMP(b:BitmapData, path:String):void
		{
			var file:File = new File(path);
			
			var byteArray:ByteArray = PNGEncoder.encode(b);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();

		}
		
		public static function loadBMP(path:String):BitmapData
		{
			var file:File = new File(path);
			
			if (!file.exists) return null;
			
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);

			return new PNGDecoder().decode(bytes);
			
		}
		
		
		
		public static function toBMP(layer:HexMapLayer):BitmapData
		{
			var b:BitmapData = new BitmapData(layer.width, layer.height, true, 0);
			
			b.lock();
			
			for (var i:int = 0; i < layer.width; i++) 
			{
				for (var j:int = 0; j < layer.height; j++) 
				{
					b.setPixel32(i, j, getRGB(layer.getAlpha(i, j), layer.getType(i, j), layer.getEdge(i, j), layer.getFill(i,j)));
				}
			}
			
			b.unlock();
			
			return b;
			
		}
		
		public static function fromBMP(b:BitmapData, layer:HexMapLayer):void
		{
			
			layer.data = [];
			
			for (var i:int = 0; i < b.width; i++) 
			{
				layer.data[i] = [];
				
				for (var j:int = 0; j < b.height; j++) 
				{
					var p:uint = b.getPixel(i, j);
					
					var f:Boolean = (p >> 24 & 0xFF) > 0;
					var a:Number = (p >> 16 & 0xFF) / 255;
					var t:Number = (p >> 8 & 0xFF);
					var e:Number = (p >> 0xFF);

					layer.set(i, j, a, t, e, a > 0, 0);
				}
			}
		}
		
		public static function getRGB(a:Number, t:int, e:int, f:Boolean):uint
		{
			a = a * 255;
			
			var rgb:uint;
			
			rgb += ((f? 255 : 0) << 24);
			rgb += (a << 16);
			rgb += (t << 8);
			rgb += (e);
			
			return rgb;
		}
		
		
	}
}