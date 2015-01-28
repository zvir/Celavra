package clv.data.voControler 
{
	import clv.data.voBase.voArray;
	import clv.data.voBase.voBase;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Zvir
	 */
	public class voDataControler 
	{
		
		public static const instance = new voDataControler();
		
		public const onChange	:voDispatcher = new voDispatcher();
		
		public const onMove		:voDispatcher = new voDispatcher();
		public const onAdd      :voDispatcher = new voDispatcher();
		public const onRemove   :voDispatcher = new voDispatcher();
		
		private const changed	:Vector.<voBase> = new Vector.<voBase>();
		
		private const moved		:Vector.<voArrayChange> = new Vector.<voArrayChange>();
		private const added		:Vector.<voArrayChange> = new Vector.<voArrayChange>();
		private const removed	:Vector.<voArrayChange> = new Vector.<voArrayChange>();
		
		public const onClear	:Signal = new Signal();
		
		private var isDirty		:Boolean;
		
		public function voDataControler() 
		{
			
		}
		
		public function dispatch():void
		{
			
			if (!isDirty) return;
			isDirty = false;
			
			var i:int;
			
			for (i = 0; i < changed.length; i++) 
			{
				onChange.dispatch(changed[i]);
			}
			
			changed.length = 0;
			
			for (i = 0; i < moved.length; i++) 
			{
				onMove.dispatch(moved[i]);
			}
			
			moved.length = 0;
			
			for (i = 0; i < added.length; i++) 
			{
				onAdd.dispatch(added[i]);
			}
			
			added.length = 0;
			
			for (i = 0; i < removed.length; i++) 
			{
				onRemove.dispatch(removed[i]);
			}
			
			removed.length = 0;
			
			
		}
		
		public function reportChange(v:voBase):void
		{
			
			if (changed.indexOf(v) != -1) return;
			
			changed.push(v);
			
			isDirty = true;
		}
		
		public function reportMove(v:voBase, a:voArray):void
		{
			
			var va:voArrayChange = new voArrayChange();
			
			va.a = a;
			va.i = v;
			
			moved.push(va);
			
			reportChange(a);
			
			isDirty = true;
		}
		
		public function reportAdd(v:*, a:voArray):void
		{
			var va:voArrayChange = new voArrayChange();
			
			va.a = a;
			va.i = v;
			
			added.push(va);
			
			reportChange(a);
			
			isDirty = true;
		}
		
		public function reportRemove(v:voBase, a:voArray):void
		{
			var va:voArrayChange = new voArrayChange();
			
			va.a = a;
			va.i = v;
			
			removed.push(va);
			
			reportChange(a);
			
			isDirty = true;
		}
		
	}

}