package clv.gui.g2d.components 
{
	import clv.gui.common.styles.TextStyle;
	import clv.gui.common.styles.TextStyleAlign;
	import clv.gui.core.Component;
	import clv.gui.core.skins.Skin;
	import clv.gui.g2d.core.SkinG2D;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.StageText;
	import flash.text.TextFormatAlign;
	import zvr.zvrG2D.ZvrG2DMouseRectComponent;
	/**
	 * ...
	 * @author Zvir
	 */
	public class StageTextInputSkin extends SkinG2D
	{
		private var _onStage:Boolean;
		private var _body:StageTextIInputSkinBody;
		//private var //_mouseRect:ZvrG2DMouseRectComponent;
		
		public function StageTextInputSkin() 
		{
			
		}
		
		override protected function registerStyles():void 
		{
			registerStyle(TextStyle.TEXT	, setText);
			registerStyle(TextStyle.ALIGN	, setAlign);
			registerStyle(TextStyle.FONT	, setFont);
			registerStyle(TextStyle.SIZE	, setSize);
			registerStyle(TextStyle.COLOR	, setColor);
			registerStyle(TextStyle.BOLD	, setWeight);
			registerStyle(TextStyle.ITALIC	, setPosture);
		}
		
		private function setPosture():void 
		{
			var b:Boolean = getStyle(TextStyle.ITALIC);
			_body.text.fontPosture = b ? FontPosture.ITALIC : FontWeight.NORMAL;
		}
		
		private function setWeight():void 
		{
			var b:Boolean = getStyle(TextStyle.BOLD);
			_body.text.fontWeight = b ? FontWeight.BOLD : FontWeight.NORMAL;
		}
		
		private function setColor():void 
		{
			_body.text.color = getStyle(TextStyle.COLOR);
		}
		
		private function setSize():void 
		{
			_body.text.fontSize = getStyle(TextStyle.SIZE);
		}
		
		private function setFont():void 
		{
			_body.text.fontFamily = getStyle(TextStyle.FONT);
		}
		
		private function setAlign():void 
		{
			_body.text.textAlign = getStyle(TextStyle.ALIGN);
		}
		
		private function setText():void 
		{
			var t:String = getStyle(TextStyle.TEXT);
			_body.text.text = t ? t : "";
		}
		
		override protected function setStyles():void 
		{
			setStyle(TextStyle.ALIGN			, TextFormatAlign.LEFT);
			setStyle(TextStyle.COLOR			, 0x0000000);
		}
		
		override protected function create():void 
		{
			super.create();
			
			_body = _skinNode.addComponent(StageTextIInputSkinBody) as StageTextIInputSkinBody;
			//_mouseRect = _skinNode.addComponent(ZvrG2DMouseRectComponent) as ZvrG2DMouseRectComponent;
		}
		
		override public function updateBounds():void 
		{
			super.updateBounds();
			
			if (!positionDirty && !sizeDirty) return;
			
			if (sizeDirty)
			{
				_body.width = _component.bounds.width;
				_body.height = _component.bounds.height;
			}
			
			if (positionDirty)
			{
				
			}
			
		}
		
		public function get textField():StageText
		{
			return _body.text;
		}
		
		public function set onStage(value:Boolean):void 
		{
			_onStage = value;
			
			if (!value) 
				_body.text.stage = null;
			else
				_body.text.stage = _skinNode.core.getContext().getNativeStage();
			
			
		}
	}

}