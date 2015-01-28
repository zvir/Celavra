package clv.gameDev.hexMap.tileEditor.content 
{
	import clv.gameDev.hexMap.tileEditor.data.Project;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class FileChooser 
	{
		private static var _caller:Function;
		
		public static function select(caller:Function) 
		{
			if (_caller != null) return;
			
			_caller = caller;
			
			var file:File = Project.data.loadPath ? new File(Project.data.loadPath) : File.documentsDirectory;
			
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.CANCEL,cancelHandler);
			var fileFilter:FileFilter = new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png");
			file.browseForOpen("Open image(s)", [fileFilter]);

		}
		
		static private function cancelHandler(e:Event):void 
		{
			_caller = null;
		}
		
		private static function selectHandler(e:Event):void 
		{
			_caller(e.target);
			_caller = null;
			
			Project.data.loadPath = e.target.parent.nativePath;
			
		}
		
	}

}