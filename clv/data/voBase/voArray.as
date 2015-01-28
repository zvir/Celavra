package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voArray extends voBase
	{
		
		public const data:Array = [];
		
		public function voArray() 
		{
			
		}
		
		public function add(v:*):void
		{	
			data.push(v);
			
			DC.reportAdd(v, this);
			
		}
		
		
		public function remove():void
		{
			
		}
		
		
		public function move():void
		{
			
		}
		
		
	}

}