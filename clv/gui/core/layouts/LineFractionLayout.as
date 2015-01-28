package clv.gui.core.layouts 
{
	import clv.gui.core.IComponent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LineFractionLayout extends Layout
	{
		
		public var verticalAlign		:String;
		
		public var horizontalAlign		:String;
		
		public var alignment			:String = Alignment.HORIZONTAL;
		
		private var _lastPos:Number = 0.0;
		private var _childrenSize	:Number = 0;;
		private var _childrenOffset:Number;
		private var _space:Number;
		
		public var gap:Number = 4;
		
		
		public function LineFractionLayout() 
		{
			
		}
		
		override public function begin(contentWidth:Number, contentHeight:Number, contentIndependentRight:Number, contentIndependentBottom:Number, contentMaxIndependentWidth:Number, contentMaxIndependentHeight:Number, children:Vector.<IComponent>):void 
		{
			super.begin(contentWidth, contentHeight, contentIndependentRight, contentIndependentBottom, contentMaxIndependentWidth, contentMaxIndependentHeight, children);
			
			_lastPos = 0.0;
			_childrenSize = 0.0;
			_childrenOffset = 0.0;
			
			if (alignment == Alignment.HORIZONTAL)
			{
				
				if (!isNaN(_contentWidth))
				{
					var cw:Number = contentWidth - gap * (children.length - 1);
					var cs:Number = 0;
					
					for (i = 0; i < children.length; i++) 
					{
						var child:IComponent = children[i]
						
						if (!isNaN(child.independentBounds.fw))
						{
							cs += child.independentBounds.fw;
						}
						else
						{
							cw -= child.independentBounds.w;
						}
						
						cw -= child.right;
						cw -= child.left;
					}
					
					_space = cw / cs;
					
					for (i = 0; i < children.length; i++) 
					{
						
						child = children[i];
						
						if (_space > child.maxWidth)
						{
							_space -= (child.maxWidth- _space) / (children.length-1)
						}
						
						if (_space < child.minWidth)
						{
							_space += (_space - child.minWidth) / (children.length-1)
						}
						
					}
					
				}
				
				for (var i:int = 0; i < children.length; i++) 
				{
					_childrenSize += children[i].independentBounds.W + gap;
				}
				
				_childrenSize -= gap;
				
				if (!isNaN(_contentWidth))
				{
					switch (horizontalAlign) 
					{
						case HorizontalAlignment.LEFT:		_childrenOffset = 0; break;
						case HorizontalAlignment.CENTER:	_childrenOffset = (contentWidth - _childrenSize) /2; break;
						case HorizontalAlignment.RIGHT:		_childrenOffset = contentWidth - _childrenSize; break;
						default: _childrenOffset = 0;
					}
				}
			}
			else if (alignment == Alignment.VERTICAL)
			{
				
				if (!isNaN(contentHeight))
				{
					var ch:Number = contentHeight - gap * (children.length - 1);
					cs = 0;
					
					for (i = 0; i < children.length; i++) 
					{
						child = children[i]
						
						if (!isNaN(child.independentBounds.fh))
						{
							cs += child.independentBounds.fh;
						}
						else
						{
							ch -= child.independentBounds.h;
						}
						
						ch -= child.top;
						ch -= child.bottom;
					}
					
					_space = ch / cs;
					
					for (i = 0; i < children.length; i++) 
					{
						
						child = children[i];
						
						if (_space > child.maxHeight)
						{
							_space -= (child.maxHeight- _space) / (children.length-1)
						}
						
						if (_space < child.minHeight)
						{
							_space += (_space - child.maxHeight) / (children.length-1)
						}
						
					}
					
				}
				
				if (!isNaN(contentHeight))
				{
					switch (verticalAlign) 
					{
						case VerticalAlignment.BOTTOM:	_childrenOffset = 0; break;
						case VerticalAlignment.MIDDLE:	_childrenOffset = (contentHeight - _childrenSize) /2; break;
						case VerticalAlignment.TOP:		_childrenOffset = contentHeight - _childrenSize; break;
						default: _childrenOffset = 0;
					}
				}
			}
			
			if (_childrenOffset < 0) _childrenOffset = 0;
			
		}
		
		override public function layout(child:IComponent):Rectangle 
		{
			var r:Rectangle;
			
			var w:Number = isNaN(_contentWidth) ? _contentIndependentRight : _contentWidth;
			var h:Number = isNaN(_contentHeight) ? _contentIndependentBottom : _contentHeight;
			
			if (alignment == Alignment.HORIZONTAL)
			{
				
				if (!isNaN(child.independentBounds.fw))
				{
					var cw:Number = child.independentBounds.fw * _space;
					cw = cw > child.maxWidth ? child.maxWidth : ch < child.minWidth ? child.minWidth : cw;
				}
				else
				{
					cw = child.independentBounds.W;
				}
				
				r = new Rectangle(_lastPos + _childrenOffset, 0, cw, h);
				
				_lastPos += cw + gap;
				
				switch (verticalAlign) 
				{
					case VerticalAlignment.BOTTOM:	child.bottom = 0; 	break;
					case VerticalAlignment.MIDDLE:	child.vCenter = 0; 	break;
					case VerticalAlignment.TOP:		child.top = 0; 		break;
				}
				
				
			
			}
			else if (alignment == Alignment.VERTICAL)
			{
				
				if (!isNaN(child.independentBounds.fh))
				{
					var ch:Number = child.independentBounds.fh * _space;
					ch = ch > child.maxHeight ? child.maxHeight : ch < child.minHeight ? child.minHeight : ch;
				}
				else
				{
					ch = child.independentBounds.H;
				}
				
				
				r =  new Rectangle(0, _lastPos + _childrenOffset, w, ch);
				
				_lastPos += ch + gap;
				
				switch (horizontalAlign) 
				{
					case HorizontalAlignment.LEFT:		child.left = 0; 	break;
					case HorizontalAlignment.CENTER:	child.hCenter = 0; 	break;
					case HorizontalAlignment.RIGHT:		child.right = 0; 	break;
				}
				
			}
				
			//trace(r);
			
			return r;
		}
		
	}

}