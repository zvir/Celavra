package clv.genome2d.components.renderables.hexMap 
{
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class HMRL 
	{
		public var head : HMR;
		public var tail : HMR;
		
		public function HMRL() 
		{
			
		}
		
		internal function add( entity : HMR ) : HMR
		{
			
			if( ! head )
			{
				head = tail = entity;
				entity.next = entity.previous = null;
			}
			else
			{
				tail.next = entity;
				entity.previous = tail;
				entity.next = null;
				tail = entity;
			}
			
			return entity;
		}
		
		internal function remove( entity : HMR ) : HMR
		{
			if ( head == entity)
			{
				head = head.next;
			}
			
			if ( tail == entity)
			{
				tail = tail.previous;
			}
			
			if (entity.previous)
			{
				entity.previous.next = entity.next;
			}
			
			if (entity.next)
			{
				entity.next.previous = entity.previous;
			}
			
			return entity;
			
			// N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.
		}
		
		internal function removeAll() : void
		{
			while( head )
			{
				var entity : HMR = head;
				head = head.next;
				entity.previous = null;
				entity.next = null;
			}
			tail = null;
		}
	}

}