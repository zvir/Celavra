package clv.gameDev.hexMap.tileEditor.storage 
{
	import clv.gameDev.hexMap.tileEditor.content.BitmapReference;
	import clv.gameDev.hexMap.tileEditor.data.EdgeData;
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.EdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.HexEdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import clv.gameDev.hexMap.tileEditor.data.ProjectData;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import flash.net.registerClassAlias;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LastPoroject 
	{
		
		private static var sharedObject:SharedObject;
		
		public static function init():ProjectData
		{
			
			registerClassAlias("ProjectData",		ProjectData);
			registerClassAlias("EdgeData", 			EdgeData);
			registerClassAlias("LayerData",			LayerData);
			registerClassAlias("TileData",			TileData);
			registerClassAlias("EdgeLayer",			EdgeLayer);
			registerClassAlias("BitmapReference",	BitmapReference);
			registerClassAlias("HexEdgeMask",		HexEdgeMask);
			registerClassAlias("EdgeMask",			EdgeMask);
			
			
			try
			{
				sharedObject = SharedObject.getLocal("ClvHexTileEditor");
			}
			catch (err:Error)
			{
				trace(err.message);
				//sharedObject.data.project = undefined;
				
				return ProjectData.getNewProject();
				
			}
			
			if (sharedObject.data.project == undefined || !(sharedObject.data.project is ProjectData))
			{
				sharedObject.data.project = ProjectData.getNewProject();
			}
			
			return sharedObject.data.project;
			
		}
		
		
		public static function set project(v:ProjectData):void
		{
			sharedObject.data.project = v;
		}
		
		public static function get project():ProjectData
		{
			return sharedObject.data.project;
		}
		
		
	}

}