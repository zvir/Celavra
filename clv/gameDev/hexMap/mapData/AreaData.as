package clv.gameDev.hexMap.mapData 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class AreaData 
	{
		
		public static const CITY:String = "city";
		public static const COUNTRY:String = "country";
		
		public var name:String;
		
		public var type:String;
		
		public var tiles:Vector.<AreaTileItem> = new Vector.<AreaTileItem>();
		
		public function AreaData() 
		{
			
		}
		
	}

}