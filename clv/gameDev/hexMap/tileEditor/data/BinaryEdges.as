package clv.gameDev.hexMap.tileEditor.data 
{
	import flash.display.Sprite;
	import zvr.zvrTools.ZvrText;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class BinaryEdges extends Sprite
	{
		
		public static const pointsToPrint:Array = [];
		public static const edgesToIndex:Array = [];
		
		public function BinaryEdges() 
		{
			
		}
		
		public static function init():void
		{
			
			var e:Array = [];
			
			for (var i:int = 0; i < 64; i++)
			{
				
				var s2:String = convertEdgeToPointFill(ZvrText.beforeLength(6, uint(i).toString(2), "0"));
				var s3:String = convertEdgeToPointEmpty(ZvrText.beforeLength(6, uint(i).toString(2), "0"));
				
				var i2:int = parseInt(s2, 2);
				var i3:int = parseInt(s3, 2);
				
				i2 = i2 << 1;
				i3 = i3 << 1;
				
				i2++;
				
				e[i] = [i2, i3];
				
				if (pointsToPrint.indexOf(i2) == -1) 
				{
					pointsToPrint.push(i2);
				}
				if (pointsToPrint.indexOf(i3) == -1) 
				{
					pointsToPrint.push(i3);
				}
				
			}
			
			pointsToPrint.sort(Array.NUMERIC);
			
			for (i = 0; i < 64; i++) 
			{
				edgesToIndex[(i << 1) + 1] = pointsToPrint.indexOf(e[i][0]);
				edgesToIndex[(i << 1) + 0] = pointsToPrint.indexOf(e[i][1]);
			}
			
		}
		
		private static function convertEdgeToPointFill(s:String):String
		{
			
			var s2:String = "";
			
			for (var i:int = 0; i < s.length; i++) 
			{
				var j:int;
				j = i - 1;
				if (i == 0) j = s.length-1;
				var b1:Boolean = s.charAt(i) == "1" ? true : false;
				var b2:Boolean = s.charAt(j) == "1" ? true : false;
				s2 = s2 + (!b1 && !b2 ? "0" : "1") ;
			}
			
			return s2;
			
		}
		
		private static function convertEdgeToPointEmpty(s:String):String
		{
			
			var s2:String = "";
			
			for (var i:int = 0; i < s.length; i++) 
			{
				var j:int;
				
				j = i - 1;
				
				if (i == 0) j = s.length - 1;
				
				var b1:Boolean = s.charAt(i) == "1" ? true : false;
				var b2:Boolean = s.charAt(j) == "1" ? true : false;
				
				s2 = s2 + (b1 && b2 ? "1" : "0") ;
				
			}
			
			return s2;
			
		}
		
	}

}