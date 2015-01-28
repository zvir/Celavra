package clv.gui.core.behaviors 
{
	import clv.gui.core.IComponent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public interface ISelectableComponent extends IComponent
	{
		
		function get data():Object
		function set data(v:Object):void
		
		/*
		 * dispathes component
		 */
		
		function get onSelectChange():Signal
		
		function set selected(v:Boolean):void
		
		function get selected():Boolean
		
	}
	
}