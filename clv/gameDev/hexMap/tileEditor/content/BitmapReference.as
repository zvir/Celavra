package clv.gameDev.hexMap.tileEditor.content 
{
	import clv.gameDev.hexMap.tileEditor.data.IBitmapReferenceUpdater;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class BitmapReference 
	{
		
		private var _bitmapData:BitmapData;
		
		private var _file:File;
		
		private var _callers:Vector.<Function> = new Vector.<Function>();
		
		public var updater:IBitmapReferenceUpdater;
		
		private var _change:Signal = new Signal(BitmapData);
		
		public function BitmapReference() 
		{
			
		}
		
		public function getBitmapData(caller:Function):void 
		{
			if (!_bitmapData)
			{
				_callers.push(caller);
			}
			else
			{
				caller.call(null, _bitmapData);
			}
		}
		
		private function loaded(b:BitmapData):void 
		{
			_bitmapData = b;
			_change.dispatch(_bitmapData);
			call();
			if (updater != null) updater.bitmapUpdated(b);
		}
		
		private function call():void 
		{
			while (_callers.length > 0)
			{
				_callers.pop().call(null, _bitmapData);
			}
		}
		
		public function get file():File 
		{
			return _file;
		}
		
		public function set path(value:String):void 
		{
			if (!value) return;
			
			_file = new File(value);
			BitmapLoader.load(_file, loaded);
			_bitmapData = null;
			_change.dispatch(_bitmapData);
		}
		
		public function get path():String 
		{
			return _file ? _file.nativePath : null;
		}
		
		public function get bitmapData():BitmapData 
		{
			return _bitmapData;
		}
		
		public function get change():Signal 
		{
			return _change;
		}
		
	}

}