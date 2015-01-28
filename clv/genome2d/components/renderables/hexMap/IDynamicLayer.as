package clv.genome2d.components.renderables.hexMap 
{
	import clv.gameDev.hexMap.mapData.DynamicLayer;
	import clv.genome2d.components.renderables.hexMap.HexMap;
	import clv.genome2d.components.renderables.hexMap.HexTile;
	import com.genome2d.components.GTransform;
	import com.genome2d.context.IContext;
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public interface IDynamicLayer 
	{
		
		function get render():Boolean;
		function set render(v:Boolean):void
		
		function get hex():Boolean;
		function set hex(v:Boolean):void
		
		function set dynamicLayer(v:DynamicLayer):void
		function get dynamicLayer():DynamicLayer
		
		function renderTile(tile:HexTile, sin:Number, cos:Number, dx:Number, dy:Number, transform:GTransform, map:HexMap, c:IContext):void 
	}
	
}