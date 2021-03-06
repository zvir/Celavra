package clv.gui.g2d.behaviors 
{
	import clv.gui.common.states.ButtonState;
	import clv.gui.core.behaviors.Behavior;
	import clv.gui.core.behaviors.IPointerComponent;
	import clv.gui.core.Pointer;
	import com.genome2d.node.GNode;
	import com.genome2d.signals.GNodeMouseSignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ButtonBehavior extends Behavior
	{
		public static const NAME:String = "ButtonBehavior";
		
		private var pointer:Pointer;
		
		public function ButtonBehavior() 
		{
			super("ButtonBehavior");
			_stageSensitive = true;
		}
		
		override protected function enable():void 
		{

			super.enable();
			
			pointer = IPointerComponent(component).pointer;
			
			pointer.onDown.add(onDown);
			pointer.onDragIn.add(onDragIn);
			pointer.onDragOut.add(onDragOut);
			pointer.onRollOver.add(onRollOver);
			pointer.onRollOut.add(onRollOut);
			
		}
		
		override protected function disable():void 
		{
			super.disable();
			
			pointer.onDown.remove(onDown);
			pointer.onDragIn.remove(onDragIn);
			pointer.onDragOut.remove(onDragOut);
			pointer.onRollOver.remove(onRollOver);
			pointer.onRollOut.remove(onRollOut);
			
			component.app.poniner.onUp.remove(onUp);
			
			component.removeState(ButtonState.OVER);
			component.removeState(ButtonState.DOWN);
			
		}
		
		private function onRollOut(p:Pointer):void 
		{
			component.removeState(ButtonState.OVER);
		}
		
		private function onRollOver(p:Pointer):void 
		{
			component.addState(ButtonState.OVER);
		}
		
		private function onDragOut(p:Pointer):void 
		{
			component.removeState(ButtonState.OVER);
			component.removeState(ButtonState.DOWN);
			component.app.poniner.onUp.remove(onUp);
		}
		
		private function onDragIn(p:Pointer):void 
		{
			component.addState(ButtonState.OVER);
			component.addState(ButtonState.DOWN);
			component.app.poniner.onUp.addOnce(onUp);
		}
		
		private function onDown(p:Pointer):void 
		{
			component.addState(ButtonState.DOWN);
			component.app.poniner.onUp.addOnce(onUp);
		}
		
		private function onUp(p:Pointer):void 
		{
			component.removeState(ButtonState.DOWN);
		}
		
		/*
		private function onMouseOver(e:GNodeMouseSignal):void 
		{
			//component.removeState(ButtonState.OUT);
			component.addState(ButtonState.OVER);
		}
		
		private function onMouseOut(e:GNodeMouseSignal):void 
		{
			component.removeState(ButtonState.OVER);
			//component.addState(ButtonState.OUT);
		}
		
		private function onMouseUp(p:Pointer):void 
		{
			pointerSensitive.onMouseUp.remove(onMouseUpClick);
			component.removeState(ButtonState.DOWN);
			//component.addState(ButtonState.UP);
		}
		
		private function onMouseDown(e:GNodeMouseSignal):void 
		{
			component.addState(ButtonState.DOWN);
			//component.removeState(ButtonState.UP);
			
			component.app.poniner.onUp.addOnce(onMouseUp);
			
			pointerSensitive.onMouseUp.addOnce(onMouseUpClick);
			
		}
		
		private function onMouseUpClick(e:GNodeMouseSignal):void 
		{
			onClick.dispatch();
		}*/
		
		
		
	}

}