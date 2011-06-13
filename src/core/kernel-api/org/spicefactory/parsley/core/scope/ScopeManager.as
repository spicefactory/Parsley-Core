/*
 * Copyright 2009 the original author or authors.
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
import org.spicefactory.parsley.core.command.ManagedCommand;

/**
 * Responsible for managing the scopes associated with a single Context.
 * Each Context has a unique set of scopes associated with it. It may be any
 * combination of scopes inherited from parent Contexts or explicitly created for a Context.
 * When no custom scopes are created the default setup is that each Context is associated with
 * two scopes: One global scope, shared throughout the entire Context hierarchy, and a local
 * scope that just spans a single Context.
 * 
 * <p>Scopes allow to create segments in your application where application messages or lifecycle
 * listeners are only effective for a particular scope, which in turn may span multiple Contexts.</p>
 * 
 * @author Jens Halm
 */
public interface ScopeManager {
	
	/**
	 * Indicates whether this manager contains a scope with the specified name.
	 * 
	 * @param name the name of the scope to look for
	 * @return true if this manager contains a scope with the specified name
	 */
	function hasScope (name:String) : Boolean;
	
	/**
	 * Returns the scope instance for the specified scope name.
	 * If the scope name is omitted, the default receiver scope is returned.
	 * 
	 * @param name the name of the scope to look for
	 * @return the Scope instance for the specified name
	 */
	function getScope (name:String = null) : Scope;
	
	/**
	 * Returns all scope instances managed by this instance.
	 * 
	 * @return all scope instances managed by this instance
	 */
	function getAllScopes () : Array;
	
	/**
	 * Dispatches a message through all scopes managed by this instance.
	 * In many cases you'll want to dispatch application messages through all scopes so that
	 * the receiving side can decide which scope it wants to listen for.
	 * 
	 * @param message the message to dispatch
	 * @param selector the selector to use if it cannot be determined from the message instance itself
	 */
	function dispatchMessage (message:Object, selector:* = undefined) : void;
	
	/**
	 * Observes the specified command and dispatches messages to registered observers of all scopes managed by
	 * this instance when the state of the command changes.
	 * 
	 * @param command the command to observe
	 */
	function observeCommand (command:ManagedCommand) : void;
	
}
}
