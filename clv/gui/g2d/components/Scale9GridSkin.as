package clv.gui.g2d.components 
{
	import clv.gui.g2d.core.SkinG2D;
	import zvr.zvrG2D.ZvrG9Grid;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class Scale9GridSkin extends SkinG2D
	{
		
		private var _sprite:ZvrG9Grid;
		
		public function Scale9GridSkin() 
		{
			
		}
		
		override protected function create():void 
		{
			super.create();
			_sprite = _skinNode.addComponent(ZvrG9Grid) as ZvrG9Grid;
		}
		
		override public function updateBounds():void 
		{
			if (positionDirty)
			{
				_sprite.node.transform.x = _component.bounds.x;
				_sprite.node.transform.y = _component.bounds.y;
			}
			if (sizeDirty)
			{
				_sprite.width = _component.bounds.width;
				_sprite.height = _component.bounds.height;
			}
			
		}
		
		public function get sprite():ZvrG9Grid 
		{
			return _sprite;
		}
		
		
		
		
	}

}