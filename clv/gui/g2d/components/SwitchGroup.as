package clv.gui.g2d.components 
{
	import clv.gui.components.ToggleList;
	import clv.gui.core.behaviors.ISelectableComponent;
	import clv.gui.core.IComponent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir
	 */
	public class SwitchGroup extends GroupG2D
	{
		
		private var _toggleList:ToggleList = new ToggleList();
		
		public function SwitchGroup() 
		{
			super();
		}
		
		override public function addChild(child:IComponent):void 
		{
			super.addChild(child);
			
			if (child is ISelectableComponent) 
				_toggleList.add(child as ISelectableComponent);
			
		}
		
		override public function removeChild(child:IComponent):void 
		{
			super.removeChild(child);
			
			if (child is ISelectableComponent) 
				_toggleList.remove(child as ISelectableComponent);
		}
		
		public function get onSelectedChange():Signal
		{
			return _toggleList.onSelectedChange;
		}
		
		public function get selected():ISelectableComponent 
		{
			return _toggleList.selected;
		}
	}

}