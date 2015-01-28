package clv.gameDev.hexMap.tileEditor.ui.lists.edgeLayer 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import clv.gameDev.hexMap.tileEditor.data.EdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.HexEdgeMask;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.gameDev.hexMap.tileEditor.UI;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import zvr.zvrGUI.components.minimalDark.ButtonMD;
	import zvr.zvrGUI.components.minimalDark.LabelMD;
	import zvr.zvrGUI.components.minimalDark.ToggleButtonMD;
	import zvr.zvrGUI.core.IZvrSimpleDataItem;
	import zvr.zvrGUI.core.ZvrAutoSize;
	import zvr.zvrGUI.core.ZvrBitmap;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.layouts.ZvrBitmapAutoSize;
	import zvr.zvrGUI.skins.ZvrStyles;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeListItem extends ZvrGroup implements IZvrSimpleDataItem
	{
		private var _data:EdgeLayer;
		
		private var _name:LabelMD = new LabelMD();
		private var _details:LabelMD = new LabelMD();
		private var icon:ZvrBitmap;
		private var _tileOutput:TileOutput;
		
		private var _visibleButton:ToggleButtonMD;
		private var _select:ButtonMD;
		
		public function EdgeListItem() 
		{
			width = 200;
			height = 50;
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x0C666D, 0.2);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
			addChild(s);
			
			icon = new ZvrBitmap();
			
			icon.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			icon.top = 0;
			icon.width = 50;
			icon.height = 50;
			
			addChild(icon);
			
			_name.labelAutoSize = false;
			_name.width = 100;
			_name.height = 14;
			_name.cutLabel = true;
			_name.multiline = false;
			
			addChild(_name);
			
			_details.labelAutoSize = false;
			_details.width = 100;
			_details.height = 32;
			_details.y = 110;
			_details.multiline = true;
			_details.setStyle(ZvrStyles.LABEL_ALIGN, TextFormatAlign.CENTER);
			addChild(_details);
			
			_visibleButton = new ToggleButtonMD();
			_visibleButton.label.text = "v";
			_visibleButton.autoSize = ZvrAutoSize.MANUAL;
			_visibleButton.width = 15;
			_visibleButton.height = 15;
			_visibleButton.right = 10;
			_visibleButton.top = 10;
			addChild(_visibleButton);
			
			_select = new ButtonMD();
			_select.label.text = "<";
			_select.autoSize = ZvrAutoSize.MANUAL;
			_select.width = 15;
			_select.height = 15;
			_select.right = 10;
			_select.top = 30;
			addChild(_select);
			
			visible = false;
			
			icon.addEventListener(MouseEvent.CLICK, onClick);
			_select.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_data) UI.onSetEdgeLayer.dispatch(_data);
		}
		
		public function get data():EdgeLayer 
		{
			return _data;
		}
		
		public function set data(value:EdgeLayer):void 
		{
			_data = value;
			visible = Boolean(_data);
			
			if (_tileOutput)
			{
				_tileOutput.updated.remove(tileChange);
			}
			if (_data)
			{
				_tileOutput = Project.getTileOutput(_data.tileData);
				tileChange(_tileOutput);
			}
		}
		
		private function tileChange(tileOutput:TileOutput):void 
		{
			if (_data is HexEdgeMask)
			{
				icon.bitmapData = HexEdgeMask(_data).getBitmapData();
			}
			else if (_data is EdgeMask)
			{
				icon.bitmapData = EdgeMask(_data).getBitmapData();
			}
			else
			{
				icon.bitmapData = _data.bitmap.bitmapData;
			}
			
		}
		
	}

}