package clv.gameDev.hexMap.tileEditor.ui.lists.tiles 
{
	import clv.gameDev.hexMap.tileEditor.data.TileData;
	import zvr.zvrGUI.core.IZvrSimpleDataItem;
	import zvr.zvrGUI.core.ZvrScroll;
	import zvr.zvrGUI.core.ZvrSimpeDataContainer;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class TilesDataList extends ZvrSimpeDataContainer
	{
		private var _data:Vector.<TileData>;
		
		public function TilesDataList(verticalScroll:ZvrScroll, horizontalScroll:ZvrScroll) 
		{
			super(TilesListItem, verticalScroll, horizontalScroll);
		}
		
		override protected function updateItem(item:IZvrSimpleDataItem, index:int):void 
		{
			var i:TilesListItem = item as TilesListItem;
			
			if (!_data || index >= _data.length) 
			{
				i.data = null;
				return
			}
			
			i.data = _data[index];
		}
		
		public function update():void
		{
			updateList(_data ? _data.length : 50);
		}
		
		override protected function getNewListItem(index:int):IZvrSimpleDataItem 
		{
			var l:TilesListItem = new TilesListItem();
			return l;
		}
		
		public function get data():Vector.<TileData> 
		{
			return _data;
		}
		
		public function set data(value:Vector.<TileData>):void 
		{
			_data = value;
			update();
		}
		
	}

}