package clv.gameDev.hexMap.mapData 
{
	import clv.genome2d.components.renderables.hexMap.HexMap;
	import clv.genome2d.components.renderables.hexMap.HexMapUtils;
	import clv.genome2d.components.renderables.hexMap.HexTile;
	import clv.genome2d.components.renderables.hexMap.HexTileLayer;
	/**
	 * ...
	 * @author ...
	 */
	public class TileUtils 
	{
		
		public function TileUtils() 
		{
			
		
		}
		
		public static function buildOn(t:HexTile, map:HexMap):void
		{
			for (var i:int = t.layers.length-1; i >= 0; i--) 
			{
				var l:HexTileLayer = t.layers[i];
				
				var ld:LayerData = map.mapData.layers[l.index];
				
				if (ld.buildingOption == BouldingRelation.CLEAR) 
				{
					l.visible = false;
					map.setInvalidate();
				}
				
			}
			
			t.data.build = false;
		}
		
		public static function canBiuld(t:HexTile, mapData:MapData):Boolean
		{
			var v:Boolean = true;
			
			
			for (var i:int = t.layers.length-1; i >= 0; i--) 
			{
				var l:HexTileLayer = t.layers[i];
				
				var ld:LayerData = mapData.layers[l.index];
				
				if (!l.fill && ld.buildingOption == BouldingRelation.OLNY_ON) 
					return false;
					
				if (l.fill && ld.buildingOption == BouldingRelation.OFF) 
					return false;
				
				if (l.fill && ld.buildingOption == BouldingRelation.NOT_ON) 
					return false;
				
				if (l.fill && ld.buildingOption == BouldingRelation.ONLNY_ON_NO_EDGE && l.edge != 63)
					return false;
				
				if (!l.fill && ld.buildingOption == BouldingRelation.ONLNY_ON_NO_EDGE && l.edge != 0)
					return false;
				
			}
			
			return v;
			
		}
		
		public static function preapereForBuilding(t:HexTile, hexMap:HexMap):void
		{
			
			for (var i:int = t.layers.length-1; i >= 0; i--) 
			{
				var l:HexTileLayer = t.layers[i];
				
				var ld:LayerData = hexMap.mapData.layers[l.index];
				
				if (ld.buildingOption == BouldingRelation.CLEAR) 
					HexMapUtils.erase(hexMap, t.q, t.r, ld, 0);
					
				
			}
			
		}
	}

}