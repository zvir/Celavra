package clv.gameDev.hexMap.tileEditor.outputs 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeData;
	import clv.gameDev.hexMap.tileEditor.outputs.HexEdge;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HexeEdges 
	{
		
		/*
		types and rotations
		1 	- 10 	: 6
		10 	- 12 	: 3
		12	-	16 	: 1
		
		*/
		
		public var w:Number;
		public var h:Number;
		
		public var hexMask:BitmapData;
		
		public const edges:Vector.<HexEdge> = new Vector.<HexEdge>();
		
		public function HexeEdges() 
		{
			
		}
		
	}

}