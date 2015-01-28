package clv.genome2d.components.renderables.hexMap 
{
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexTile 
	{
		
		public var layers:Vector.<HexTileLayer> = new Vector.<HexTileLayer>();
		
		// position in px
		public var y:Number;
		public var x:Number;
		
		public var bgLayer:int;
		
		// coullumn
		public var q:int; 
		
		// row
		public var r:int;
		
		// index
		public var i:int;
		
		public var data:Object;
		
		public function HexTile() 
		{
			
		}
		
	}

}