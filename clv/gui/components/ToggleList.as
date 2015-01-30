package clv.gui.components 
{
	import clv.gui.core.behaviors.ISelectableComponent;
	import clv.gui.core.ComponentSignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class ToggleList 
	{
		private var _items:Vector.<ISelectableComponent> = new Vector.<ISelectableComponent>();
		private var _onSelectedChange:Signal = new Signal(ComponentSignal);
		private var _selected:ISelectableComponent;
		
		public var allowNullSelection:Boolean;
		
		public function ToggleList() 
		{
			
		}
		
		public function add(v:ISelectableComponent):void
		{
			v.onSelectChange.add(itemSelectedChange);
			_items.push(v);
		}
		
		public function remove(v:ISelectableComponent):void
		{
			v.onSelectChange.remove(itemSelectedChange);
			_items.splice(_items.indexOf(v) ,1);
		}
		
		private function itemSelectedChange(e:ComponentSignal):void 
		{
			
			if (!ISelectableComponent(e.compoenent).selected && allowNullSelection && e.compoenent == _selected)
			{
				_selected.enable();
				
				_selected = null;
				
				_onSelectedChange.dispatch(e);
				
				return;
			}
			
			if (ISelectableComponent(e.compoenent).selected)
			{
				
				for (var i:int = 0; i < _items.length; i++) 
				{
					if (_items[i] != e.compoenent) 
					{
						_items[i].selected = false;
						_items[i].enable();
					}
				}
				
				_selected = e.compoenent as ISelectableComponent;
				
				if (!allowNullSelection) _selected.disable();
				
				_onSelectedChange.dispatch(e);
				
			}
			
		}
		
		public function get onSelectedChange():Signal 
		{
			return _onSelectedChange;
		}
		
		public function get selected():ISelectableComponent 
		{
			return _selected;
		}
		
		
	}

}