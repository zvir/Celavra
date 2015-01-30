package clv.gui.core 
{
	import _Map.Map_Impl_;
	import clv.gui.core.display.IContainerBody;
	import clv.gui.core.display.IContainerMask;
	import clv.gui.core.layouts.ContentPadding;
	import clv.gui.core.layouts.Layout;
	import clv.gui.core.layouts.LineLayout;
	import clv.gui.core.skins.ISkin;
	import clv.gui.core.skins.Skin;
	import clv.gui.core.skins.SkinContainer;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir
	 */
	public class Container extends Component implements ICointainer
	{
		
		/* TO DO:
		
		move all display bodies to skins, and manage displays thro skins
			
		*/
		
		// elements
		protected var _children			:Vector.<IComponent> = new Vector.<IComponent>;
		protected var _presentElements	:Vector.<IComponent> = new Vector.<IComponent>;
		
		// contents
		private var _contentns			:ICointainer;
		private var _elements			:ICointainer;
		
		private var _childrenBody		:IContainerBody;
		
		// Layout
		private var _layout				:Layout;
		
		private var _contentWidth		:Number = 0;
		private var _contentHeight		:Number = 0;

		private var _contentX			:Number = 0;
		private var _contentY			:Number = 0;
		
		private var _contentAreaWidth	:Number = 0;
		private var _contentAreaHeight	:Number = 0;
		
		private var _contentIndependentRight	:Number = 0;
		private var _contentIndependentBottom	:Number = 0;
		
		private var _contentMaxIndependentWidth	:Number = 0;
		private var _contentMaxIndependentHeight:Number = 0;
		
		private var _contentPadding		:ContentPadding;
		
		//private var _contentRect		:Rectangle = new Rectangle();
		
		//private var _estimatedCoitainerRect:Rectangle = new Rectangle();
		
		private var _size				:int = Size.MANUAL;
		
		internal var childrenDirty		:Boolean;
		
		// Masking
		private var _maskingEnabled		:Boolean = false;
		
		// Signals
		private var _onChildAdded				:Signal = new Signal(CointanerSignal);
		private var _onChildRemoved				:Signal = new Signal(CointanerSignal);
		private var _onContentPositionChange	:Signal = new Signal(CointanerSignal);
		private var _onContentSizeChange		:Signal = new Signal(CointanerSignal);
		
		private var _skin				:SkinContainer;
		
		public function Container(skin:SkinContainer) 
		{
			super(skin);
			
			_contentns = this;
			_elements = this;
			
			_contentPadding = new ContentPadding(contentPaddingSetter);
		}
		
		
		override public function prepareForUpdate(scale:Number):void 
		{
			
			super.prepareForUpdate(scale);
			
			var i:int;
			var child:IComponent;
			
			if (!transformDirty && !childrenDirty && scale == _scale)
			{
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					child.prepareForUpdate(scale);
				}
				return;
			}
			
			_presentElements.length = 0;
			
			_contentIndependentRight	= 0;
			_contentIndependentBottom	= 0;
			
			_contentMaxIndependentWidth	 = 0;
			_contentMaxIndependentHeight = 0;
			
			var childRight	:Number;
			var childBottom :Number;
			var childWidth  :Number;
			var childHeight :Number;
			
			for (i = 0; i < _children.length; i++) 
			{
				child = _children[i];
				
				if (child.present) 
				{
					_presentElements.push(child);
					
					child.prepareForUpdate(scale);
					
					childRight	= child.layoutBounds.R;
					childBottom = child.layoutBounds.B;
					childWidth  = child.layoutBounds.W;
					childHeight = child.layoutBounds.H;
					
					
					if (childRight > _contentIndependentRight) 	_contentIndependentRight = childRight;
					if (childBottom > _contentIndependentBottom) _contentIndependentBottom = childBottom;
					if (childWidth > _contentMaxIndependentWidth) _contentMaxIndependentWidth = childWidth;
					if (childHeight > _contentMaxIndependentHeight) _contentMaxIndependentHeight = childHeight;
				}
			}
		}
		
		override public function update(cell:Rectangle, scale:Number):void 
		{
			
			if (!childrenDirty && !_transformDirty && (!cell || (cell && _cell.equals(cell))) && (!_scaleble || (_scaleble && _scale == scale)))
			{
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					child.update(null, scale);
				}
				
				updateSkin();
				postUpdate();
				_onPostUpdate.dispatch(_componentSignal);
				return;
			}
			
			updateLayout(cell, scale);
			
			var autoSizeWidth	:Boolean = _size == Size.AUTO || _size == Size.WIDTH;
			var autoSizeHeight	:Boolean = _size == Size.AUTO || _size == Size.HEIGHT;
				
			
			var cpr:Number = _contentPadding.right * scale;
			var cpl:Number = _contentPadding.left * scale;
			var cpt:Number = _contentPadding.top * scale;
			var cpb:Number = _contentPadding.bottom * scale;
			
			
			var contentWidth:Number = autoSizeWidth ? NaN : bounds.width - cpr - cpl;
			var contentHeight:Number = autoSizeHeight ? NaN : bounds.height - cpt - cpb;
			
			var contentAreaWidth:Number = bounds.width - cpr - cpl;
			var contentAreaHeight:Number = bounds.height - cpt - cpb;
			
			if (!autoSizeWidth && !autoSizeHeight)
			{
				if (contentAreaHeight != _contentAreaHeight || contentAreaWidth != _contentAreaWidth)
				{
					_contentAreaHeight = contentAreaHeight;
					_contentAreaWidth = contentAreaWidth;
					reportResizedContainer();
				}
			}
			
			var childRight	: Number;
			var childBottom	: Number;
			
			var childCell:Rectangle;
			
			var i:int;
			var child:IComponent;
			
			if (_layout)
			{
				_layout.begin(contentWidth, contentHeight, _contentIndependentRight, _contentIndependentBottom, _contentMaxIndependentWidth, _contentMaxIndependentHeight, _presentElements);
				
				contentWidth = 0;
				contentHeight = 0;
				
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					childCell = _layout.layout(child);
					child.update(childCell, scale);
					
					childRight	= child.bounds.right;
					childBottom	= child.bounds.bottom;
					
					if (childRight > contentWidth) contentWidth = childRight;
					if (childBottom > contentHeight) contentHeight = childBottom;
					
				}
			}
			else
			{
				contentWidth = 0;
				contentHeight = 0;
				
				childCell = new Rectangle(
					0, 
					0, 
					autoSizeWidth ? _contentIndependentRight : bounds.width - cpl - cpr, 
					autoSizeHeight ? _contentIndependentBottom : bounds.height - cpt - cpb
				);
				
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					
					child.update(childCell, scale);
					
					childRight = autoSizeWidth ? child.layoutBounds.W: child.bounds.right + child.right;
					childBottom = autoSizeHeight ? child.layoutBounds.H : child.bounds.bottom  + child.bottom;
					
					if (childRight > contentWidth) contentWidth = childRight;
					if (childBottom > contentHeight) contentHeight = childBottom;
					
				}
			}
			
			// UPDATE CONTENT SIZE
			
			if (contentWidth != _contentWidth || contentHeight != _contentHeight)
			{
				_contentWidth = contentWidth;
				_contentHeight = contentHeight;
				_onContentSizeChange.dispatch(new CointanerSignal(this));
			}
			
			// AUTO SIZE TO CONTENT
			
			if (autoSizeWidth) 	width = (_contentWidth + cpl + cpr) / scale;
			if (autoSizeHeight) height = (_contentHeight + cpt + cpb) / scale;
			
			if (autoSizeWidth || autoSizeHeight) 
			{
				updateLayout(cell, scale);
			}
			
			if (autoSizeWidth || autoSizeHeight)
			{
				if (contentAreaHeight != _contentAreaHeight || contentAreaWidth != _contentAreaWidth)
				{
					
					_contentAreaHeight = contentAreaHeight;
					_contentAreaWidth = contentAreaWidth;
					
					reportResizedContainer();
				}
			}
			updateChildrenPosition();
			updateMask();
			updateSkin();
			
			postUpdate();
			_onPostUpdate.dispatch(_componentSignal);
			
			childrenDirty = false;
		}
		
		private function updateMask():void 
		{
			if (_maskingEnabled)
			{
				var cpl:Number = _contentPadding.left * _scale;
				var cpt:Number = _contentPadding.top * _scale;
				
				_skin.setMaskRect(cpl, cpt, _contentAreaWidth, _contentAreaHeight);
			}
		}
		
		override internal function reportResized():void 
		{
			
		}
		
		private function reportResizedContainer():void
		{
			super.reportResized();
		}
		
		public function addChild(child:IComponent):void
		{
			_children.push(child as Component);
			
			child.added(this);
			
			childrenDirty = true;
			
			_contentns.childrenBody.addElement(child.body);
			
			_onChildAdded.dispatch(new CointanerSignal(this, child));
		}
		
		public function removeChild(child:IComponent):void
		{
			var i:int = getChildIndex(child as Component);
			
			if (i == -1) 
			{
				trace("Error:: not a child");
				return;
			}
			
			childrenDirty = true;
			
			_children.splice(i, 1);
			
			i = _presentElements.indexOf(child);
			if (i != -1)
				_presentElements.splice(i, 1);
			
			child.removed(this);
				
			_contentns.childrenBody.removeElement(child.body);
				
			_onChildAdded.dispatch(new CointanerSignal(this, child));
		}
		
		override internal function setApp(v:Application):void 
		{
			super.setApp(v);
			
			for (var i:int = 0; i < _children.length; i++) 
			{
				if (_children[i] is Component) Component(_children[i]).setApp(_app);
			}
			
		}
		
		public function getChildIndex(child:IComponent):int 
		{
			return _children.indexOf(child);
		}
		
		public function getNumChildren():int
		{
			return _children.length;
		}
		
		public function getChildAt(index:int):Component
		{
			return _children[index] as Component;
		}
		
		public function setChildIndex(child:IComponent, index:int):void
		{
			var i:int = getChildIndex(child);
			
			_contentns.childrenBody.setElementIndex(child.body, index);
			
			_children.splice(i, 1);
			_children.splice(index, 0, child);
			
			childrenDirty = true;
		}
		
		public function set maskingEnabled(value:Boolean):void 
		{
			if (_maskingEnabled == value) return;
			_maskingEnabled = value;
			_skin.maskEnabled = value;
			updateMask();
		}
		
		public function get contentns():ICointainer 
		{
			return _contentns;
		}
		
		public function get elements():ICointainer 
		{
			return _elements;
		}
		
		public function set elements(value:ICointainer):void 
		{
			_elements = value;
		}
		
		public function set contentns(value:ICointainer):void 
		{
			_contentns = value;
		}
		
		private function updateChildrenPosition():void
		{
			var cpl:Number = _contentPadding.left * _scale;
			var cpt:Number = _contentPadding.top * _scale;
			
			_skin.setChildrenPosition(_contentX * _scale + cpl, _contentY * _scale + cpt);	
		}
		
		public function setContentsPosition(x:Number, y:Number):void
		{
			x = x / _scale;
			y = y / _scale;
			
			if (x == _contentX  && y == _contentY)
				return;
			
			_contentX = x;
			_contentY = y;
				
			updateChildrenPosition();
			
			_onContentPositionChange.dispatch(new CointanerSignal(this));
		}
		
		public function set layout(layout:Layout):void 
		{
			if (_layout)
			{
				_layout.onChange.remove(onLayoutChange);
			}
			
			_layout = layout;
			
			if (_layout)
			{
				_layout.onChange.add(onLayoutChange);
			}
			
			childrenDirty = true;
		}
		
		private function onLayoutChange():void 
		{
			childrenDirty = true;
		}
		
		public function get layout():Layout 
		{
			return _layout;
		}
		
		private function contentPaddingSetter(top:Number, left:Number, right:Number, bottom:Number):void 
		{
			if (top != 0 || left != 0) 
			{
				updateChildrenPosition();
				
				_onContentPositionChange.dispatch(new CointanerSignal(this));
				
				
				//updateContainer();
				
			} 
			else if (right != 0 || bottom != 0)
			{
				//updateContainer();
				
			}
			
			childrenDirty = true;
			
		}
		
		override public function get skin():ISkin 
		{
			return super.skin;
		}
		
		override public function set skin(value:ISkin):void 
		{
			if (!(value is SkinContainer))
			{
				throw new Error("Cointainer must have skin of SkinCointainer type");
			}
			
			_skin = value as SkinContainer;
			
			super.skin = value;
		}
		
		public function get childrenBody():IContainerBody 
		{
			return _skin.childrenBody;
		}
		
		public function get onContentSizeChange():Signal 
		{
			return _onContentSizeChange;
		}
		
		public function get onContentPositionChange():Signal 
		{
			return _onContentPositionChange;
		}
		
		public function get onChildRemoved():Signal 
		{
			return _onChildRemoved;
		}
		
		public function get onChildAdded():Signal 
		{
			return _onChildAdded;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
			_transformDirty = true;
			//_independentDirty = true;
			if (_container) _container.childrenDirty = true;
		}
		
		public function get contentPadding():ContentPadding 
		{
			return _contentPadding;
		}
		
		public function get contentAreaWidth():Number 
		{
			return _contentAreaWidth;
		}
		
		public function get contentAreaHeight():Number 
		{
			return _contentAreaHeight;
		}
		
		public function get contentWidth():Number 
		{
			return _contentWidth;
		}
		
		public function get contentHeight():Number 
		{
			return _contentHeight;
		}
		
		public function get contentX():Number 
		{
			return _contentX * _scale;
		}
		
		public function get contentY():Number 
		{
			return _contentY * _scale;
		}
		
		/*
		override public function update(cell:Rectangle):void 
		{
			_presentElements.length = 0;
			
			if (!transformDirty && !childrenDirty && cell.width == _hD.L && cell.height == _vD.L) 
			{
				return;
			}
			
			if (_app) _app.updates++;
			
			super.updateLayout(cell);
			
			var childCell:Rectangle = bounds.clone();
			
			for (i = 0; i < _children.length; i++) 
			{
				var child:Component = _children[i];
				if (child.present) _presentElements.push(child);
			}
			
			if (_size != Size.MANUAL)
			{
				var autoSizeWidth	:Boolean = _size == Size.AUTO || _size == Size.WIDTH;
				var autoSizeHeight	:Boolean = _size == Size.AUTO || _size == Size.HEIGHT;
				
				var autoWidth	: Number = 0;
				var autoHeight	: Number = 0;
				
				var childRight	: Number;
				var childBottom	: Number;
				
				for (var i:int = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					
					childRight = child.independentBounds.W;
					childBottom =  child.independentBounds.H;
					
					if (childRight > autoWidth) autoWidth = childRight;
					if (childBottom > autoHeight) autoHeight = childBottom;
					
				}
				
				var contentWidth:Number = autoSizeWidth ? autoWidth : bounds.width - _contentPadding.right - _contentPadding.left;
				var contentHeight:Number = autoSizeHeight ? autoHeight : bounds.height - _contentPadding.top - _contentPadding.bottom;
			}
			else
			{
				contentWidth = bounds.width - _contentPadding.right - _contentPadding.left;
				contentHeight = bounds.height - _contentPadding.top - _contentPadding.bottom;
			}
			
			_contentAreaWidth = bounds.width - _contentPadding.right - _contentPadding.left;
			_contentAreaHeight = bounds.height - _contentPadding.top - _contentPadding.bottom;
			
			if (_layout) _layout.begin(contentWidth, contentHeight, _contentAreaWidth, _contentAreaHeight, _presentElements);

			contentWidth = 0;
			contentHeight = 0;
			
			if (_layout)
			{
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					childCell = _layout.layout(child);
					child.update(childCell);
					
					childRight	= child.bounds.right;
					childBottom	= child.bounds.bottom;
					
					if (childRight > contentWidth) contentWidth = childRight;
					if (childBottom > contentHeight) contentHeight = childBottom;
					
				}
			}
			else
			{
				
				childCell = new Rectangle(0, 0, autoSizeWidth ? autoWidth : _contentAreaWidth, autoSizeHeight ? autoHeight : _contentAreaHeight);
				
				for (i = 0; i < _presentElements.length; i++) 
				{
					child = _presentElements[i];
					
					child.update(childCell);
					
					childRight = autoSizeWidth ? child.independentBounds.W: child.bounds.right + child.right;
					childBottom = autoSizeHeight ? child.independentBounds.H : child.bounds.bottom  + child.bottom;
					
					if (childRight > contentWidth) contentWidth = childRight;
					if (childBottom > contentHeight) contentHeight = childBottom;
					
				}
			}
			
			if (_layout) _layout.end();
			
			if (contentWidth != _contentWidth || contentHeight != _contentHeight)
			{
				_contentWidth = contentWidth;
				_contentHeight = contentHeight;
				_onContentSizeChange.dispatch(new CointanerSignal(this));
			}
			
			// AUTO SIZE TO CONTENT
			
			if (autoSizeWidth) 	width = _contentWidth + _contentPadding.left + _contentPadding.right;
			if (autoSizeHeight) height = _contentHeight + _contentPadding.top + _contentPadding.bottom;
			if (autoSizeWidth || autoSizeHeight) super.updateLayout(cell);
			
			super.updateSkin();
			
			childrenDirty = false;
		}
		
		*/
	}

}