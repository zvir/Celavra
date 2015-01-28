package clv.utils.air 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class FullScreenOnMaximilize 
	{
		
		public function FullScreenOnMaximilize() 
		{
			
		}
		
		public static function init(stage:Stage):void
		{
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onWindowResize);
		}
		
		static private function onWindowResize(e:NativeWindowDisplayStateEvent):void 
		{
			if (e.afterDisplayState == NativeWindowDisplayState.MAXIMIZED)
			{
				e.preventDefault();
				NativeWindow(e.target).stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}
		
	}

}