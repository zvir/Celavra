package clv.genome2d.components.renderables 
{
	import clv.gameDev.hexMap.tileEditor.HexTileData;
	import com.genome2d.textures.GTexture;
	import flash.display.BitmapData;
	import clv.genome2d.components.renderables.HexMapLayer;
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public interface IGHexMapDict 
	{
		//function getTextureForLayer(layer:int, edgeType:int, rotation:int, q:int, r:int, type:int):GTexture;
		
		function isBg(layer:int, type:int):Boolean;
		
		function updateLayer(tile:GHexTile, l:int, data:HexTileData = null):void;
		
		function get layers():Array;
		
		function get mocups():Vector.<HexMapLayer>;

	}
	
}