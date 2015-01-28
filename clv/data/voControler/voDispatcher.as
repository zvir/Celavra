package clv.data.voControler 
{
	import clv.data.voBase.voBase;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Zvir
	 */
	public class voDispatcher 
	{
		
		private const list:Dictionary = new Dictionary();
		
		public function voDispatcher() 
		{
			
		}
		
		public function remove(vo:voBase, f:Function):void
		{
			
			var a:Array = list[vo];
			
			if (!a)
			{
				return;
			}
			
			var i:int = a.indexOf(f);
			
			if (i == -1) return;
			
			a.splice(i, 1);
		}
		
		public function add(vo:voBase, f:Function):void
		{
			
			if (list[vo] == undefined)
			{
				list[vo] = [];
			}
			
			list[vo].push(f);
		}
		
		public function dispatch(vo:voBase):void
		{
			var a:Array = list[vo];
			
			if (!a) return;
			
			for (var i:int = 0; i < a.length; i++) 
			{
				a[i].call(null, vo);
			}
		}
	}

}