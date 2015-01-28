package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voString extends voBase 
	{
		
		private var _value:String;
		
		public function voString() 
		{
			
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function set value(value:String):void 
		{
			_value = value;
			DC.reportChange(this);
		}
		
	}

}