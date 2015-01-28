package clv.gui.core.skins 
{
	import clv.gui.core.Component;
	
	/**
	 * ...
	 * @author Zvir
	 */
	public interface ISkinBase 
	{
		
		function addToComponent(component:Component):void;
		
		function removeFromComponent(component:Component):void;
		
		function preUpdate():void;
		
		function update():void;
		
		function updateBounds():void;
		
		function setStyle(styleName:String, value:*, state:* = null):Boolean;
		
		function getStyle(styleName:String):*;
		
		function set sizeDirty(value:Boolean):void;
		
		function get sizeDirty():Boolean;
		
		function set positionDirty(value:Boolean):void;
		
		function get positionDirty():Boolean;
	}
	
}