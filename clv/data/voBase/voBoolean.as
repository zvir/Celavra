package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voBoolean extends voBase 
	{
		
		private var _value:Boolean;
		
		public function voBoolean() 
		{
			
		}
		
		public function get value():Boolean 
		{
			return _value;
		}
		
		public function set value(value:Boolean):void 
		{
			_value = value;
			DC.reportChange(this);
		}
		
	}

}