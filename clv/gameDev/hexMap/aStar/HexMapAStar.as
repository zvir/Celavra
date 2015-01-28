package clv.gameDev.hexMap.aStar 
{
	import _Map.Map_Impl_;
	import clv.gameDev.hexMap.mapData.MapData;
	import clv.genome2d.components.renderables.GHexMap;
	import com.yyztom.pathfinding.astar.AStar;
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexMapAStar 
	{
		public var astar:HexAStar;
		public var astarMap:Vector.<Vector.<AStarNodeVO>>;
		
		public function HexMapAStar() 
		{
			
		}
		
		public function setMap(map:MapData):void
		{
			
			if (!map) return;
			
			astarMap = new Vector.<Vector.<AStarNodeVO>>();
			
			var _previousNode : AStarNodeVO;
			
			for (var i:int = 0; i < map.width; i++) 
			{
				var nv:Vector.<AStarNodeVO> = new Vector.<AStarNodeVO>();
				
				for (var j:int = 0; j < map.height; j++) 
				{
					var v:AStarNodeVO = new AStarNodeVO();
					
					v.h = 0;
					v.f = 0;
					v.g = 0;
					
					v.visited = false;
					v.parent = null;
					v.closed = false;
					v.isWall = false;
					
					v.position = new Point(i, j);
					
					_previousNode = v;
					
					nv.push(v);
				}
				
				astarMap.push(nv);
			}
			
			/*for (i = 0; i < map.mapWidth; i++) 
			{
				for (j = 0; j < map.mapHeight; j++) 
				{
					v = astarMap[i][j];
					v.neighbors = getNeighbors(astarMap, i, j);
				}
			}*/
			
			astar = new HexAStar(astarMap);
		}
		
		
		
		/*
		public function oddROffset2axial(q, r):Point
		{
			return new Point(q - (r - (r & 1)) / 2, r);
		}
		
		public function getNeighbors(map:Vector.<Vector.<AStarNodeVO>>, q:int, r:int):Vector.<AStarNodeVO>
		{
			const neighbors:Array = [
			   [ [+1,  0], [ 0, -1], [-1, -1],
				 [-1,  0], [-1, +1], [ 0, +1] ],
			   [ [+1,  0], [+1, -1], [ 0, -1],
				 [-1,  0], [ 0, +1], [+1, +1] ]
			];
			
			var ns:Array = neighbors[r & 1];
			
			var v:Vector.<AStarNodeVO> = new Vector.<AStarNodeVO>();
			
			for (var i:int = 0; i < 6; i++) 
			{
				
				var n:Array = ns[i];
				
				var nq:int = q + n[0];
				var nr:int = r + n[1];
				
				if (nq < 0) continue;
				if (nq >= map.length) continue;
				
				
				if (nr < 0) continue;
				if (nr >= map[nq].length) continue;
				
				v.push(map[nq][nr]);
				
			}
			
			return v;
		}*/
	}

}