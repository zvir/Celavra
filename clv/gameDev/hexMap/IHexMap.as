package clv.gameDev.hexMap 
{
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public interface IHexMap 
	{
		function get width():int;
		function get height():int;
		function get tiles():Vector.<IHexTile>;
		
	}
	
}