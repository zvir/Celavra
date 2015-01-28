package clv.gameDev.hexMap.mapData 
{
	import clv.render.g2d.assets.CGAUtils;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class MapDataG2DUtils 
	{
		
		public function MapDataG2DUtils() 
		{
			
		}
		
		public static function loadMapTextures(d:MapData, assetsDirecory:File):void
		{
			var names:Array = [];
			
			for (var i:int = 0; i < d.assets.length; i++) 
			{
				var asset:AssetData = d.assets[i];
				
				for (var j:int = 0; j < asset.types.length; j++) 
				{
					var t:TypeData = asset.types[j];
					
					for (var k:int = 0; k < t.textures.length; k++) 
					{
						var x:TileTextureData = t.textures[k];
						
						if (x && names.indexOf(x.atlas) == -1)
						{
							names.push(x.atlas);
						}
					}
					
				}
				
			}
			
			for (var l:int = 0; l < names.length; l++) 
			{
				var file:File = assetsDirecory.resolvePath("./" + names[l] + ".cga");
				CGAUtils.loadToGT(file);
			}
			
		}
		
	}

}