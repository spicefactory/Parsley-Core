/*
 * Copyright 2011 the original author or authors.
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

package org.spicefactory.parsley.core.scope.impl {
import org.spicefactory.parsley.core.scope.ScopeInfo;
import org.spicefactory.parsley.core.scope.ScopeInfoRegistry;

/**
 * Default implementation of the ScopeInfoRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeInfoRegistry implements ScopeInfoRegistry {
	
	
	private var _newScopes:Array;
	private var _parentScopes:Array;
	private var _activeScopes:Array;
	
	
	/**
	 * Creates a new instance
	 * 
	 * @param newScopes the definitions for the scopes that were added to this Context
	 * @param parentScopes the scopes that were marked for inheritance from the parent Context
	 */
	function DefaultScopeInfoRegistry (newScopes:Array, parentScopes:Array) {
		_newScopes = newScopes;
		_parentScopes = parentScopes;
		_activeScopes = new Array();
	}

	
	/**
	 * @inheritDoc
	 */
	public function addActiveScope (info:ScopeInfo) : void {
		_activeScopes.push(info);
	}

	/**
	 * @inheritDoc
	 */
	public function get newScopes () : Array {
		return _newScopes;
	}

	/**
	 * @inheritDoc
	 */
	public function get parentScopes () : Array {
		return _parentScopes;
	}

	/**
	 * @inheritDoc
	 */
	public function get activeScopes () : Array {
		return _activeScopes;
	}
	
	
}
}
