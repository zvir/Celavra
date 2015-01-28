package clv.genome2d.components 
{
	import clv.gui.common.styles.TextStyle;
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.IRenderable;
	import com.genome2d.context.GContextCamera;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir
	 */
	public class StageTextComponent extends GComponent
	{
		private var stage:Stage;
		
		public var stageText:StageText;
		public var stageTextInitOptions:StageTextInitOptions;
		
		public var width:Number;
		public var height:Number;
		
		public var complete:Signal = new Signal();
		
		public function StageTextComponent() 
		{
			
		}
		
		public function begin(multiline:Boolean=false):void
		{
			if (!node.core.getContext().getNativeStage()) return;
			
			stage = node.core.getContext().getNativeStage();
			
			node.core.onPostRender.add(render);
			
			if (!stageText)
			{
				stageTextInitOptions = new StageTextInitOptions(multiline);
				stageText = new StageText(stageTextInitOptions);
				stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, softKeyActivate);
				stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, softKeyActivating);
				stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyDeactivate);
				stageText.softKeyboardType = SoftKeyboardType.DEFAULT;
				stageText.returnKeyLabel = ReturnKeyLabel.DONE;
				stageText.autoCorrect = true;
				stageText.fontSize = 40;
				stageText.color = 0x440000;
				stageText.fontWeight = "bold";
				stageText.viewPort = new Rectangle(10, 50, stage.stageWidth - 20, 70);
				stageText.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			}
			
			stageText.stage = stage;
			stageText.assignFocus();
			trace(stage.focus);
		}
		
		private function softKeyDeactivate(e:SoftKeyboardEvent):void 
		{
			tr("softKeyDeactivate");
			stage.dispatchEvent(e);
		}
		
		private function softKeyActivating(e:SoftKeyboardEvent):void 
		{
			tr("softKeyActivating");
			stage.dispatchEvent(e);
		}
		
		private function softKeyActivate(e:SoftKeyboardEvent):void 
		{
			tr("softKeyActivate");
			stage.dispatchEvent(e);
		}
		
		private function focusOut(e:FocusEvent):void 
		{
			complete.dispatch();
		}
		
		/* INTERFACE com.genome2d.components.renderables.IRenderable */
		
		public function render():void 
		{
			
			if (!node) return;
			
			if (stageText) stageText.viewPort = new Rectangle(node.transform.g2d_worldX, node.transform.g2d_worldY, width, height);
			
		}
		
		public function getBounds(p_target:Rectangle = null):Rectangle 
		{
			return null;
		}
		
		public function setSize(w:Number, h:Number):void 
		{
			width = w;
			height = h;
		}
		
		public function end():void 
		{
			stageText.stage.focus = null;
			stageText.stage = null;
			
			node.core.onPostRender.remove(render);
			
		}
		
		
		
	}

}