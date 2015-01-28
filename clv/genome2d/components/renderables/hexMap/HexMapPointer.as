package clv.genome2d.components.renderables.hexMap 
{
	import clv.games.theFew.ui.MainApp;
	import clv.games.theFew.ui.strategy.hexMapUI.HexMapUI;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import zvr.zvrBehaviors.pointer.ZvrPointerSignal;
	import zvr.zvrTools.ZvrPnt;
	/**
	 * ...
	 * @author ...
	 */
	public class HexMapPointer 
	{
		private var _hexMap:HexMap;
		private var _stage:Stage;
		
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		/*public var pointerX:Number;
		public var pointerY:Number;*/
		
		public var mainPointer:ZvrPointerSignal;
		public var pointers:Object = { };
		
		public var onPointerAdded:Signal = new Signal(ZvrPointerSignal);
		public var onPointerRemoved:Signal = new Signal(ZvrPointerSignal);
		public var onPointerMove:Signal = new Signal(ZvrPointerSignal);
		
		public var onMainPointerAdded:Signal = new Signal(ZvrPointerSignal);
		public var onMainPointerRemoved:Signal = new Signal(ZvrPointerSignal);
		public var onMainPointerMove:Signal = new Signal(ZvrPointerSignal);
		
		public var onPointerHexChange:Signal = new Signal();
		
		public var hex:HexTile;
		
		public function HexMapPointer() 
		{
			
		}
		
		public function init(hexMap:HexMap):void
		{
			if (hexMap || _stage)
			{
				dispose();
			}
			
			_hexMap = hexMap;
			
			if (_hexMap.node.isOnStage())
			{
				onAddedToStage();
			}
			else
			{
				_hexMap.node.onAddedToStage.addOnce(onAddedToStage);
			}
			
		}
		
		private function onAddedToStage():void 
		{
			_stage = _hexMap.node.core.getContext().getNativeStage();
			
			_hexMap.node.onRemovedFromStage.addOnce(removedFromStage);
			
			enable();
		}
		
		private function removedFromStage():void 
		{
			disable();
		}
		
		public function update():void
		{	
			
			for each (var s:ZvrPointerSignal in pointers) 
			{
				var change:Boolean = s.globalX !=  s.lastGlobalX || s.globalY !=  s.lastGlobalY;
				
				s.localX = getPointerX(s.globalX);
				s.localY = getPointerY(s.globalY);
					
				if (change)
				{
					onPointerMove.dispatch(s);
					
					s.lastGlobalX = s.globalX;
					s.lastGlobalY = s.globalY;
					
					if (s == mainPointer)
					{
						onMainPointerMove.dispatch(mainPointer);
						
						var h:HexTile = _hexMap.getMapUnderPoint(mainPointer.localX, mainPointer.localY);
					}
					
				}
				
			}
			
		}
		
		private function updateHex(s:ZvrPointerSignal):void
		{
			var h:HexTile = _hexMap.getMapUnderPoint(getPointerX(s.globalX), getPointerY(s.globalY));
			if (h != hex)
			{
				hex = h;
				onPointerHexChange.dispatch();
			}
		}
		
		public function enable():void
		{
			if (_stage) 
			{
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				
				_stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
				_stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);
				_stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			}
		}
		
		public function disable():void
		{
			if (_stage) 
			{
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				
				_stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
				_stage.removeEventListener(TouchEvent.TOUCH_END, touchEnd);
				_stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			}
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			if (MainApp.instance.pointerOver || HexMapUI.instance.pointerOver) return;
			
			addPoint( -1, e.stageX, e.stageY);
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			removePoint( -1, e.stageX, e.stageY, false);
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			updatePoint( -1, e.stageX, e.stageY);
		}
		
		private function touchBegin(e:TouchEvent):void 
		{
			if (MainApp.instance.pointerOver || HexMapUI.instance.pointerOver) return;
			
			addPoint(e.touchPointID, e.stageX, e.stageY);
		}
		
		private function touchMove(e:TouchEvent):void 
		{
			updatePoint(e.touchPointID, e.stageX, e.stageY);
		}
		
		private function touchEnd(e:TouchEvent):void 
		{
			removePoint(e.touchPointID, e.stageX, e.stageY);
		}
		
		private function addPoint(id:int, globalX:Number, globalY:Number)
		{
			var s:ZvrPointerSignal;
			
			s = pointers[id];
			
			if (!s)
			{
				s = new ZvrPointerSignal(id, globalX, globalY, getPointerX(globalX), getPointerY(globalY));
				pointers[id] = s;
			}
			else
			{
				s.globalX = globalX;
				s.globalY = globalY;
			}
			
			s.down = true;
			
			onPointerAdded.dispatch(s);
			
			if (!mainPointer)
			{
				mainPointer = s;
			}
			
			if (mainPointer == s)
			{
				updateHex(s);
				onMainPointerAdded.dispatch(s);
			}
			
		}
		
		private function removePoint(id:int, globalX:Number, globalY:Number, tempPoint:Boolean = true):void 
		{
			
			var s:ZvrPointerSignal;
			
			s = pointers[id];
			
			if (!s) 
			{
				return;
			}
			
			s.globalX = globalX;
			s.globalY = globalY;
			
			s.localX = getPointerX(globalX);
			s.localY = getPointerY(globalY);
			
			s.down = false;
			
			if (mainPointer == s)
			{
				updateHex(s);
				onMainPointerRemoved.dispatch(s);
			}
			
			onPointerRemoved.dispatch(s);
			
			if (mainPointer == s && tempPoint)
			{
				mainPointer = null;
			}
			
			if (tempPoint)
			{
				pointers[id] = undefined;
				delete pointers[id];
			}
			
		}
		
		private function updatePoint(id:int, globalX:Number, globalY:Number):void 
		{
			var s:ZvrPointerSignal;
			
			s = pointers[id];
			
			if (!s)
			{
				s = new ZvrPointerSignal(id, globalX, globalY, getPointerX(globalX), getPointerY(globalY));
				pointers[id] = s;
			}
			
			//trace("update point");
			
			s.globalX = globalX;
			s.globalY = globalY;
			
			/*s.localX = getPointerX(globalX);
			s.localY = getPointerY(globalY);*/
			
			if (!mainPointer)
			{
				mainPointer = s;
			}
			
			if (s == mainPointer)
			{
				updateHex(s);
			}
		}
		
		public function getPointerX(globalX:Number):Number
		{
			return globalX * 1 / _hexMap.scale + (_hexMap.viewX + _hexMap.mapWidth * _hexMap.tileWidth / 2) - _hexMap.node.transform.g2d_worldX;
		}
		
		public function getPointerY(globalY:Number):Number
		{
			return globalY * 1 / _hexMap.scale + (_hexMap.viewY + _hexMap.mapHeight * _hexMap.rowHeight / 2) - _hexMap.node.transform.g2d_worldY;
		}
		
		public function getLocalX():Number
		{
			return mainPointer ? getPointerX(mainPointer.globalX) : 0;
		}
		
		public function getLocalY():Number
		{
			return  mainPointer ? getPointerY(mainPointer.globalY) : 0;
		}
		
		public function dispose():void
		{
			disable();
			
			if (_hexMap)
			{
				_hexMap.node.onRemovedFromStage.remove(removedFromStage);
				_hexMap.node.onAddedToStage.remove(onAddedToStage);
			}
			
			_hexMap = null;
			_stage = null;
			
			pointers = { };
		}
		
	}

}