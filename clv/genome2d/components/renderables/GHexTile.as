package clv.genome2d.components.renderables 
{
	import com.genome2d.textures.GTexture;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class GHexTile 
	{
		
		//public var texture:GTexture;
		
		public var type:int;
		
		public var collumn:int;
		
		public var row:int;
		
		public var next:GHexTile;
		
		public var name:String;
		
		public var x:Number;
		public var y:Number;
		
		public var index:int;
		
		public var map:GHexMap;
		
		public var filled:Boolean;
		
		public var selected:Boolean;
		
		public var edges:Array = [];
		public var edgesTypes:Object = {};
		public var edgesTypesList:Array = [];
		
		public var textures:Vector.<GTexture> = new Vector.<GTexture>();
		
		public var layers:Vector.<GHexTileLayer> = new Vector.<GHexTileLayer>();
		
		public var bgLayer:int;
		
		private var _content:Array = [];
		
		public function GHexTile(map:GHexMap, collumn:int, row:int, index:int) 
		{
			this.row = row;
			this.collumn = collumn;
			
			this.map = map;
			this.index = index;
			
			x = collumn * map.tileWidth + map.tileWidth * (row % 2 == 0 ? 0.5 : 1) + map.xOffset;
			y = row * map.rowHeight + map.yOffset;
		}
		
	}

}