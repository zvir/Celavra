package clv.gui.g2d.behaviors 
{
	import clv.gui.core.behaviors.Behavior;
	import clv.gui.core.behaviors.IPointerComponent;
	import clv.gui.core.ComponentSignal;
	import clv.gui.core.Container;
	import clv.gui.core.ICointainer;
	import clv.gui.core.Pointer;
	import zvr.zvrTools.ZvrMath;
	/**
	 * ...
	 * @author Zvir
	 */
	public class DragScrolable extends Behavior
	{
		
		public static const NAME:String = "DragScrolable";
		
		private var _pointer:Pointer;
		
		private var _lastY:Number;
		private var _lastX:Number;
		
		private var _container:Container;
		
		public var margin:Number = 50;
		
		public function DragScrolable() 
		{
			super(NAME);
		}
		
		override protected function enable():void 
		{
			
			super.enable();
			
			_container = component as Container;
			
			_pointer = IPointerComponent(component).pointer;
			
			_pointer.onDragBegin.addOnce(onDragBegin);
			
			component.onPostUpdate.add(update);
			
		}
		
		public function update(s:ComponentSignal):void 
		{
			tweenBackFromMagin();
		}
		
		private function tweenBackFromMagin():void 
		{
			if (_pointer.drag) return;
			
			var nx:Number = _container.contentX;
			var ny:Number = _container.contentY;
			var l:Number;
			
			if (_container.contentAreaHeight < _container.contentHeight)
			{
				if (ny > 0) ny = ZvrMath.smoothTrans(ny, 0, 0.1);
				
				l = _container.contentAreaHeight - _container.contentHeight;
				
				if (ny < l) ny = ZvrMath.smoothTrans(ny, l, 0.1);
			}
			else
			{
				if (ny != 0)  ny = ZvrMath.smoothTrans(ny, 0, 0.1);
			}
			
			if (_container.contentAreaWidth < _container.contentWidth)
			{
				if (nx > 0) nx = ZvrMath.smoothTrans(nx, 0, 0.1);
				
				l = _container.contentAreaWidth - _container.contentWidth;
				
				if (nx < l) nx = ZvrMath.smoothTrans(nx, l, 0.1);
			}
			else
			{
				if (nx > 0) nx = ZvrMath.smoothTrans(nx, 0, 0.1);
			}
			
			_container.setContentsPosition(nx, ny);
			
		}
		
		private function onDragBegin(p:Pointer):void 
		{
			_pointer.onDragEnd.addOnce(onDragEnd);
			_pointer.onDrag.add(onDrag);
			
			_lastY = p.globalY;
			_lastX = p.globalX;
		}
		
		private function onDrag(p:Pointer):void 
		{
			
			var ox:Number = _container.contentX;
			var oy:Number = _container.contentY;
			
			var nx:Number = _container.contentX;
			var ny:Number = _container.contentY;
			
			var d:Number;
			var l:Number;
			
			if (_container.contentAreaHeight < _container.contentHeight)
			{
				d = p.globalY - _lastY;
				
				ny = oy + d;
				
				if (ny > 0) 
				{
					if (margin == 0)
					{
						ny = 0;
					}
					else
					{
						if (d > 0)
						{
							ny = oy + d * (1 - (oy / margin));
						}
						
					}
				}
				
				l = _container.contentAreaHeight - _container.contentHeight;
				
				if (ny < l) 
				{
					if (margin == 0)
					{
						ny = l;
					}
					else
					{
						if (d < 0)
						{
							ny = oy + d * (1 - ((l - oy) / margin));
						}
					}
				}
				
			}
			
			if (_container.contentAreaWidth < _container.contentWidth)
			{
				d = p.globalX - _lastX;
				
				nx = ox + d;
				
				if (nx > 0) 
				{
					if (margin == 0)
					{
						nx = 0;
					}
					else
					{
						if (d > 0)
						{
							nx = ox + d * (1 - (ox / margin));
						}
						
					}
				}
				
				l = _container.contentAreaWidth - _container.contentWidth;
				
				if (nx < l) 
				{
					if (margin == 0)
					{
						nx = l;
					}
					else
					{
						if (d < 0)
						{
							nx = ox + d * (1 - ((l - ox) / margin));
						}
					}
				}
			}
			
			_container.setContentsPosition(nx, ny);
			
			_lastY = p.globalY;
			_lastX = p.globalX;
			
		}
		
		private function onDragEnd(p:Pointer):void 
		{
			_pointer.onDrag.remove(onDrag);
			_pointer.onDragBegin.addOnce(onDragBegin);	
		}
		
		override protected function disable():void 
		{
			super.disable();
			
			_pointer.onDragBegin.remove(onDragBegin);
			_pointer.onDragEnd.remove(onDragEnd);
			_pointer.onDrag.remove(onDrag);
			
		}
		
		
	}
	
	

}