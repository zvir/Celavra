package clv.gui.core.layouts 
{
	import clv.gui.core.IComponent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LineLayout extends Layout
	{
		
		private var _verticalAlign		:String = VerticalAlignment.TOP;
		
		private var _horizontalAlign		:String = HorizontalAlignment.LEFT;
		
		private var _alignment			:String = Alignment.HORIZONTAL;
		
		private var _gap					:Number = 4;
		
		private var _lastPos		:Number = 0.0;
		private var _childrenSize	:Number = 0;;
		private var _childrenOffset	:Number;
		
		
		public function LineLayout() 
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
				for (var i:int = 0; i < children.length; i++) 
				{
					_childrenSize += children[i].layoutBounds.W + gap;
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
				for (i = 0; i < children.length; i++) 
				{
					_childrenSize += children[i].layoutBounds.H + gap;
				}
				
				_childrenSize -= gap;
				
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
				r = new Rectangle(_lastPos + _childrenOffset, 0, child.layoutBounds.W, h);
				
				_lastPos += child.layoutBounds.W + gap;
				
				switch (verticalAlign) 
				{
					case VerticalAlignment.BOTTOM:	child.bottom = 0; 	break;
					case VerticalAlignment.MIDDLE:	child.vCenter = 0; 	break;
					case VerticalAlignment.TOP:		child.top = 0; 		break;
				}
				
				
			
			}
			else if (alignment == Alignment.VERTICAL)
			{
				r =  new Rectangle(0, _lastPos + _childrenOffset, w, child.layoutBounds.H);
				
				_lastPos += child.layoutBounds.H + gap;
				
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
		
		public function get verticalAlign():String 
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void 
		{
			_verticalAlign = value;
			onChange.dispatch();
		}
		
		public function get horizontalAlign():String 
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void 
		{
			_horizontalAlign = value;
			onChange.dispatch();
		}
		
		public function get alignment():String 
		{
			return _alignment;
		}
		
		public function set alignment(value:String):void 
		{
			_alignment = value;
			onChange.dispatch();
		}
		
		public function get gap():Number 
		{
			return _gap;
		}
		
		public function set gap(value:Number):void 
		{
			_gap = value;
			onChange.dispatch();
		}
		
	}

}