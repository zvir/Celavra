package clv.gameDev.hexMap.tileEditor.ui.lists.tiles 
{
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import clv.gameDev.hexMap.tileEditor.outputs.TileOutput;
	import clv.gameDev.hexMap.tileEditor.UI;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import zvr.zvrGUI.components.minimalDark.LabelMD;
	import zvr.zvrGUI.core.IZvrSimpleDataItem;
	import zvr.zvrGUI.core.ZvrBitmap;
	import zvr.zvrGUI.core.ZvrGroup;
	import zvr.zvrGUI.layouts.ZvrBitmapAutoSize;
	import zvr.zvrGUI.skins.ZvrStyles;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TilesListItem extends ZvrGroup implements IZvrSimpleDataItem
	{
		
		private var _data:TileData;
		
		private var _name:LabelMD = new LabelMD();
		private var _details:LabelMD = new LabelMD();
		private var icon:ZvrBitmap;
		private var tileOutput:TileOutput;
		
		public function TilesListItem() 
		{
			width = 120;
			height = 120;
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x0C666D, 0.2);
			s.graphics.drawRect(0, 0, width, height);
			s.graphics.endFill();
			addChild(s);
			
			icon = new ZvrBitmap();
			
			icon.scaleMode = ZvrBitmapAutoSize.KEEP_RATIO_INSIDE;
			icon.verticalCenter = 0;
			icon.horizontalCenter = 0;
			icon.width = 100;
			icon.height = 100;
			
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
			
			visible = false;
			
			addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(e:Event):void 
		{
			if (_data) UI.onSetTile.dispatch(_data);
		}
		
		public function get data():TileData 
		{
			return _data;
		}
		
		public function set data(value:TileData):void 
		{
			
			if (tileOutput)
			{
				tileOutput.updated.remove(updateTile);
			}
			
			_data = value;
			
			visible = Boolean(_data);
			
			if (_data)
			{
				tileOutput = Project.getTileOutput(_data);
				tileOutput.updated.add(updateTile);
				updateTile(tileOutput);
			}
			
		}
		
		private function updateTile(v:TileOutput):void
		{
			
			if (v != tileOutput) 
			{
				v.updated.remove(updateTile);
				return;
			}
			
			if (tileOutput.bitmaps.length > 0) 
			{
				icon.bitmapData = tileOutput.bitmaps[Project.data.previewTile];
				icon.bitmap.smoothing = true;
			}
		}
		
	}

}