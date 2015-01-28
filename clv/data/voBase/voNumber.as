package clv.data.voBase 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class voNumber extends voBase 
	{
		private var _value:Number = 0;
		
		public function voNumber() 
		{
			
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			
			DC.reportChange(this);
		}
		
	}

}