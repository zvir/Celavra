package clv.gui.g2d.components 
{
	import clv.gui.common.styles.TextStyle;
	import clv.gui.core.Component;
	import flash.text.StageText;
	/**
	 * ...
	 * @author Zvir
	 */
	public class StageTextInput extends Component
	{
		
		private var _textSkin:StageTextInputSkin;
		
		public function StageTextInput() 
		{
			_textSkin = new StageTextInputSkin();
			super(_textSkin);
		}
		
		public function set text(v:String):void
		{
			_textSkin.textField.text = v;
		}
		
		public function get text():String
		{
			return _textSkin.textField.text;
		}
		
		public function get size():Number 
		{
			return skin.getStyle(TextStyle.SIZE);
		}
		
		public function set size(value:Number):void 
		{
			skin.setStyle(TextStyle.SIZE, value);
		}
		
		public function get font():String 
		{
			return skin.getStyle(TextStyle.FONT);
		}
		
		public function set font(value:String):void 
		{
			skin.setStyle(TextStyle.FONT, value);
		}
		
		public function get color():uint 
		{
			return skin.getStyle(TextStyle.COLOR);
		}
		
		public function set color(value:uint):void 
		{
			skin.setStyle(TextStyle.COLOR, value);
		}
		
		public function get align():String 
		{
			return skin.getStyle(TextStyle.ALIGN);
		}
		
		public function set align(value:String):void 
		{
			skin.setStyle(TextStyle.ALIGN, value);
		}
		
		public function get bold():Boolean 
		{
			return skin.getStyle(TextStyle.BOLD);
		}
		
		public function set bold(value:Boolean):void 
		{
			skin.setStyle(TextStyle.BOLD, value);
		}
		
		public function get maxChars():int 
		{
			return _textSkin.textField.maxChars;
		}
		
		public function set maxChars(value:int):void 
		{
			_textSkin.textField.maxChars = value;
		}
		
		public function get restrict():String 
		{
			return _textSkin.textField.restrict;
		}
		
		public function set restrict(value:String):void 
		{
			_textSkin.textField.restrict = value;
		}
		
		public function set autoCapitalize(value:String):void 
		{
			_textSkin.textField.autoCapitalize = value;
		}
		
		override protected function addedToApp():void 
		{
			super.addedToApp();
			_textSkin.onStage = true;
		}
		
		override protected function removedFromApp():void 
		{
			super.removedFromApp();
			_textSkin.onStage = false;
		}
		
	}

}