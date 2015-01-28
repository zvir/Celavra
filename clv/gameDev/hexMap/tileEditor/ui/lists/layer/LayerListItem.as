package clv.gameDev.hexMap.tileEditor.ui.lists.layer 
{
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.outputs.HexEdge;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.gameDev.hexMap.tileEditor.UI;
	import flash.display.BitmapData;
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
	public class LayerListItem extends ZvrGroup implements IZvrSimpleDataItem
	{
		private var _data:LayerData;
		
		private var _name:LabelMD = new LabelMD();
		private var _details:LabelMD = new LabelMD();
		private var icon:ZvrBitmap;
		private var mask:ZvrBitmap;
		
		private var _visibleButton:ToggleButtonMD;
		private var _select:ButtonMD;
		private var _tileOutput:TileOutput;
		
		public function LayerListItem() 
		{
			width = 200;
			height = 100;
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x0C666D, 0.2);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
			addChild(s);
			
			icon = new ZvrBitmap();
			
			icon.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			icon.top = 10;
			icon.left = 10;
			icon.width = 80;
			icon.height = 80;
			
			addChild(icon);
			
			mask = new ZvrBitmap();
			mask.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			mask.top = 10;
			mask.left = 90;
			mask.width = 80;
			mask.height = 80;
			
			addChild(mask);
			
			
			/*_delete.childrenPadding.padding = 0;
			_delete.label.text = "delete";
			_delete.width = 100;
			_delete.height = 10;
			_delete.bottom = 0;
			_delete.addEventListener(MouseEvent.CLICK, deleteClick);
			addChild(_delete);*/
			
			
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
			
			
			_select.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_data) UI.onSetLayer.dispatch(_data);
		}
		
		public function get data():LayerData 
		{
			return _data;
		}
		
		public function set data(value:LayerData):void 
		{
			
			if (_data)
			{
				_data.image.change.remove(iconUpdated);
			}
			
			_data = value;
			
			visible = Boolean(_data);
			
			setIcon();
			
			if (_data)
			{
				_data.image.change.add(iconUpdated);
			}
			
		}
		
		private function iconUpdated(b:BitmapData):void 
		{
			setIcon();
		}
		
		private function setIcon():void 
		{
			
			if (_tileOutput) _tileOutput.updated.remove(tileUpdated);
			
			if (!_data) 
			{
				icon.bitmapData = null;
				mask.bitmapData = null;
				return;
			}
			
			icon.bitmapData = _data.image.bitmapData;
			icon.bitmap.smoothing = true;
			
			_tileOutput = Project.getTileOutput(_data.tileData);
			_tileOutput.updated.add(tileUpdated);
			tileUpdated(_tileOutput);
		}
		
		private function tileUpdated(t:TileOutput):void 
		{

			var li:int = _data.tileData.layers.indexOf(_data)
			
			var fi:int = Project.data.previewTile;
			
			var he:HexEdge = t.edges[li].edges[fi];
			
			mask.bitmapData = he.mask;
			mask.bitmap.smoothing = true;
		}
		
	}

}