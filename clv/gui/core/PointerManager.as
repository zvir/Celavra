package clv.gui.core 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class PointerManager extends Pointer
	{
		
		private var _stage:Stage;
		public var poinsters:Vector.<Pointer> = new Vector.<Pointer>();
		
		/*public var appX:Number = 0;
		public var appY:Number = 0;*/
		
		public function PointerManager() 
		{
			
		}
		
		public function init(stage:Stage):void
		{
			_stage = stage;
			
			//touch = Multitouch.supportsTouchEvents;   
			
			/*if (Multitouch.supportsTouchEvents && !Multitouch.mapTouchToMouse)
			{*/
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin, false, int.MAX_VALUE);
			stage.addEventListener(TouchEvent.TOUCH_END, touchEnd, false, int.MAX_VALUE);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove, false, int.MAX_VALUE);
			/*}
			else
			{*/
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, int.MAX_VALUE);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, int.MAX_VALUE);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, int.MAX_VALUE);
			stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseRelaseOutside, false, int.MAX_VALUE);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, int.MAX_VALUE);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave, false, int.MAX_VALUE);
			/*}*/
			
		}
		
		private function touchBegin(e:TouchEvent):void 
		{
			if (e.isPrimaryTouchPoint && Multitouch.mapTouchToMouse) return;
			updateDefaultFromTouch(e);
			down = true;
			_onDown.dispatch(this);
		}
		
		private function touchEnd(e:TouchEvent):void 
		{
			if (e.isPrimaryTouchPoint && Multitouch.mapTouchToMouse) return;
			updateDefaultFromTouch(e);
			down = false;
			_onUp.dispatch(this);
		}
		
		private function touchMove(e:TouchEvent):void 
		{
			if (e.isPrimaryTouchPoint && Multitouch.mapTouchToMouse) return;
			updateDefaultFromTouch(e);
			_onMove.dispatch(this);
		}
		
		private function updateDefaultFromTouch(e:TouchEvent):void 
		{
			touch = true;
			x = e.stageX;
			y = e.stageY;
		}
		
		private function updateDefaultFromMouse():void 
		{
			touch = false;	
			x = _stage.mouseX;
			y = _stage.mouseY;
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			updateDefaultFromMouse();
			_onMove.dispatch(this);
		}
		
		private function mouseLeave(e:Event):void 
		{
			updateDefaultFromMouse();
			_onLeave.dispatch(this);
		}
		
		private function mouseWheel(e:MouseEvent):void 
		{
			updateDefaultFromMouse();
			wheel = e.delta;
			_onWheel.dispatch(this);
			wheel = 0;
		}
		
		private function mouseRelaseOutside(e:MouseEvent):void 
		{
			down = false;
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			updateDefaultFromMouse();
			down = false;
			_onUp.dispatch(this);
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			updateDefaultFromMouse();
			down = true;
			_onDown.dispatch(this);
		}
		
	}

}