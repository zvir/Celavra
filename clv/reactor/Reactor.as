package clv.reactor 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	/**
	 * ...
	 * @author Zvir
	 */
	public class Reactor
	{
		
		private var reactors:Dictionary = new Dictionary();
		
		public function Reactor() 
		{
			
			
			
		}
		
		public function init():void
		{
			var x:XML = describeType(this);
			
			//trace(x.toString());
			
			for each (var method:XML in x..method) 
			{
				trace(method.@name);
				reactors[this[method.@name]] = new Reaction();
			}
		}
		
		protected function react(f:Function, v:Array):void
		{
			Reaction(reactors[f]).call(v);
		}
		
		public function add(reaction:Function, method:Function, callWithArgs = true):void
		{
			
			var r:Reaction = reactors[reaction];
			
			if (!r)
			{
				throw new Error("reaction not found");
			}
			
			Reaction(reactors[reaction]).add(method, callWithArgs);
			
		}
		
		public function remove(reaction:Function, method:Function):void
		{
			
			var r:Reaction = reactors[reaction];
			
			if (!r)
			{
				throw new Error("reaction not found");
			}
			
			var r:Reaction = Reaction(reactors[reaction]) as Reaction;
			
			r.remove(method);
			
		}
		
		public function addOnce(reaction:Function, method:Function, callWithArgs = true):void
		{
			
			var r:Reaction = reactors[reaction];
			
			if (!r)
			{
				throw new Error("reaction not found");
			}
			
			Reaction(reactors[reaction]).addOnce(method, callWithArgs);
			
		}
		
	}

}