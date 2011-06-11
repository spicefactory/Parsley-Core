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

package org.spicefactory.parsley.core.state.manager {
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.state.GlobalScopeState;

/**
 * Keeps track of all scopes of all the currently active Context instances.
 * Provides only status information without actuall managing the scopes itself (which is the responsibility
 * of the kernel services of each individual Context).
 * 
 * <p>This manager is usually only exposed to the IOC kernel services and can be accessed through a <code>BootstrapInfo</code>
 * instance.</p>
 * 
 * @author Jens Halm
 */
public interface GlobalScopeManager {
	
	
	/**
	 * Adds the specified scope to the manager.
	 * The scope should be automatically removed from this manager when the root Context
	 * of the scope gets destroyed, as the scope is no longer in use after that.
	 * 
	 * @param scope the scope to add to the manager
	 */
	function addScope (scope:Scope) : void;
	
	/**
	 * The state information for all active scopes in a read-only format to be exposed to applications.
	 */
	function get publicState () : GlobalScopeState;
	
	
}
}
