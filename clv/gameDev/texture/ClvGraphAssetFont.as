package clv.gameDev.texture 
{
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ClvGraphAssetFont 
	{
		
		public var name:String;
		public var face:String;
		
		public var size:Number;
		
		public var bold:Boolean;
		public var italic:Boolean;
		
		public var lineHeight:Number;
		public var base:Number;
		
		public var chars:Vector.<ClvGraphAssetChar> = new Vector.<ClvGraphAssetChar>();
		
		public var kernings:Object
		
		public function ClvGraphAssetFont() 
		{
			
		}
		
	}

}