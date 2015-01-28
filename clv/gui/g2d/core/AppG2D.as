package clv.gui.g2d.core 
{
	import clv.gui.core.Application;
	import clv.gui.g2d.display.G2DGuiBody;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.node.GNode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class AppG2D extends Application
	{
		
		//private var _cell:Rectangle = new Rectangle();
		
		
		public function AppG2D() 
		{
			super(new SkinAppG2D());
		}
		
		override public function updateApp(x:Number, y:Number, width:Number, height:Number):void 
		{
			super.updateApp(x, y, width, height);
		}
		
		override public function update(cell:Rectangle, scale:Number):void 
		{
			super.update(_cell, scale);
			
			GStats.customStats = ["GUI: "+updates];
		}
		
		public function get node():GNode 
		{
			return G2DGuiBody(body).node;
		}
		
		/*override public function set scale(value:Number):void 
		{
			super.scale = value;
			
			//node.transform.setScale(value, value);
		}*/
	}

}