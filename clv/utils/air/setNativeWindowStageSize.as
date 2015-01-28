package clv.utils.air 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	/**
	 * ...
	 * @author ...
	 */
	
		
	public function setNativeWindowStageSize(w:Number, h:Number, n:NativeWindow) 
	{
		
		n.restore();
		
		var wo:Number = n.width - n.stage.stageWidth;
		var ho:Number = n.height - n.stage.stageHeight;
		
		n.width = w + wo;
		n.height = h + ho;
		
	}
		
	

}