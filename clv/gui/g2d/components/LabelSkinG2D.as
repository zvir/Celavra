package clv.gui.g2d.components 
{
	import clv.gui.common.styles.TextStyle;
	import clv.gui.common.styles.TextStyleAlign;
	import clv.gui.g2d.core.SkinG2D;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.utils.GHAlignType;
	import zvr.zvrG2D.G2DFont;
	import zvr.zvrG2D.G2DFontFamily;
	import zvr.zvrG2D.text.GTextComponent;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LabelSkinG2D extends SkinG2D
	{
		private var _label:GTextComponent;
		
		private var _autoSizeToText:Boolean;
		
		private var _sprite:GSprite;
		
		private var _fontFamily:G2DFontFamily;
		
		private var _scale:Number = 1;
		private var _size:Number;
		
		public function LabelSkinG2D() 
		{
			
		}
		
		override protected function registerStyles():void 
		{
			registerStyle(TextStyle.TEXT				, setText);
			registerStyle(TextStyle.ALIGN				, setAlign);
			registerStyle(TextStyle.FONT				, setFont);
			registerStyle(TextStyle.SIZE				, setSize);
			registerStyle(TextStyle.COLOR				, setColor);
			registerStyle(TextStyle.LETTER_SPACING		, setLetterSpacing);
			registerStyle(TextStyle.LINE_SPACING		, setLineSpacing);
			registerStyle(TextStyle.AUTO_SIZE_TO_TEXT	, autoSizeToText);
		}
		
		override protected function setStyles():void 
		{
			setStyle(TextStyle.ALIGN			, TextStyleAlign.LEFT);
			setStyle(TextStyle.LETTER_SPACING	, 0);
			setStyle(TextStyle.LINE_SPACING		, 0);
			setStyle(TextStyle.AUTO_SIZE_TO_TEXT, true);
			setStyle(TextStyle.COLOR, 0xFFFFFF);
		}
		
		override protected function create():void 
		{
			super.create();
			
			_label = _skinNode.addComponent(GTextComponent) as GTextComponent;
			_label.onTextChanged.add(onTextChanged);
		}
		
		private function autoSizeToText():void 
		{
			_autoSizeToText = getStyle(TextStyle.AUTO_SIZE_TO_TEXT);
			
			if (_autoSizeToText)
			{
				_label.autoSize = true;
			}
			else
			{
				_label.width = _component.width;
				label.autoSize = false;
			}
			
		}
		
		private function setLineSpacing():void 
		{
			_label.lineSpace = getStyle(TextStyle.LINE_SPACING);
		}
		
		private function setLetterSpacing():void 
		{
			_label.tracking = getStyle(TextStyle.LETTER_SPACING);
		}
		
		private function setFont():void 
		{
			
			var f:* = getStyle(TextStyle.FONT);
			
			trace(f);
			
			if (f is G2DFont)
			{
				_label.font = f as G2DFont;
				_fontFamily = null;
			}
			
			if (f is G2DFontFamily)
			{
				_fontFamily = f as G2DFontFamily;
				updateSizeOfFontFamly();
			}
			
			//getStyle(TextStyle.FONT);
		}
		
		private function setAlign():void 
		{
			var a:String =  getStyle(TextStyle.ALIGN);
			
			switch (a) 
			{
				case TextStyleAlign.LEFT: 	_label.hAlign = GHAlignType.LEFT; break;
				case TextStyleAlign.RIGHT: 	_label.hAlign = GHAlignType.RIGHT; break;
				case TextStyleAlign.CENTER: _label.hAlign = GHAlignType.CENTER; break;
			}
			
		}
		
		private function setSize():void 
		{
			var v:Number = getStyle(TextStyle.SIZE);
			
			if (!isNaN(v)) 
			{
				_size = v;
				
				if (_fontFamily)
				{
					updateSizeOfFontFamly();
				}
				else
				{
					_label.size = _size * _scale;
				}
			}
			
			
		}
		
		private function setColor():void 
		{
			var c:* = getStyle(TextStyle.COLOR);
			_skinNode.transform.color = uint(c);
		}
		
		private function onTextChanged(s:String):void 
		{
			if (_autoSizeToText)
			{
				_component.width = _label.width;
				_component.height = _label.height;
			}
		}
		
		override public function preUpdate():void
		{
			if (_component.app && _fontFamily && _component.app.scale != _scale)
			{
				_scale = _component.app.scale;
				updateSizeOfFontFamly();
			}
			
			if (_autoSizeToText)
			{
				_label.update();
				
				if (_component.width != _label.width) 
				{
					_component.width = _label.width;
				}
				if (_component.height != _label.height) 
				{
					_component.height = _label.height;
				}
			}
			else
			{
				if (_label.width != _component.bounds.width) 
				{
					_label.width = _component.bounds.width;
				}
				
				_label.update();
			}
		}
		
		override public function updateBounds():void 
		{
			super.updateBounds();
			
			/*if (sizeDirty)
			{
				if (_component.appScale != _scale && _fontFamily)
				{
					
				}
			}*/
			
			if (positionDirty)
			{
				if (_autoSizeToText)
				{
					if (_label.hAlign == GHAlignType.CENTER)
					{
						//_componentBody.x = int(_component.bounds.x) + _label.width / 2;
					}
					else if (_label.hAlign == GHAlignType.RIGHT)
					{
						//_componentBody.x = int(_component.bounds.x) + _label.width;
					}
					else
					{
						//_componentBody.x = int(_component.bounds.x);
					}
				}
				else
				{
					_componentBody.x = int(_component.bounds.x);
				}
				
				_componentBody.y = int(_component.bounds.y);
				
			}
		}
		
		private function updateSizeOfFontFamly():void 
		{
			if (!_fontFamily) return;
			
			var d:Number = Number.MAX_VALUE;
			
			var c:G2DFont;
			
			var s:Number = isNaN(_size) ? _fontFamily.fonts[0].size : _size;
			
			s *= _scale;
			
			for (var i:int = 0; i < _fontFamily.fonts.length; i++) 
			{
				var f:G2DFont = _fontFamily.fonts[i];
				
				var t:Number = Math.abs(s - f.size);
				
				if (t < d) 
				{
					c = f;
					d = t;
				}
				
			}
			
			trace(_scale, _size, c.size);
			
			_label.size = s;
			_label.font = c;
			
		}
		
		/*public function set text(v:String):void
		{
			setStyle(TextStyle.TEXT, v);
		}*/
		
		private function setText():void 
		{
			_label.text = getStyle(TextStyle.TEXT);
		}
		
		/*public function get text():String
		{
			return getStyle(TextStyle.TEXT);
		}*/
		
		/*public function get maxChars():Number 
		{
			return _label.maxChars;
		}
		
		public function set maxChars(value:Number):void 
		{
			_label.maxChars = value;
		}*/
		
		public function get label():GTextComponent 
		{
			return _label;
		}
	}

}