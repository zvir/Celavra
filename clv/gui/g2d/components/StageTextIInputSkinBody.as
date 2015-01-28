package clv.gui.g2d.components 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.IRenderable;
	import com.genome2d.context.GContextCamera;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	/**
	 * ...
	 * @author Zvir
	 */
	public class StageTextIInputSkinBody extends GComponent implements IRenderable
	{
		private var stageTextInitOptions:StageTextInitOptions;
		private var bg:Sprite;
		public var text:StageText;
		public var width:Number = 1;
		public var height:Number = 1;
		
		public function StageTextIInputSkinBody() 
		{
			stageTextInitOptions = new StageTextInitOptions(false);
			text = new StageText(stageTextInitOptions);
			text.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, softKeyActivate);
			text.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, softKeyActivating);
			text.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyDeactivate);
			text.softKeyboardType = SoftKeyboardType.DEFAULT;
			text.returnKeyLabel = ReturnKeyLabel.DONE;
			text.autoCorrect = true;
			text.fontSize = 40;
			text.color = 0x440000;
			//text.fontWeight = "bold";
			text.viewPort = new Rectangle(0, 0, 1, 1);
			
			text.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			text.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			/*
			stageText.stage = stage;
			stageText.assignFocus();
			trace(stage.focus);*/
		}
		
		private function focusIn(e:FocusEvent):void 
		{
			
			tr("focus in");
			
			var stage:Stage = node.core.getContext().getNativeStage();
			
			if (!bg)
			{
				bg = new Sprite();	
				//bg.buttonMode = true
			}
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x0DFB00, 0.0);
			bg.graphics.drawRect(0, 0, 100, 100);
			bg.graphics.endFill();
			
			bg.addEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);
			bg.addEventListener(TouchEvent.TOUCH_BEGIN, bgMouseDown);
			stage.addChildAt(bg, stage.numChildren-1);
			
		}
		
		private function bgMouseDown(e:Event):void 
		{
			bg.stage.focus = null;
		}
		
		private function focusOut(e:FocusEvent):void 
		{
			
			tr("focus out");
			
			if (node) 
			{
				node.core.getContext().getNativeStage().focus = null;
				node.core.getContext().getNativeStage().dispatchEvent(new SoftKeyboardEvent(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, false, false, null, null));
			}
			
			removeBG();
			
			
		}
		
		private function removeBG():void 
		{
			bg.removeEventListener(MouseEvent.MOUSE_DOWN, bgMouseDown);
			bg.removeEventListener(TouchEvent.TOUCH_BEGIN, bgMouseDown);
			if (bg.stage) bg.stage.removeChild(bg);
		}
		
		private function softKeyDeactivate(e:SoftKeyboardEvent):void 
		{
			if (node) node.core.getContext().getNativeStage().dispatchEvent(e);
		}
		
		private function softKeyActivating(e:SoftKeyboardEvent):void 
		{
			if (node) node.core.getContext().getNativeStage().dispatchEvent(e);
		}
		
		private function softKeyActivate(e:SoftKeyboardEvent):void 
		{
			if (node) node.core.getContext().getNativeStage().dispatchEvent(e);
		}
		
		override public function init():void 
		{
			super.init();
			
			/*node.onAddedToStage.add(onAddedToStage);
			node.onRemovedFromStage.add(onRemovedFromStage);*/
		}
		
	/*	private function onRemovedFromStage():void 
		{
			text.stage = null;
			removeBG();
		}*/
		
		/*private function onAddedToStage():void 
		{
			text.stage = node.core.getContext().getNativeStage();
		}*/
		
		/* INTERFACE com.genome2d.components.renderables.IRenderable */
		
		public function render(p_camera:GContextCamera, p_useMatrix:Boolean):void 
		{
			if (!node.transform.visible) return;
			
			text.viewPort = new Rectangle(node.transform.g2d_worldX, node.transform.g2d_worldY, width, height);
			
			var stage:Stage = node.core.getContext().getNativeStage();
			
			if (bg && bg.stage)
			{
				bg.width = stage.stageWidth;
				bg.height = stage.stageHeight;
			}
		}
		
		public function getBounds(p_target:Rectangle = null):Rectangle 
		{
			
			if (!p_target) p_target = new Rectangle();
			
			p_target.x = node.transform.g2d_worldX
			p_target.y = node.transform.g2d_worldY
			p_target.width = width;
			p_target.height = height;
			
			return p_target;
		}
		
	}

}