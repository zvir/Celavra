package clv.gameDev.hexMap.tileEditor.ui.elements 
{
	import flash.display.BlendMode;
	import zvr.zvrGUI.components.minimalDark.SliderUIMD;
	import zvr.zvrGUI.events.ZvrSliderEvent;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class BlendModeControl extends SliderUIMD
	{
		
		
		static private var options:Array = 
		[
			BlendMode.NORMAL		,
			BlendMode.ADD          	,
			BlendMode.DARKEN       	,
			BlendMode.DIFFERENCE   	,
			BlendMode.ERASE        	,
			BlendMode.HARDLIGHT    	,
			BlendMode.INVERT       	,
			BlendMode.LIGHTEN      	,
			BlendMode.MULTIPLY     	,
			BlendMode.OVERLAY      	,
			BlendMode.SCREEN       	,
			BlendMode.SUBTRACT     
		]
		
		public function BlendModeControl() 
		{
			super();
			
			slider.step = 1;
			slider.max = options.length -1;
			slider.addEventListener(ZvrSliderEvent.POSITION_CHANGED, positionChange);
			slider.position = 0;
			positionChange(null);
		}
		
		private function positionChange(e:ZvrSliderEvent):void 
		{
			title.text = "Blend mode: " + options[slider.position].toUpperCase();
		}
		
		public function get blend():String
		{
			return options[slider.position];
		}
		
		public function set blend(v:String):void
		{
			slider.position = options.indexOf(v);
		}
	}

}