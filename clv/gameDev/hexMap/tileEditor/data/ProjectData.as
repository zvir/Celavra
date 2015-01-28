package clv.gameDev.hexMap.tileEditor.data 
{
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ProjectData 
	{
		
		public var projectFile:String;
		
		public var tiles:Vector.<TileData> = new Vector.<TileData>();
		
		public var name:String = "HexProject";
		
		public var tileWidth:Number = 80;
		
		public var tileScale:Number = 1;
		
		public var tile:int;
		
		public var layer:int;
		
		public var endgeLayer:int;
		
		public var loadPath:String;
		public var exportPath:String;
		public var exportTempatesPath:String;
		
		
		public var previewTile:int = 67;
		
		
		
		
		public function ProjectData() 
		{
			
		}
		
		public static function getNewProject():ProjectData
		{
			var p:ProjectData = new ProjectData();
			
			addNewTile(p);
			
			return p;
		}
		
		
		public static function addNewTile(p:ProjectData):TileData
		{
			var t:TileData = new TileData();
			
			t.name = "Hex_"+p.tiles.length;
			
			addNewLayer(t);
			
			p.tiles.push(t);
			
			return t;
		}
		
		public static function addNewLayer(t:TileData):LayerData
		{
			var l:LayerData = new LayerData();
			
			l.tileData = t;
			
			l.edge = new EdgeData();
			l.edge.tileData = t;
			t.layers.push(l);
			
			l.image.updater = l;
			l.edge.displacementMap.updater = l.edge;
			
			var el:EdgeLayer
			
			el = new EdgeMask();
			el.tileData = t;
			l.edge.layers.push(el);
			
			el = new HexEdgeMask();
			el.tileData = t;
			l.edge.layers.push(el);
			
			
			
			return l;
		}
		
		public static function addNewMaskLayer(e:EdgeData):EdgeLayer
		{
			var l:EdgeLayer = new EdgeLayer();
			l.bitmap.updater = l;
			e.layers.push(l);
			return l;
		}
		
		static public function moveMoveLayer(t:TileData, l:LayerData, c:int):void 
		{
			var id:int = t.layers.indexOf(l);
			
			if (id == -1) return;
			
			if (id + c < 0) return;
			
			if (id + c >= t.layers.length) return;
			
			t.layers.splice(id, 1);
			t.layers.splice(id + c, 0, l);
			
			
		}
		
	}

}