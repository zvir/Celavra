package clv.gameDev.hexMap 
{
	import clv.genome2d.components.renderables.HexMapLayer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import tests.MapDict;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class MapEditor 
	{
		private var _mapDict:MapDict;
		
		
		public var selectedLayer:int = 6;
		
		public function MapEditor(mapDict:MapDict) 
		{
			_mapDict = mapDict;
		}
		
		public function draw(q:int, r:int, a:Number, t:int, e:int, f:Boolean, e2:int):void
		{
			_mapDict.mocups[selectedLayer].set(q, r, a, t, e, f, e2); 
		}
		
		public function erase(q:int, r:int):void
		{
			_mapDict.mocups[selectedLayer].set(q, r, 0, 0, 67, false, 0); 
		}
		
		public function toBMP():void 
		{
			var f:File = File.applicationDirectory;
			
			
			f.browseForSave("Export BMP");
		
			f.addEventListener(Event.SELECT, saveSelected);
			
		}
		
		private function saveSelected(e:Event):void 
		{
			HexMapLayer.saveBMP(HexMapLayer.toBMP(_mapDict.mocups[selectedLayer]), File(e.target).nativePath);
		}
		
		public function fromBMPClick():void 
		{
			var f:File = File.applicationDirectory;
			f.browseForOpen("import BMP");
			f.addEventListener(Event.SELECT, fromBMPSelected);
		}
		
		private function fromBMPSelected(e:Event):void 
		{
			var d:File = e.target as File;
			HexMapLayer.fromBMP(HexMapLayer.loadBMP(d.nativePath), _mapDict.mocups[selectedLayer]);
		}
		
		public function toAllBMP():void 
		{
			var f:File = File.applicationDirectory;
			f.browseForDirectory("Export BMP");
			f.addEventListener(Event.SELECT, saveAllSelected);
		}
		
		private function saveAllSelected(e:Event):void 
		{
			var d:File = e.target as File;
			
			if (!d.isDirectory) d = d.parent;
			
			for (var i:int = 0; i < _mapDict.mocups.length; i++) 
			{
				HexMapLayer.saveBMP(HexMapLayer.toBMP(_mapDict.mocups[i]), d.resolvePath(i+"_"+_mapDict.mocups[i].name + ".png").nativePath);
			}
		}
		
	}

}