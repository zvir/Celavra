package clv.gui.g2d.components 
{
	import clv.gui.core.Pointer;
	import clv.gui.g2d.behaviors.DragScrolable;
	import clv.gui.g2d.display.G2DPointerComponent;
	import clv.gui.g2d.display.G2DPointerRectComponent;
	import clv.gui.g2d.display.IG2DPointerComponent;
	/**
	 * ...
	 * @author Zvir
	 */
	public class Scroller extends GroupG2D  implements IG2DPointerComponent
	{
		private var _pointerComponent:G2DPointerComponent;
		private var _pointerRectComponent:G2DPointerRectComponent;
		private var _pointer:Pointer;
		
		private var _dragScrollable:DragScrolable;
		
		public function Scroller() 
		{
			super();
			
			_pointer = new Pointer();
			_pointer.owner = this;
			_pointerComponent = G2DPointerComponent.addTo(this);
			_pointerRectComponent = G2DPointerRectComponent.addTo(this);
			
			_dragScrollable = new DragScrolable();
			
			behaviors.addBehavior(_dragScrollable);
			
			maskingEnabled = true;
			
		}
		
		public function get pointer():Pointer 
		{
			return _pointer;
		}
		
		public function get margin():Number 
		{
			return _dragScrollable.margin;
		}
		
		public function set margin(value:Number):void 
		{
			_dragScrollable.margin = value;
		}
	}

}