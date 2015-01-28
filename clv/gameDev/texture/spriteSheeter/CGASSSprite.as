package clv.gameDev.texture.spriteSheeter 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Zvir
	 */
	public class CGASSSprite 
	{
		public var bitmap	:BitmapData;
		public var name		:String;
		
		public var copy		:CGASSSprite;
		
		public var trimed	:Rectangle = new Rectangle();
		public var result	:Rectangle = new Rectangle();
		public var pivot	:Point = new Point();
		
		
		public function CGASSSprite(bitmap:BitmapData, name:String) 
		{
			this.bitmap = bitmap;
			this.name = name;
		}
		
	}

}