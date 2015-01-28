package clv.gui.g2d.display 
{
	import clv.gui.core.behaviors.IPointerComponent;
	import clv.gui.core.ComponentSignal;
	import clv.gui.core.Pointer;
	import com.genome2d.components.GComponent;
	import com.genome2d.node.GNode;
	import com.genome2d.signals.GMouseSignal;
	import com.genome2d.signals.GNodeMouseSignal;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.utils.getTimer;
	import zvr.zvrTools.ZvrPntMath;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class G2DPointerComponent extends GComponent
	{
		private var _pointer:Pointer;
		private var _component:IPointerComponent;
		
		private var _rect:Rectangle = new Rectangle();
		private var _point:Point = new Point();
		
		public function G2DPointerComponent() 
		{
			super();
		}
		
		public static function addTo(component:IG2DPointerComponent):G2DPointerComponent
		{
			var p:G2DPointerComponent = GNode(component.body.displayBody).addComponent(G2DPointerComponent) as G2DPointerComponent;
			p.initComponent(component);
			return p;
		}
		
		public function initComponent(component:IG2DPointerComponent):void
		{
			_component = component;
			
			node.mouseEnabled = true;
			
			_pointer = component ? component.pointer : null;
			
			if (_pointer)
			{
				if (!_component.app)
				{
					_component.onAddedToApp.addOnce(addedToApp);
				}
				else
				{
					addedToApp(null);
				}
			}
			
			pointer.touch = Multitouch.supportsTouchEvents;
			
		}
		
		private function addedToApp(e:ComponentSignal):void 
		{
			_component.onRemovedFromApp.addOnce(removedFromApp);
			
			node.onMouseDown	.add(onMouseDown);	
			node.onMouseMove	.add(onMouseMove);	
			node.onMouseOut     .add(onMouseOut);   
			node.onMouseOver    .add(onMouseOver);   
			node.onMouseUp      .add(onMouseUp);
			
			_component.app.pointer.onWheel.add(onWheel);
			_component.app.pointer.onMove.add(onGlobalMove);
		}
		
		private function removedFromApp(e:ComponentSignal):void 
		{
			_component.onAddedToApp.addOnce(addedToApp);
			
			node.onMouseDown	.remove(onMouseDown);	
			node.onMouseMove	.remove(onMouseMove);	
			node.onMouseOut     .remove(onMouseOut);   
			node.onMouseOver    .remove(onMouseOver);   
			node.onMouseUp      .remove(onMouseUp); 
			
			_component.app.pointer.onWheel.remove(onWheel);
			_component.app.pointer.onMove.remove(onGlobalMove);
			
			if (_pointer.over)
			{
				_pointer.over = false;
				_pointer.onRollOut.dispatch(_pointer);
			}
			
			if (_pointer.down)
			{
				_pointer.down = false;
				_pointer.onUp.dispatch(_pointer);
			}
			
			if (_pointer.drag)
			{
				_pointer.drag = false;
				_pointer.onDragEnd.dispatch(_pointer);
			}
			
			if (_pointer.inside)
			{
				_pointer.inside = false;
				_pointer.onOutside.dispatch(_pointer);
			}
		}
		
		private function onMouseUp(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			
			_pointer.isDispather = e.target == e.dispatcher;
			
			update(e);
			
			_pointer.down = false;
			
			_pointer.onUp.dispatch(_pointer);
			
			//trace(getTimer() - _pointer.downTime);
			
			var d:Number = Math.sqrt((_component.app.pointer.x -_pointer.downX) * (_component.app.pointer.x -_pointer.downX) + (_component.app.pointer.y -_pointer.downY) * (_component.app.pointer.y -_pointer.downY));
			
			if (getTimer() - _pointer.downTime < _pointer.pointTimeInterval && _pointer.inside && d < _pointer.pointTrigerDistance)
			{
				_pointer.onPoint.dispatch(_pointer);
			}
			
			if (_pointer.drag)
			{
				_pointer.drag = false;
				_pointer.onDragEnd.dispatch(_pointer);
				_component.app.pointer.onUp.remove(appUp);
			}
			
		}
		
		private function onMouseOver(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			
			//if (e.target != e.dispatcher) return;
			
			update(e);
			
			_pointer.over = true;
			
			_pointer.onRollOver.dispatch(_pointer);
			
			if (_component.app.pointer.down)
			{
				_pointer.onDragIn.dispatch(_pointer);
				_pointer.downTime = getTimer();
			}
		}
		
		private function onMouseOut(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			
			//if (e.target != e.dispatcher) return;
			
			update(e);
			
			_pointer.over = false;
			
			_pointer.onRollOut.dispatch(_pointer);
			
			if (_component.app.pointer.down)
			{
				_pointer.onDragOut.dispatch(_pointer);
			}
			
			_pointer.down = false;
		}
		
		private function onMouseMove(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			_pointer.lastX = _pointer.x;
			_pointer.lastY = _pointer.y;
			
			update(e);
			
			_pointer.onMove.dispatch(_pointer);
			
			if (_pointer.down && !_pointer.drag)
			{
				var d:Number = Math.sqrt((_component.app.pointer.x -_pointer.downX) * (_component.app.pointer.x -_pointer.downX) + (_component.app.pointer.y -_pointer.downY) * (_component.app.pointer.y -_pointer.downY));
				
				if (d > _pointer.dragTrigerDistance && _pointer.dragTrigerDistance != 0)
				{
					_pointer.drag = true;
					_pointer.onDragBegin.dispatch(_pointer);
					_component.app.pointer.onUp.add(appUp);
				}
			}
			
		}
		
		private function appUp(p:Pointer):void 
		{
			if (_pointer.drag)
			{
				_pointer.drag = false;
				_pointer.onDragEnd.dispatch(_pointer);
			}
			
			if (_component.app) _component.app.pointer.onUp.remove(appUp);
			
		}
		
		public function update(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			
			_pointer.isDispather = e.target == e.dispatcher;
			
			_pointer.lastX = _pointer.x
			_pointer.lastY = _pointer.y
			
			_pointer.x = e.localX;
			_pointer.y = e.localY;
		}
		
		{
		public function updateGlobal():void 
			_pointer.lastGlobalX = _pointer.globalX;
			_pointer.lastGlobalY = _pointer.globalY;
			
			_pointer.globalX = _component.app.pointer.x;
			_pointer.globalY = _component.app.pointer.y;
		}
		
		private function onMouseDown(e:GNodeMouseSignal):void 
		{
			if (!pointer.enabled) return;
			
			update(e);
			
			updateGlobal();
			
			_pointer.downX = _component.app.pointer.x;
			_pointer.downY = _component.app.pointer.y;
			
			if (!_pointer.over)
			{
				_pointer.over = true;
				_pointer.onRollOver.dispatch(_pointer);
			}
			
			if (!_pointer.inside)
			{
				_pointer.inside = true;
				_pointer.onInside.dispatch(_pointer);
			}
			
			_pointer.down = true;
			_pointer.onDown.dispatch(_pointer);
			_pointer.downTime = getTimer();
			
			if (_pointer.dragTrigerDistance == 0 && !_pointer.drag)
			{
				_pointer.drag = true;
				_pointer.onDragBegin.dispatch(_pointer);
				_component.app.pointer.onUp.add(appUp);
			}
		}
		
		private function onWheel(p:Pointer):void 
		{
			if (!pointer.enabled) return;
			if (!_pointer.inside) return;
			_pointer.wheel = p.wheel;
			_pointer.onWheel.dispatch(_pointer);
		}
		
		private function onGlobalMove(p:Pointer):void 
		{
			if (!pointer.enabled) return;
			
			updateGlobal();
			
			if (_pointer.drag)
			{
				_pointer.onDrag.dispatch(_pointer);
			}
			
		}
		
		override public function processContextMouseSignal(p_captured:Boolean, p_cameraX:Number, p_cameraY:Number, p_contextSignal:GMouseSignal):Boolean 
		{
			
			if (!pointer.enabled) return false;
			
			_rect.width = _component.bounds.width;
			_rect.height = _component.bounds.height;
			
			_point.x = p_cameraX;
			_point.y = p_cameraY;
			
			var inside:Boolean = _rect.containsPoint(node.transform.globalToLocal(_point));
			
			if (inside && !_pointer.inside)
			{
				_pointer.inside = true;
				_pointer.onInside.dispatch(_pointer);
			}
			
			if (!inside && _pointer.inside)
			{
				_pointer.inside = false;
				_pointer.onOutside.dispatch(_pointer);
			}
			
			return false;
		}
		
		public function get pointer():Pointer 
		{
			return _pointer;
		}
		
		
	}

}