package clv.gameDev.hexMap.tileEditor.outputs 
{
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import clv.gameDev.hexMap.tileEditor.data.TileTypes;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class Exporter 
	{
		
		public function Exporter() 
		{
			
		}
		
		public static function export():void
		{
			var file:File = Project.data.exportPath ? new File(Project.data.exportPath) : File.documentsDirectory;
			file.addEventListener(Event.SELECT, selectSaveHandler);
			file.browseForDirectory("Tiles Export");
		}
		
		static private function selectSaveHandler(e:Event):void 
		{
			var file:File = e.target as File;
			
			file.deleteDirectory(true);
			
			file.createDirectory();
			
			Project.data.exportPath = file.nativePath;
			
			for (var i:int = 0; i < Project.data.tiles.length; i++) 
			{
				var td:TileData = Project.data.tiles[i];
				var to:TileOutput = Project.getTileOutput(td);
				
				var d:File = new File(file.nativePath + "/" +td.name);
				
				d.createDirectory();
				
				for (var j:int = 0; j < to.bitmaps.length; j++) 
				{
					saveBitmap(to.bitmaps[j], new File(d.nativePath + "/" + td.name+"_" + TileTypes.getType(j)+"_"+TileTypes.getRotation(j)+".png"));
				}
				
			}
			
		}
		
		
		static private function saveBitmap(bitmap:BitmapData,file:File):void
		{
			var byteArray:ByteArray = PNGEncoder.encode(bitmap);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
		}
		
		static public function exportTemplates():void 
		{
			var file:File = Project.data.exportTempatesPath ? new File(Project.data.exportTempatesPath) : File.documentsDirectory;
			file.addEventListener(Event.SELECT, selectSaveTHandler);
			file.browseForDirectory("Tiles Export");
		}
		
		static private function selectSaveTHandler(e:Event):void 
		{
			var file:File = e.target as File;
			
			
			
			Project.data.exportTempatesPath = file.nativePath;
			
			
			var td:TileData = Project.layer.tileData;
			
			var to:TileOutput = Project.getTileOutput(td);
			
			var li:int = td.layers.indexOf(Project.layer);
			
			var he:HexeEdges = to.edges[li];
			
			var d:File = new File(file.nativePath + "/" +td.name);
			
			d.createDirectory();
			
			for (var j:int = 0; j < he.edges.length; j++) 
			{
				saveBitmap(he.edges[j].mask, new File(d.nativePath + "/" + td.name+"_" + li + "_mask" + (j < 10 ? "0" + j : j) + ".png"));
			}
				
			
			
		}
	}

}