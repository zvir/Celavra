package clv.gui.components.dataList 
{
	import clv.gui.core.Component;
	import clv.gui.g2d.components.GroupG2D;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ListItemHorizontal
	{
		private var _next:IDataListItem;
		private var _prev:IDataListItem;
		private var _component:Component;
		
		public var gap:Number = 0;
		
		public function ListItemHorizontal(component:Component) 
		{
			_component = component;
		}
		
		public function setItemAfterPosition(listPostition:Number, itemPosition:int):Boolean
		{
			if (prev) 
			{
				_component.x = prev.independentBounds.R + gap;
			}
			else 
			{
				_component.x = -(_component.width + gap) * (listPostition - Math.floor(listPostition));
			}
			
			return _component.independentBounds.R + gap < _component.container.contentAreaWidth;
		}
		
		public function setItemBeforePosition(position:Number, itemPosition:int):Boolean 
		{
			
			if (next) 
			{
				_component.x = next.x - _component.independentBounds.w - gap;
			}
			
			return _component.independentBounds.L > -_component.container.contentAreaWidth;
		}
		
		public function getPercentScrol(v:Number):Number 
		{
			var p:Number = v / (_component.independentBounds.w + gap);
			
			if (Math.abs(p) > 1)
			{
				if (p > 0 &&  next) p = next.getPercentScrol(v - (_component.independentBounds.w + gap)) + 1;
				if (p < 0 &&  prev) 
				{
					p = prev.getPercentScrol(v + (_component.independentBounds.w + gap)) - 1;
				}
			}
			
			return p;
		}
		
		public function getEnd():Number 
		{
			return _component.container.contentAreaWidth - _component.independentBounds.R - gap;
		}
		
		public function getEndIndex(max:int):Number 
		{
			var w:Number = _component.independentBounds.w + gap;
			
			var numberOfItemsInContainer:Number = (_component.container.contentAreaWidth - gap) / w; 
			
			return max - numberOfItemsInContainer;
		}
		
		public function getNumOfPositions():Number 
		{
			return (_component.container.contentAreaWidth - gap) / (_component.independentBounds.w + gap); 
		}
		
		public function get next():IDataListItem 
		{
			return _next;
		}
		
		public function set next(value:IDataListItem):void 
		{
			_next = value;
		}
		
		public function get prev():IDataListItem 
		{
			return _prev;
		}
		
		public function set prev(value:IDataListItem):void 
		{
			_prev = value;
		}
		
	}

}