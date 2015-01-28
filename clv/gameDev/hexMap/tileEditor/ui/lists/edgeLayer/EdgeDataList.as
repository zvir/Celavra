package clv.gameDev.hexMap.tileEditor.ui.lists.edgeLayer 
{
	import clv.gameDev.hexMap.tileEditor.data.EdgeLayer;
	import zvr.zvrGUI.core.IZvrSimpleDataItem;
	import zvr.zvrGUI.core.ZvrScroll;
	import zvr.zvrGUI.core.ZvrSimpeDataContainer;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class EdgeDataList extends ZvrSimpeDataContainer
	{
		private var _data:Vector.<EdgeLayer>;
		
		public function EdgeDataList(verticalScroll:ZvrScroll, horizontalScroll:ZvrScroll) 
		{
			super(EdgeListItem, verticalScroll, horizontalScroll);
			setLayout(ZvrVerticalLayout);
		}
		
		override protected function updateItem(item:IZvrSimpleDataItem, index:int):void 
		{
			var i:EdgeListItem = item as EdgeListItem;
			
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
			var l:EdgeListItem = new EdgeListItem();
			return l;
		}
		
		public function get data():Vector.<EdgeLayer> 
		{
			return _data;
		}
		
		public function set data(value:Vector.<EdgeLayer>):void 
		{
			_data = value;
			update();
		}
	}

}