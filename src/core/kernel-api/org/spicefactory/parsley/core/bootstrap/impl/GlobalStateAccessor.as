package org.spicefactory.parsley.core.bootstrap.impl {

import org.spicefactory.parsley.core.state.GlobalObjectState;
import org.spicefactory.parsley.core.state.GlobalScopeState;
import org.spicefactory.parsley.core.state.manager.GlobalStateManager;
import org.spicefactory.parsley.core.state.manager.impl.DefaultGlobalStateManager;

[ExcludeClass]
/**
 * @private 
 * 
 * @author Jens Halm
 */
public class GlobalStateAccessor {
	
	
	private static var _stateManager:GlobalStateManager;
	
	internal static function get stateManager () : GlobalStateManager {
		if (!_stateManager) {
			_stateManager = new DefaultGlobalStateManager();
		}
		return _stateManager;
	}
	
	internal static function set stateManager (value:GlobalStateManager) : void {
		_stateManager = value;
	}
	
	public static function get objects () : GlobalObjectState {
		return stateManager.objects.publicState;
	}
	
	public static function get scopes () : GlobalScopeState {
		return stateManager.scopes.publicState;
	}
	
	
}
}
