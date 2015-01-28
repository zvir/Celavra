package clv.gameDev.hexMap.aStar 
{
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	import com.yyztom.pathfinding.astar.BinaryHeap;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexAStar 
	{
		
		private var
			_openHeap : BinaryHeap,
			_touched : Vector.<AStarNodeVO>,
			_grid : Vector.<Vector.<AStarNodeVO>>,
			tcur : AStarNodeVO,
			currentNode : AStarNodeVO,
			ret : Vector.<AStarNodeVO>,
			neighbors : Vector.<AStarNodeVO>,
			neighbor : AStarNodeVO,
			newG : uint,
			i : uint, j : uint;
		
		public function HexAStar(grid : Vector.<Vector.<AStarNodeVO>> ){
			_touched = new Vector.<AStarNodeVO>(grid.length * grid.length+1, true);
			_grid = grid;
			_openHeap = new BinaryHeap( function(node:AStarNodeVO):Number { return node.f; } );
			
			for each (var row:Vector.<AStarNodeVO> in _grid)
				for each(var node:AStarNodeVO in row) {
					node.neighbors = new Vector.<AStarNodeVO>();
					for each(var neighbor:AStarNodeVO in getNeighbors(_grid, node)) {
						if (neighbor == null)
							break;
						//if (!neighbor.isWall)
							node.neighbors.push(neighbor);	// in demo i focus only on query optimization
					}
				}
		}
		
		/*public function setWall(isWall:Boolean, node:AStarNodeVO):void
		{
			if (isWall == node.isWall) return;
			
			node.isWall = isWall;
			
			var neighbors:Vector.<AStarNodeVO> = getNeighbors(_grid, node);
			
		}*/
		
		/**
		 * 
		 * DEBUG ONLY.
		 */
		public function get evaluatedTiles () : Vector.<AStarNodeVO> {
			return _touched;
		}
		
		
		public function search( start : AStarNodeVO, end:AStarNodeVO ) : Vector.<AStarNodeVO> {
			i = 0;
			tcur = _touched[0];
			
			for (var i:int = 0; i < _touched.length; i++) 
			{
				tcur = _touched[i];
				if (!tcur) continue;
				tcur.f=0;
				tcur.g=0;
				tcur.h=0;
				tcur.closed = false;
				tcur.visited = false;
				tcur.parent = null;
				tcur.next = null;
				_touched[i] = null;
				
				//tcur = _touched[i];
			}
			
			/*while(tcur) {
				
			}*/
			_openHeap.reset();
			i = 0;	// touched count -- lol, imperative programming (optimizer :()
			
			
			_openHeap.push(start);
			
			while( _openHeap.size > 0 ){
				currentNode = _openHeap.pop();
				
				if (currentNode == end) {
					i = 0;
					while (currentNode.parent) {
						currentNode.parent.next = currentNode;
						i++;
						currentNode = currentNode.parent;
					}
					ret = new Vector.<AStarNodeVO>(i+1, true);
					for (j = 0; currentNode; j++) {
						ret[j] = currentNode;
						currentNode = currentNode.next;
					}
					return ret;
				}
				
				currentNode.closed = true;
				
				if (i >= _touched.length) return null;
				
				_touched[i++] = currentNode;
				
				for each(neighbor in currentNode.neighbors)	{
					if (neighbor.closed)
						continue;
					if (neighbor.isWall)
						continue;
						
					newG = currentNode.g + currentNode.cost;
					
					if ( !neighbor.visited ) {
						if (i >= _touched.length) return null;
						_touched[i++] = neighbor;
						
						neighbor.visited = true;
						neighbor.parent = currentNode;
						neighbor.g = newG;
						neighbor.h = heuristic(start.position, neighbor.position, end.position);
						neighbor.f = newG + neighbor.h;
						_openHeap.push(neighbor);
						
					} else if ( newG < neighbor.g) {
						
						neighbor.parent = currentNode;
						neighbor.g = newG;
						neighbor.f = newG + neighbor.h;
						
						_openHeap.rescoreElement(neighbor);
					}
					
				}
			}
			
			return ret;
		}
		
		
		private function getNeighbors( grid : Vector.<Vector.<AStarNodeVO>> , node : AStarNodeVO) : Vector.<AStarNodeVO> {
			
			
			var 
				q : uint = node.position.x,
				r : uint = node.position.y;
				
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
				if (nq >= grid.length) continue;
				
				
				if (nr < 0) continue;
				if (nr >= grid[nq].length) continue;
				
				v.push(grid[nq][nr]);
				
			}
			
			return v;
			
		}

		private function heuristic( start : Point, neighbor : Point, end : Point ) : uint
		{
			var x0:Number = start.x - (start.y - (start.y & 1)) / 2;
			var z0:Number = start.y;
			var y0:Number = -x0 - z0;
			
			var x1:Number = neighbor.x - (neighbor.y - (neighbor.y & 1)) / 2;
			var z1:Number = neighbor.y;
			var y1:Number = -x1 - z1;
			
			var x2:Number = end.x - (end.y - (end.y & 1)) / 2;
			var z2:Number = end.y;
			var y2:Number = -x2 - z2;
			
			var h:Number = (Math.abs(x1 - x2) + Math.abs(y1 - y2) + Math.abs(z1 - z2)) / 2;
			
			// heuristic preffer diagonals
			/*var dx1:Number = Math.abs(x1 - x2);
			var dy1:Number = Math.abs(y1 - y2);
			var dz1:Number = Math.abs(z1 - z2);
			
			var dx2:Number = Math.abs(x0 - x1);
			var dy2:Number = Math.abs(y0 - y1);
			var dz2:Number = Math.abs(z0 - z1);
			
			var c:Number = 1 + Math.min(dx1 ,dy1, dz1, dx2, dy2, dz2);

			h *= c;*/
			
			return h;
			
			
		}
	}

}