package clv.gameDev.hexMap.tileEditor.content 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class BitmapLoader 
	{
		
		private static const _filesToLoad:Vector.<File> = new Vector.<File>();
		private static const _callers:Vector.<Function> = new Vector.<Function>();
		
		private static var _currentFile:File;
		private static var _currentCaller:Function;
		
		private static const _stream:FileStream = getStream();
		
		public static function load(file:File, caller:Function):void
		{
			if (_filesToLoad.indexOf(file) != -1) return;
			
			_filesToLoad.push(file);
			_callers.push(caller);
			
			if (!_currentFile) loadNext();
			
		}
		
		static private function loadNext():void 
		{
			if (_filesToLoad.length == 0) return;
			
			_currentFile = _filesToLoad.shift();
			_currentCaller = _callers.shift();
			
			_stream.openAsync(_currentFile, FileMode.READ);

			
		}
		
		static private function getStream():FileStream 
		{
			var s:FileStream = new FileStream();
			
			s.addEventListener(Event.COMPLETE, loadComplete);
			s.addEventListener(ProgressEvent.PROGRESS, progressEvent);
			s.addEventListener(IOErrorEvent.IO_ERROR, errorEvent);
			
			return s;
		}
		
		static private function loadComplete(e:Event):void 
		{
			var bytes:ByteArray = new ByteArray();
			_stream.readBytes(bytes);
			_stream.close();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadbytesComplete);
			loader.loadBytes(bytes);
		}
		
		static private function loadbytesComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, loadbytesComplete);
			var bitmapData:BitmapData = e.currentTarget.content.bitmapData;
			
			_currentCaller.call(null, bitmapData);
			
			_currentFile = null;
			_currentCaller = null;
			
			loadNext();
			
		}
		
		static private function progressEvent(e:ProgressEvent):void 
		{
			
		}
		
		static private function errorEvent(e:IOErrorEvent):void 
		{
			_currentFile = null;
			_currentCaller = null;
			
			loadNext();
		}
		
	}

}