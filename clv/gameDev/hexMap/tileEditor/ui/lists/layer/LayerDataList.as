package clv.gameDev.hexMap.tileEditor.ui.lists.layer 
{
	import clv.gameDev.hexMap.tileEditor.data.LayerData;
	import zvr.zvrGUI.core.IZvrSimpleDataItem;
	import zvr.zvrGUI.core.ZvrScroll;
	import zvr.zvrGUI.core.ZvrSimpeDataContainer;
	import zvr.zvrGUI.layouts.ZvrVerticalLayout;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class LayerDataList extends ZvrSimpeDataContainer
	{
		
		private var _data:Vector.<LayerData>;
		
		public function LayerDataList(verticalScroll:ZvrScroll, horizontalScroll:ZvrScroll) 
		{
			super(LayerListItem, verticalScroll, horizontalScroll);
			
			setLayout(ZvrVerticalLayout);
			
		}
		
		override protected function updateItem(item:IZvrSimpleDataItem, index:int):void 
		{
			var i:LayerListItem = item as LayerListItem;
			
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
			var l:LayerListItem = new LayerListItem();
			/*
			l.addEventListener(MouseEvent.CLICK, imageSelected);
			l.addEventListener(MouseEvent.MOUSE_OVER, imageMouseOver);
			l.addEventListener(MouseEvent.MOUSE_OUT, imageMouseOut);
			*/
			return l;
		}
		
		/*private function imageSelected(e:MouseEvent):void 
		{
			if (ImageIcon(e.currentTarget).image) trace(ImageIcon(e.currentTarget).image.file.nativePath);
			main.showItem(ImageIcon(e.currentTarget).image);
		}
		
		private function imageMouseOver(e:MouseEvent):void 
		{
			if (ImageIcon(e.currentTarget).image) main.hilightImage(ImageIcon(e.currentTarget).image);
		}
		
		private function imageMouseOut(e:MouseEvent):void 
		{
			main.dehilight();
		}*/
		
		public function get data():Vector.<LayerData> 
		{
			return _data;
		}
		
		public function set data(value:Vector.<LayerData>):void 
		{
			_data = value;
			update();
		}
		
	}

}