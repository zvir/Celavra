package clv.gui.core.states 
{
	import clv.gui.core.IComponent;
	/**
	 * ...
	 * @author Zvir Celavra
	 */
	public class StatesManager 
	{
		
		private var _states:/*String*/Array = new Array();
		private var _currentStates:/*String*/Array = new Array();
		
		private var _delegateState:IComponent;
		private var _combineWithDelegateStates:Boolean = false;
		
		private var _component:IComponent;
		
		public function StatesManager(component:IComponent) 
		{
			_component = component;
		}
		
		public function define(state:String):void
		{
			_states.push(state);
		}
		
		public function hasState(state:String):Boolean
		{
			if (!_delegateState) return _states.indexOf(state) != -1;
			
			var delegateStates:Array = _delegateState.states;
			
			if (_combineWithDelegateStates)
			{
				var combinedStates:Array = _states.slice(0);
				
				for (var i:int = 0; i < delegateStates.length; i++) 
				{
					if (_states.indexOf(delegateStates[i]) == -1) combinedStates.push(delegateStates[i]);
				}
				return combinedStates.indexOf(state) != -1;
			}
			else
			{
				return delegateStates.indexOf(state) != -1;
			}
			
		}
		
		public function manageStates(add:Object = null, remove:Object = null):void
		{
			
			var addStates:Array;
			var removeStates:Array;
			
			var addedStates:Array = new Array();
			var removedStates:Array = new Array();
			
			
			if (add is String) 
				addStates = [add];
			else if (add is Array)
				addStates = add as Array;
			else if (add != null)
				throw new Error("Array or String is accepted only");
			
			if (remove is String)
				removeStates = [remove];
			else if (remove is Array)
				removeStates = remove as Array;
			else if (remove != null)
				throw new Error("Array or String is accepted only");
			
			for (var i:int = 0; i < addStates.length; i++) 
			{
				if (_currentStates.indexOf(addStates[i]) == -1)
				{
					_currentStates.push(addStates[i]);
					addedStates.push(addStates[i]);
				}
			}
			
			for (i = 0; i < removeStates.length; i++)
			{
				var ind:int = _currentStates.indexOf(removeStates[i]);
				
				if (ind != -1)
				{
					_currentStates.splice(ind, 1);
					removedStates.push(removeStates[i]);
				}
				
			}
			
			// RW
			
			if (addedStates.length > 0 || removedStates.length > 0)
			{
				_component.onStateChange.dispatch(new StateSignal(_component, addedStates, removedStates, _currentStates));
			}
			
		}
		
		public function add(state:String):void
		{
			if (_currentStates.indexOf(state) != -1) return;
			_currentStates.push(state);
			_component.onStateChange.dispatch(new StateSignal(_component, [state], null, _currentStates));
		}
		
		public function remove(state:String):void
		{
			var i:int = _currentStates.indexOf(state);
			if (i == -1) return;
			_currentStates.splice(i, 1);
			
			_component.onStateChange.dispatch(new StateSignal(_component, null, [state], _currentStates));
		}
		
		public function get currentStates():Array/*String*/ 
		{
			return __currentStates;
		}
		
		private function delegateStateChange(e:StateSignal):void 
		{
			_component.onStateChange.dispatch(new StateSignal(_component, e.added, e.removed, __currentStates));
		}
		
		public function isCurrentState(state:String):Boolean
		{
			return (__currentStates.indexOf(state) != -1);
		}
		
		public function dispose():void 
		{
			if (_delegateState)
			{
				_delegateState.onStateChange.remove(delegateStateChange);
			}
			
			_component = null;
			_states = null;
			_currentStates = null;
			_delegateState = null;
		}
		
		public function update():void 
		{
			// to do if its woth it
		}
		
		private function get __currentStates():Array
		{
			if (!_delegateState) return _currentStates;
			
			var delegateStates:Array = _delegateState.currentStates;
			
			if (_combineWithDelegateStates)
			{
				var combinedStates:Array = _currentStates.slice(0);
				
				for (var i:int = 0; i < delegateStates.length; i++) 
				{
					if (_currentStates.indexOf(delegateStates[i]) == -1) combinedStates.push(delegateStates[i]);
				}
				return combinedStates;
			}
			else
			{
				return delegateStates;
			}
		}
		
		private function getStatesReport(newStates:Array, removedStates:Array):void
		{
			
		}
		
		public function get combineWithDelegateStates():Boolean 
		{
			return _combineWithDelegateStates;
		}
		
		public function set combineWithDelegateStates(value:Boolean):void 
		{
			_combineWithDelegateStates = value;
			_component.onStateChange.dispatch(new StateSignal(_component, null, null, _currentStates));
		}
		
		public function set delegateState(value:IComponent):void
		{
			if (_delegateState)	_delegateState.onStateChange.remove(delegateStateChange);
			
			_delegateState = value;
			
			if (_delegateState)	
			{
				_delegateState.onStateChange.add(delegateStateChange);
				_component.onStateChange.dispatch(new StateSignal(_component, _delegateState.states, null, __currentStates));
			}
		}
		
		public function get delegateState():IComponent
		{
			return _delegateState;
		}
		
		public function get states():Array/*String*/ 
		{
			return _states;
		}
		
	}

}