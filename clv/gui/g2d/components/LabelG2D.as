package clv.gui.g2d.components 
{
	import clv.genome2d.components.StageTextComponent;
	import clv.gui.common.styles.TextStyle;
	import clv.gui.core.Component;
	import com.genome2d.signals.GNodeMouseSignal;
	import flash.events.Event;
	import flash.text.Font;
	import org.osflash.signals.Signal;
	import zvr.zvrG2D.G2DFont;
	import zvr.zvrG2D.text.GTextComponent;
	import zvr.zvrG2D.ZvrG2DMouseRectComponent;
	import zvr.zvrKeyboard.ZvrInputSignal;
	import zvr.zvrKeyboard.ZvrInputTextField;
	import zvr.zvrLocalization.IZvrLocEditLabel;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LabelG2D extends Component
	{
		private var _editable:Boolean;
		private var _labelSkin:LabelSkinG2D;
		private var _mouseRect:ZvrG2DMouseRectComponent;
		private var _stageText:StageTextComponent;
		private var _editing:Boolean;
		private var _onEdit:Signal;
		
		public var editFont:String;
		public var editColor:uint = 0x000000;
		
		public function LabelG2D() 
		{
			_labelSkin = new LabelSkinG2D();
			super(_labelSkin);
			_scaleble = false;
		}

		
		override protected function resized():void 
		{
			super.resized();
			
			if (_mouseRect)
			{
				_mouseRect.rect.width = bounds.width;
				_mouseRect.rect.height = bounds.height;
			}
			
			if (_stageText)
			{
				_stageText.setSize(bounds.width, bounds.height);
			}
		}
		
		/*override public function get maxWidth():Number 
		{
			return super.maxWidth;
		}
		
		override public function set maxWidth(value:Number):void 
		{
			super.maxWidth = value;
			_labelSkin.label.width = value;	
			_labelSkin.label.autoSize = false;	
		}*/
		
		public function set text(v:String):void
		{
			skin.setStyle(TextStyle.TEXT, v);
		}
		
		public function get text():String
		{
			return skin.getStyle(TextStyle.TEXT);
		}
		
		public function get size():Number 
		{
			return skin.getStyle(TextStyle.SIZE);
		}
		
		public function set size(value:Number):void 
		{
			skin.setStyle(TextStyle.SIZE, value);
		}
		
		public function get font():G2DFont 
		{
			return skin.getStyle(TextStyle.FONT);
		}
		
		public function set font(value:G2DFont):void 
		{
			skin.setStyle(TextStyle.FONT, value);
		}
		
		public function get lineSpacing():Number 
		{
			return skin.getStyle(TextStyle.LINE_SPACING);
		}
		
		public function set lineSpacing(value:Number):void 
		{
			skin.setStyle(TextStyle.LINE_SPACING, value);
		}
		
		public function get letterSpacing():Number 
		{
			return skin.getStyle(TextStyle.LETTER_SPACING);
		}
		
		public function set letterSpacing(value:Number):void 
		{
			skin.setStyle(TextStyle.LETTER_SPACING, value);
		}
		
		public function get align():String 
		{
			return skin.getStyle(TextStyle.ALIGN);
		}
		
		public function set align(value:String):void 
		{
			skin.setStyle(TextStyle.ALIGN, value);
		}
		
		public function get color():uint 
		{
			return skin.getStyle(TextStyle.COLOR);
		}
		
		public function set color(value:uint):void 
		{
			skin.setStyle(TextStyle.COLOR, value);
		}
		
		public function get autoSize():Boolean 
		{
			return skin.getStyle(TextStyle.AUTO_SIZE_TO_TEXT);
		}
		
		public function set autoSize(value:Boolean):void 
		{
			skin.setStyle(TextStyle.AUTO_SIZE_TO_TEXT, value);
		}
		
		/*public function get maxChars():Number 
		{
			return _labelSkin.maxChars;
		}
		
		public function set maxChars(value:Number):void 
		{
			_labelSkin.maxChars = value;
		}*/
		
		public function get editable():Boolean 
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void 
		{
			
			if (_editable == value) return;
			
			_editable = value;
			
			if (_editable)
			{
				_mouseRect = _labelSkin.skinNode.addComponent(ZvrG2DMouseRectComponent) as ZvrG2DMouseRectComponent;
				_stageText = _labelSkin.skinNode.addComponent(StageTextComponent) as StageTextComponent;
				_mouseRect.rect.width = bounds.width;
				_mouseRect.rect.height = bounds.height;
				_mouseRect.reportOuside = true;
				_labelSkin.skinNode.onMouseDown.add(mouseDown);
				//_labelSkin.skinNode.onMouseOutside.remove(mosueOutsideSignal);
				_labelSkin.skinNode.mouseEnabled = true;
			}
			else
			{
				_labelSkin.skinNode.removeComponent(ZvrG2DMouseRectComponent);
				_labelSkin.skinNode.onMouseDown.remove(mouseDown);
			}
			
		}
		
		/*public function get processText():Function 
		{
			return _labelSkin.label.processText;
		}*/
		
		/*public function set processText(value:Function):void 
		{
			_labelSkin.label.processText = value;
		}*/
		
		private function mouseDown(e:GNodeMouseSignal):void 
		{
			if (_mouseRect.ouside && _editing)
			{
				stopEdit();
			}
			
			if (!_mouseRect.ouside && !_editing)
			{
				startEdit();
			}
			
			if (!_mouseRect.ouside && _editing)
			{/*
				var i:int = _labelSkin.label.getCharIndexAt(e.localX, e.localY);
				ZvrInputTextField.setSelection(i, i);*/
			}
			
		}
		
		private function stopEdit():void 
		{
			_editing = false;
			
			/*ZvrInputTextField.end();
			ZvrInputTextField.onChange.remove(textChangeSignal);
			_labelSkin.label.showCaret = false;*/
			
			_stageText.end();
			
			text = _stageText.stageText.text;
			
			//_labelSkin.skinNode.removeComponent(StageTextComponent);
		}
		
		private function startEdit():void 
		{
			
			_stageText.setSize(bounds.width, bounds.height);
			_stageText.begin();
			_stageText.stageText.text = text;
			_stageText.complete.addOnce(editComplete);
			text = "";
			if (editFont) _stageText.stageText.fontFamily = editFont;
			_editing = true;
			
			
			
			/*
			_stageText.stageText.color = editColor;
		/*
			ZvrInputTextField.begin(_labelSkin.skinNode.core.getContext().getNativeStage(), text, 0, 0, true);
			ZvrInputTextField.onChange.add(textChangeSignal);
			ZvrInputTextField.maxChars = maxChars;
			ZvrInputTextField.multiline = false;
			_labelSkin.label.showCaret = true;*/
		}
		
		private function editComplete():void 
		{
			stopEdit();
		}
		
		private function textChangeSignal(e:ZvrInputSignal):void 
		{
			/*_labelSkin.label.text = e.text;
			_labelSkin.label.caretIndex = e.selectionEnd;*/
		}
		
	}

}