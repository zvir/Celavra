package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voObject extends voBase 
	{
		
		private var _value:Object;
		
		public function voObject() 
		{
			
		}
		
		public function get value():Object 
		{
			return _value;
		}
		
		public function set value(value:Object):void 
		{
			_value = value;
			DC.reportChange(this);
		}
		
	}

}