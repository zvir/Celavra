package clv.utils.files 
{
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Zvir
	 */
	public class FileUtils 
	{
		
		public static function makeExtension(f:File, extension:String):File
		{
			var s:String = f.name;
			
			
			var c:int = s.lastIndexOf(".");
			
			if (c != -1)
			{
				s = s.substr(0, c) + "." + extension;
			}
			else
			{
				s = s + "." + extension;
			}
			
			f = f.parent.resolvePath("./" + s);
			
			return f;
			
		}
		
	}

}