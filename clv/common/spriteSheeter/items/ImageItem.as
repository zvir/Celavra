package clv.common.spriteSheeter.items 
{
	import com.genome2d.utils.GPackerRectangle;
	import data.ImageData;
	import data.ProjectData;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Zvir
	 */

	public class ImageItem extends Item
	{
		
		public var gpr:GPackerRectangle = new GPackerRectangle();
		
		public var file:File;
		public var path:String;
		
		public var copy:ImageItem;
		
		public var trimed:Rectangle = new Rectangle();
		public var result:Rectangle = new Rectangle();
		public var pivot:Point = new Point();
		
		public var drawn:Boolean;
		
		public var empty:Boolean;
		
		public var animation:Boolean;
		
		public var letter:Boolean;
		
		public var project:ProjectData;	

		public function ImageItem() 
		{
			
		}
		
		
		
	}

}