package clv.gameDev.hexMap.mapData 
{
	import de.polygonal.motor2.dynamics.forces.Attractor;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class MapDataUtils 
	{
		static private var initilaized:Boolean;
		
		public function MapDataUtils() 
		{
			
		}
		
		public static function initialize():void
		{
			registerClassAlias("clv.gameDev.hexMap.mapData.AssetData"			, AssetData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.LayerData"			, LayerData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.MapData"				, MapData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.TileData"			, TileData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.TypeData"			, TypeData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.TileTextureData"		, TileTextureData		);
			
			registerClassAlias("clv.gameDev.hexMap.mapData.AreaData"			, AreaData				);
			registerClassAlias("clv.gameDev.hexMap.mapData.AreaTileItem"		, AreaTileItem			);
			
			registerClassAlias("clv.gameDev.hexMap.mapData.DynamicLayers"		, DynamicLayers			);
			registerClassAlias("clv.gameDev.hexMap.mapData.DynamicLayer"		, DynamicLayer			);
			registerClassAlias("flash.utils.Dictionary"							, Dictionary			);
			
			initilaized = true;
			
		}
		
		public static function saveToFile(mapData:MapData, file:File):void
		{
			
			
			if (!initilaized) initialize();
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(mapData);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
		}
		
		public static function loadFromFile(file:File):MapData
		{
			
			if (!initilaized) initialize();

			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var byteArray:ByteArray = new ByteArray();
			stream.readBytes(byteArray);
			stream.close();
			
			var o:Object = byteArray.readObject();
			byteArray.clear();
			
			var m:MapData = o as MapData;
			
			if (!m.areas) m.areas = new Vector.<AreaData>();
			
			return m;
		}
		
		
		public static function saveDLToFile(dl:DynamicLayers, file:File):void
		{
			if (!initilaized) initialize();
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(dl);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
		}
		
		public static function loadDLFromFile(file:File):DynamicLayers
		{
			if (!initilaized) initialize();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var byteArray:ByteArray = new ByteArray();
			stream.readBytes(byteArray);
			stream.close();
			var dl:DynamicLayers =  byteArray.readObject() as DynamicLayers;
			return dl;
		}
		
		
		
	}

}