package clv.gameDev.hexMap.tileEditor.data 
{
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TileTypes 
	{
		
		public static const ids:Vector.<Vector.<int>> = init();
		
		private static var types:Vector.<int>;
		
		private static var rotations:Vector.<int>;
		
		
		
		public static function getID(type:int, rotation:int):int
		{
			return ids[type][rotation];
		}
		
		public static function getType(id:int):int
		{
			return types[id];
		}
		
		public static function getRotation(id:int):int
		{
			return rotations[id];
		}
		
		public static function init():Vector.<Vector.<int>>
		{
			var v:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			v.length = 15;
			
			types = new Vector.<int>();
			rotations = new Vector.<int>();
			
			types.length = 70;
			rotations.length = 70;
			
			var i:int;
			var j:int;
			
			var c:int;
			
			for (i = 0; i < 10; i++) 
			{
				v[i] = new Vector.<int>();
				v[i].length = 6;
				
				for (j = 0; j < 6; j++) 
				{
					v[i][j] = c;
					
					types[c] = i;
					rotations[c] = j;
					
					c++;
				}
			}
			
			for (i = 10; i < 12; i++) 
			{
				v[i] = new Vector.<int>()
				v[i].length = 3;
				
				for (j = 0; j < 3; j++) 
				{	
					v[i][j] = c;
					
					types[c] = i;
					rotations[c] = j;
					
					c++;
				}
			}
			
			for (i = 12; i < 16; i++) 
			{	
				v[i] = new Vector.<int>();
				v[i].length = 1;
				
				
				v[i][0] = c;
				
				types[c] = i;
				rotations[c] = 0;
				
				c++;
				
			}
			
			return v;
			
		}
		
	}

}