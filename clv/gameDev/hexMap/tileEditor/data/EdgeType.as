package clv.gameDev.hexMap.tileEditor.data
{
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeType
	{
		
		private static const initialized:Boolean = init();
		
		public function EdgeType()
		{
		
		}
		
		private static function init():Boolean
		{
			
			var a:Array = [];
			
			var t:String = "";
			
			for (var i:int = 0; i < 64; i++)
			{
				
				var s:String = uint(i).toString(2);
				
				while (s.length < 6)
				{
					s = "0" + s;
				}
				
				if (isPrime(i))
				{
					a.push(i);
				}
				t = t + "         "+i+":" +s;
				trace(i, s, isPrime(i));
			}
			
			trace(t);
			
			return true;
		}
		
		private static function isPrime(num:int):Boolean
		{
			for (var i = (num - 1); i > 1; i--)
			{
				if ((num % i) == 0)
				{
					return false;
				}
			}
			return true;
		}
		
	}

}

