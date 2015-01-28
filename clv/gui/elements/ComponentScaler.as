package clv.gui.elements 
{
	import clv.gui.core.IComponent;
	/**
	 * ...
	 * @author Zvir
	 */
	public class ComponentScaler 
	{
		
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number = 1
		private var _component:IComponent;
		
		public function ComponentScaler(component:IComponent) 
		{
			_component = component;
			_width = _component.width;
			_height = _component.height;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
			_component.height = _scale * _height;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
			_component.width = _scale * _width;
		}
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			_component.width = _scale * _width;
			_component.height = _scale * _height;
		}
		
	}

}