package clv.reactor 
{
	/**
	 * ...
	 * @author Zvir
	 */
	public class Reaction 
	{
		
		public const recivers:Vector.<Reciver> = new Vector.<Reciver>();
		public const reciversOnce:Vector.<Reciver> = new Vector.<Reciver>();
		
		public function Reaction() 
		{
			
		}
		
		public function add(method:Function, callWithArgs:Boolean = true):void
		{
			for (var i:int = 0; i < recivers.length; i++) 
			{
				var r:Reciver = recivers[i];
				
				if (r.method == method)
				{
					return;
				}
			}
			
			r = new Reciver();
			r.method = method;
			r.withArgs = callWithArgs;
			recivers.push(r);
		}
		
		
		public function addOnce(method:Function, callWithArgs:Boolean = true):void
		{
			for (var i:int = 0; i < reciversOnce.length; i++) 
			{
				var r:Reciver = reciversOnce[i];
				
				if (r.method == method)
				{
					return;
				}
			}
			
			r = new Reciver();
			r.method = method;
			r.withArgs = callWithArgs;
			reciversOnce.push(r);
		}
		
		
		public function remove(method:Function):void
		{
			for (var i:int = 0; i < recivers.length; i++) 
			{
				var r:Reciver = recivers[i];
				
				if (r.method == method)
				{
					recivers.splice(i, 1);
					break;
				}
			}
			
			for (var i:int = 0; i < reciversOnce.length; i++) 
			{
				var r:Reciver = reciversOnce[i];
				
				if (r.method == method)
				{
					reciversOnce.splice(i, 1);
					break;
				}
			}
		}
		
		
		public function call(args:Array):void
		{
			for (var i:int = 0; i < recivers.length; i++) 
			{
				var r:Reciver = recivers[i];
				
				if (r.withArgs)
				{
					r.method.apply(null, r.withArgs ? args : null);
				}
			}
			
			for (i = 0; i < reciversOnce.length; i++) 
			{
				var r:Reciver = reciversOnce[i];
				
				if (r.withArgs)
				{
					r.method.apply(null, r.withArgs ? args : null);
				}
			}
			
			reciversOnce.length = 0;
		}
		
	}

}