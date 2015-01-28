package clv.common.spriteSheeter.items 
{
	
	import data.AnimationData;
	import data.ImageData;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import processors.fileLoader.FileLoader;
	import processors.fileLoader.FileToLoad;
	import processors.ItemFactory;
	/**
	 * ...
	 * @author Zvir
	 */
	public class AnimationItem extends Item implements ISheetElement
	{
		public var images:Vector.<AnimationItemImage> = new Vector.<AnimationItemImage>();		
		
		public function AnimationItem() 
		{
			
		}
		
		override public function load(fileLoader:FileLoader):void 
		{
			super.load(fileLoader);
			
			images.length = 0;
			
			_loaded = false;
			
			for (var i:int = 0; i < animationData.images.length; i++) 
			{
				var item:AnimationItemImage = new AnimationItemImage();
				item.init(animationData.images[i]);
				item.animationData = animationData;
				item.animationItem = this;
				item.loadComplete.addOnce(itemLoaded);
				item.error.addOnce(itemError);
				item.load(fileLoader);
				images.push(item);
			}
			
		}
		
		private function itemLoaded(item:AnimationItemImage):void 
		{
			
			for (var i:int = 0; i < images.length; i++) 
			{
				if (!images[i].loaded) return;
			}
			
			_loaded = true;
			
			loadComplete.dispatch(this);
			
		}
		
		private function itemError(item:Item):void 
		{
			_loading = false;
			error.dispatch(this);
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
		
		public function getName():String
		{
			var f:File = images[0].file;
			
			var a:Array =  f.nativePath.split("\\");
			
			return a[a.length - 2];
			
		}
		
		public static function sortImages(a:ImageItem, b:ImageItem):int
		{
			if (a.name < b.name) return -1;
			if (a.name == b.name) return 0;
			if (a.name > b.name) return 1;
			return 0;
		}
		
		public function get animationData():AnimationData 
		{
			return _itemData as AnimationData;
		}
	}

}