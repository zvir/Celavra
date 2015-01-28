package clv.gameDev.hexMap.mapData 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LayerData 
	{
		public var name:String;
		
		public var tiles:Array;
		
		public var asset:AssetData;
		
		public var autoType:Boolean;
		
		public var link:Boolean;
		
		public var linkLayers:Dictionary;
		
		public var visible:Boolean;
		
		public var buildingOption:int;
		
		public function LayerData() 
		{
			
		}
		
	}

}