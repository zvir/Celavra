package clv.gui.g2d.core 
{
	import clv.gui.core.display.ISkinBody;
	import clv.gui.core.skins.Skin;
	import clv.gui.core.skins.SkinContainer;
	import clv.gui.g2d.display.G2DGuiBody;
	import com.genome2d.node.factory.GNodeFactory;
	import com.genome2d.node.GNode;
	import flash.display.Stage;
	import flash.events.SoftKeyboardEvent;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class SkinAppG2D extends SkinContainer
	{
		private var _containerNode:GNode;
		private var _softKeyboard:Boolean;
		
		
		public function SkinAppG2D() 
		{
			
		}
		
		override protected function create():void 
		{
			
			_cointainerBody = GNodeFactory.createNodeWithComponent(G2DGuiBody) as G2DGuiBody;
			_componentBody = _cointainerBody;
			
			_childrenBody = GNodeFactory.createNodeWithComponent(G2DGuiBody) as G2DGuiBody;
			_cointainerBody.addElement(_childrenBody);
			
			_containerNode = G2DGuiBody(_componentBody).node
			
			_containerNode.onAddedToStage.addOnce(addedToStage);
		}
		
		private function addedToStage():void 
		{
			_containerNode.onRemovedFromStage.addOnce(removedFromStage);
			_containerNode.core.onPreRender.add(updateApp);
			
			var stage:Stage = _containerNode.core.getContext().getNativeStage();
			
			stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, softKeyActivate);
			stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyDeactivate);
			
		}
		
		private function softKeyActivate(e:SoftKeyboardEvent):void 
		{
			_softKeyboard = true;
			tr("soft on");
		}
		
		private function softKeyDeactivate(e:SoftKeyboardEvent):void 
		{
			_softKeyboard = false;
			tr("soft off");
		}
		
		private function updateApp():void 
		{
			var stage:Stage = _containerNode.core.getContext().getNativeStage();
			
			var keyH:Number = _softKeyboard ? stage.softKeyboardRect.height : 0;
			
			AppG2D(_component).updateApp(0, 0, stage.stageWidth, stage.stageHeight - keyH); 
		}
		
		private function removedFromStage():void 
		{
			_containerNode.onAddedToStage.addOnce(addedToStage);
			_containerNode.core.onPreRender.remove(updateApp);
		}
		
		override public function updateBounds():void 
		{
			super.updateBounds();
			
			_componentBody.x = _component.bounds.x;
			_componentBody.y = _component.bounds.y;
		}
		
		public function get containerNode():GNode 
		{
			return _containerNode;
		}
		
	}

}