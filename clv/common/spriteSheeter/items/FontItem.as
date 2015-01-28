package clv.common.spriteSheeter.items 
{
	import data.FontData;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import processors.fileLoader.FileLoader;
	import processors.fileLoader.FileToLoad;
	import processors.FontProcessor;
	import processors.ItemFactory;
	/**
	 * ...
	 * @author Zvir
	 */
	[Event(name = "pregress", type = "items.ItemEvent")]
	[Event(name = "loaded", type = "items.ItemEvent")]
	
	public class FontItem extends Item implements ISheetElement
	{
		
		public var texture:BitmapData;
		public var textureFile:File;
		public var xmlFile:File;
		public var xml:XML;
		
		public var images:Vector.<FontItemImage> = new Vector.<FontItemImage>();
		
		public var data:FontData;
		
		private var _xmlToLoad:FileToLoad;
		private var _txtToLoad:FileToLoad;
		
		public function FontItem() 
		{
			
		}
		
		override public function load(fileLoader:FileLoader):void
		{
			super.load(fileLoader);
			
			
			var fontData:FontData = _itemData as FontData;
			
			_xmlToLoad = fileLoader.addFileToLoad(fontData.xml)
				.addError(loadError)
				.addLoadedOnce(xmlLoaded);
			
			_txtToLoad = fileLoader.addFileToLoad(fontData.texture)
				.addError(loadError)
				.addLoadedOnce(txtLoaded);
				
			textureFile = _txtToLoad.file;
			xmlFile = _xmlToLoad.file;
			
			name = textureFile.name;
			
			if (!_txtToLoad.canLoad || !_xmlToLoad.canLoad)
			{
				error.dispatch(this);
			}
			
		}
		
		private function loadError():void 
		{
			trace("font load error");
			_loading = false;
			error.dispatch(this);
		}
		
		/*private function complete(e:FontItemOpenerEvent):void 
		{
			_loaded = true;
			dispatchEvent(new ItemEvent(ItemEvent.LOADED, this));
		}*/
		
		private function xmlLoaded(stream:FileStream):void 
		{
			xml = ItemFactory.xmlFromStream(stream);
			_xmlToLoad.processed();
			_xmlToLoad = null;
			validateLoad();
		}
		
		private function txtLoaded(stream:FileStream):void 
		{
			ItemFactory.bitmapDataFromStrem(stream, bitmapFromStream, null);
			validateLoad();
		}
		
		private function bitmapFromStream(bitmapData:BitmapData, data:Object):void 
		{
			texture = bitmapData;
			validateLoad();
			_txtToLoad.processed();
			_txtToLoad = null;
		}
		
		private function validateLoad():void 
		{
			if (!xml || !texture) return;
			
			FontProcessor.process(this);
			
			if (images.length == 0)
			{
				trace("WFT");
			}
			
			_loaded = true;
			_loading = false;
			
			loadComplete.dispatch(this);
			
			trace("font loaded");
		}
		
		public function getSheetItems():Vector.<ImageItem>
		{
			var c:Vector.<ImageItem> = new Vector.<ImageItem>()
			
			for (var i:int = 0; i < images.length; i++) 
			{
				c.push(images[i]);
			}
			
			return c;
		}
		
		
	}

}