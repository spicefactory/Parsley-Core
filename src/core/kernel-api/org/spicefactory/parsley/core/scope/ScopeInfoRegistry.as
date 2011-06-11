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

package org.spicefactory.parsley.core.scope {


/**
 * The registry of scope instances for a single Context.
 * In contrast to the public API of the <code>ScopeManager</code> this registry
 * holds <code>ScopeInfo</code> instances which represent the internal API for 
 * a single scope. The registry is available for kernel services through the
 * <code>BootstrapInfo</code> instance passed to their <code>init</code> methods.
 * 
 * @author Jens Halm
 */
public interface ScopeInfoRegistry {
	

	/**
	 * The definitions for the scopes that were added to this Context.
	 * 
	 * <p>The <code>ScopeManager</code> implementation is supposed to turn these into <code>ScopeInfo</code>
	 * instances and add them to this instance with the <code>addActiveScope</code> method.</p>
	 *  
	 * <p>The Array holds <code>ScopeDefinition</code> instances.</p>
	 */
	function get newScopes () : Array;
	
	/**
	 * The scopes that were marked for inheritance from the parent Context.
	 * 
	 * <p>The <code>ScopeManager</code> implementation is supposed to pass them to the <code>addActiveScope</code> method
	 * if they should indeed get added to this Context. In most cases all inherited scopes from the parent Context
	 * will get added, but the final decision is up to the <code>ScopeManager</code>.</p>
	 * 
	 * <p>The Array holds <code>ScopeInfo</code> instances.</p>
	 */
	function get parentScopes () : Array;
	
	/**
	 * The active scopes for this Context.
	 * 
	 * <p>Will be empty initially, but will later hold all instances added to this registry 
	 * with the <code>addActiveScope</code> method, usually during initialization 
	 * of the <code>ScopeManager</code> instance.</p>
	 * 
	 * <p>The Array holds <code>ScopeInfo</code> instances.</p>
	 */
	function get activeScopes () : Array;
	
	/**
	 * Adds a new active scope for this Context, in most cases either created from one of the definitions
	 * held in the newScopes property or passed on from the existing ScopeInfo instances in the parentScopes property.
	 * 
	 * @param info the scope to add for this Context.
	 */
	function addActiveScope (info:ScopeInfo) : void;

	
}
}
