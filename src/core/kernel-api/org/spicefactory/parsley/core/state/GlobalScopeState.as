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

package org.spicefactory.parsley.core.state {
import org.spicefactory.parsley.core.scope.Scope;

/**
 * Global status information about currently active scopes.
 * 
 * @author Jens Halm
 */
public interface GlobalScopeState {
	
	
	/**
	 * Returns the scope with the specified unique id.
	 * 
	 * @param uuid the unique id of the scope to look for
	 * @return the scope with the specified unique id or null if no such scope exists.
	 */
	function getScopeById (uuid:String) : Scope;
	
	/**
	 * Returns all scopes with the specified name.
	 * 
	 * @param name the name of the scopes to look for
	 * @return the scopes with the specified name or an empty Array if no such scope exists.
	 */
	function getScopesByName (name:String) : Array;
	
	/**
	 * Returns the next uuid for the specified scope name.
	 * 
	 * @param scopeName the name of the scope
	 * @return the next uuid for the specified scope name
	 */
	function nextUuidForName (scopeName:String) : String;
	
	
}
}
