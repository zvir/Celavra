package clv.gui.g2d.components 
{
	import com.genome2d.node.GNode;
	import com.genome2d.signals.GNodeMouseSignal;
	import org.osflash.signals.Signal;
	import zvr.zvrG2D.ZvrG2DMouseRectComponent;
	import zvr.zvrKeyboard.ZvrKeyboard;
	import zvr.zvrLocalization.IZvrLocEditLabel;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LabelLocG2D extends LabelG2D implements IZvrLocEditLabel
	{
		private var _onEdit:Signal;
		private var _mouseRect:ZvrG2DMouseRectComponent;
		
		public function LabelLocG2D() 
		{
			super();
		}
		
		public function setLoc(s:String, values:Array = null):void
		{
			Loc.setZL(this, s, values);
		}
		
		override protected function resized():void 
		{
			super.resized();
			
			if (_mouseRect)
			{
				_mouseRect.rect.width = bounds.width;
				_mouseRect.rect.height = bounds.height;
			}
		}
		
		public function get onEdit():Signal 
		{
			
			if (!_onEdit)
			{
				if (!_mouseRect)
				{
					CONFIG::debug
					{
						
						_mouseRect = GNode(body.displayBody).addComponent(ZvrG2DMouseRectComponent) as ZvrG2DMouseRectComponent;
						_mouseRect.rect.width = bounds.width;
						_mouseRect.rect.height = bounds.height;
						GNode(body.displayBody).onMouseDown.add(mouseDown);
						GNode(body.displayBody).mouseEnabled = true;
						//throw new Error("TR");
					}
				}
				
				_onEdit = new Signal(IZvrLocEditLabel);
				
			}
			
			return _onEdit;
		}
		
		private function mouseDown(e:GNodeMouseSignal):void 
		{
			if (ZvrKeyboard.CTRL.pressed) _onEdit.dispatch(this);
		}
	}

}