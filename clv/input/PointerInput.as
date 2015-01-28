package clv.input 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	/**
	 * ...
	 * @author Zvir
	 */
	public class PointerInput 
	{
		private var _stage:Stage;
		
		public var ponterDownBlocker	:Vector.<IPointerBlocker> = new Vector.<IPointerBlocker>();
		public var ponterMoveBlocker	:Vector.<IPointerBlocker> = new Vector.<IPointerBlocker>();
		public var ponterUpBlocker		:Vector.<IPointerBlocker> = new Vector.<IPointerBlocker>();
		
		public function PointerInput() 
		{
			
		}
		
		public function init(stage:Stage):void
		{
			_stage = stage;
			
			enable();
		}
		
		private function enable():void 
		{
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			_stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			_stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);
			_stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		}
		
		private function disable():void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			_stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			_stage.removeEventListener(TouchEvent.TOUCH_END, touchEnd);
			_stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			
		}
		
		private function touchBegin(e:TouchEvent):void 
		{
			
		}
		
		private function touchEnd(e:TouchEvent):void 
		{
			
		}
		
		private function touchMove(e:TouchEvent):void 
		{
			
		}
		
		private function getBlock(v:Vector.<IPointerBlocker>):Boolean
		{
			for (var i:int = 0; i < v.length; i++) 
			{
				if (v[i].blockPoint) return true;
			}
			
			return false;
		}
	}

}