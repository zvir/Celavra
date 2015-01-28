package clv.genome2d.components.renderables 
{
	import com.genome2d.textures.GTexture;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class GHexTileLayer 
	{
		
		public var texture:GTexture;
		
		public var index:int;
		
		public var fill:Boolean;
		
		public var alpha:Number;
		
		public var type:int;
		
		public var edgeType:int;
		
		public var edgeType2:int;
		
		public var edges:Array = [];
		
		
		public function GHexTileLayer() 
		{
			
		}
		
	}

}