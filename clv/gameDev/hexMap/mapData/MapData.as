package clv.gameDev.hexMap.mapData 
{
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class MapData 
	{
		public var name:String;
		
		public var width:int;
		public var height:int;
		
		public var renderOrder:Array;
		
		public var tileWidth:Number;
		
		public var tileHeight:Number;
		
		public var layers:Vector.<LayerData>;
		
		public var dynmicLayers:Vector.<DynamicLayer>;
		
		public var assets:Vector.<AssetData>;
		
		public var areas:Vector.<AreaData>;
		
		public function MapData() 
		{
			
		}
		
	}

}