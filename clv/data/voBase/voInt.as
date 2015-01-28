package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voInt extends voBase 
	{
		private var _value:int;
		
		public function voInt() 
		{
			
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(value:int):void 
		{
			_value = value;
			DC.reportChange(this);
		}
		
	}

}