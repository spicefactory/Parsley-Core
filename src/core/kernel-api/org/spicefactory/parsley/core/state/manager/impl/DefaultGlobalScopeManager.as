/*
 * Copyright 2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.core.state.manager.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.state.GlobalScopeState;
import org.spicefactory.parsley.core.state.manager.GlobalScopeManager;

/**
 * Default implementation of the GlobalScopeManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultGlobalScopeManager implements GlobalScopeManager {
		
	
	/**
	 * @inheritDoc
	 */
	public function addScope (scope:Scope) : void {
		if (_publicState.scopesById[scope.uuid]) {
			throw new IllegalArgumentError("Scope with uuid " + scope.uuid + " already registered");
		}
		_publicState.scopesById[scope.uuid] = scope;
		var byName:Array = _publicState.scopesByName[scope.name];
		if (!byName) {
			byName = new Array(); 
			_publicState.scopesByName[scope.name] = byName;
		}
		byName.push(scope);
		var f:Function = function (event:ContextEvent) : void {
			scope.rootContext.removeEventListener(ContextEvent.DESTROYED, f);
			removeScope(scope);
		};
		scope.rootContext.addEventListener(ContextEvent.DESTROYED, f);
	}
	
	private function removeScope (scope:Scope) : void {
		delete _publicState.scopesById[scope.uuid];
		var byName:Array = _publicState.scopesByName[scope.name];
		if (byName) {
			ArrayUtil.remove(byName, scope);
		}
	}
	
	private var _publicState:DefaultGlobalScopeState = new DefaultGlobalScopeState();
	
	/**
	 * @inheritDoc
	 */
	public function get publicState () : GlobalScopeState {
		return _publicState;
	}
	
	
}
}

import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.state.GlobalScopeState;

import flash.utils.Dictionary;

class DefaultGlobalScopeState implements GlobalScopeState {
	
	internal var scopesByName:Dictionary = new Dictionary();
	internal var scopesById:Dictionary = new Dictionary();
	
	internal var uuids:Dictionary = new Dictionary();
	
	public function getScopeById (uuid:String) : Scope {
		return scopesById[uuid] as Scope;
	}
	
	public function getScopesByName (name:String) : Array {
		return (scopesByName[name]) ? scopesByName[name] as Array : [];
	}
	
	public function nextUuidForName (scopeName:String) : String {
		if (!uuids[scopeName]) {
			uuids[scopeName] = 0;
		}
		while (scopesById[scopeName + uuids[scopeName]]) {
			uuids[scopeName]++;
		}
		return scopeName + uuids[scopeName];
	}
	
	public function reset () : void {
		scopesByName = new Dictionary();
		scopesById = new Dictionary();
		uuids = new Dictionary();
	}
	
}
