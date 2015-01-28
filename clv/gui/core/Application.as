package clv.gui.core 
{
	import clv.gui.core.skins.Skin;
	import clv.gui.core.skins.SkinContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author ...
	 */
	public class Application extends Container
	{
		
		public var updates:int;
		
		public var pointer:PointerManager = new PointerManager();
		
		public var pixelSharp:Boolean = true;
		
		public var stage:Stage;
		
		// used to scale up interface (form lager dpi)
		private var _appScale:Number = 1;
		
		
		public function Application(skin:SkinContainer) 
		{
			super(skin);
			
			pointer = new PointerManager();
			
			_app = this;
		}
		
		public function updateApp(x:Number, y:Number, width:Number, height:Number):void
		{
			
			width = width;
			height = height;
			x = x;
			y = y;
			
			updates = 0;
			
			if (pixelSharp)
			{
				width = Math.floor(width / 2) * 2;
				height = Math.floor(height / 2) * 2;
			}
			
			if (x != this.x) this.x = x;
			if (y != this.y) this.y = y;
			
			
			if (width != this.width) this.width = width;
			if (height != this.height) this.height = height;
			
			prepareForUpdate(_appScale);
			
			update(new Rectangle(0, 0, width, height), _appScale);
			
			//trace(updates);
			
		}
		
		override protected function updateAppScale(scale:Number):void 
		{
			
		}
		
		public function checkOver():Boolean 
		{
			if (pointer.touch && !pointer.down) return false;
			
			var x:Number = pointer.x / _scale + bounds.x ;
			var y:Number = pointer.y / _scale + bounds.y ;
			
			
			
			var r:Rectangle = new Rectangle();
			
			for (var i:int = 0; i < _presentElements.length; i++) 
			{
				
				var e:IComponent = _presentElements[i];
				
				if (e.bounds.contains(x, y)) return true;
			}
			
			return false;
			
		}
		
		public function get scale():Number 
		{
			return _appScale;
		}
		
		public function set scale(value:Number):void 
		{
			if (_appScale == value) return;
			
			_appScale = value;
		}
		
	}

}