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
import org.spicefactory.parsley.core.binding.BindingManager;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;

/**
 * Represents a single scope.
 * 
 * @author Jens Halm
 */
public interface Scope {
	
	
	/**
	 * The name of the scope.
	 */
	function get name () : String;
	
	/**
	 * The unique id of this scope. 
	 * In small or mid-size projects an id is often not needed, the framework will autogenerate
	 * the id in these cases and it can simply be ignored. In a big modular application there may
	 * be the need to address one particular scope within the system and the scheme of ids assigned
	 * to the scopes is often application-specific. The uid may be used to identify persistent published
	 * values or to explicitly route messages.
	 */
	function get uuid () : String;
	
	/**
	 * Indicates whether this scope will be inherited by child Contexts.
	 */
	function get inherited () : Boolean;
	
	/**
	 * The root Context of this scope.
	 */
	function get rootContext () : Context;
	
	/**
	 * The registry for receivers of application messages dispatched through this scope.
	 */
	function get messageReceivers () : MessageReceiverRegistry;
	
	/**
	 * The manager for active asynchronous commands in this scope.
	 */
	function get commandManager () : CommandManager;
	
	/**
	 * The manager for publishers and subscribers of the decoupled binding facility.
	 */
	function get bindingManager () : BindingManager;
	
	/**
	 * The manager for values persisted by publishers.
	 */
	function get persistenceManager () : PersistenceManager;
	
	/**
	 * The registry for observers of lifecycle events dispatched by objects within this scope.
	 */
	function get lifecycleObservers () : LifecycleObserverRegistry; 
	 
	/**
	 * Custom extensions registered for this scope.
	 */
	function get extensions () : ScopeExtensions;
	
	/**
	 * Dispatches a message through this scope.
	 * 
	 * @param message the message to dispatch
	 * @param selector the selector to use if it cannot be determined from the message instance itself
	 */
	function dispatchMessage (message:Object, selector:* = undefined) : void;
	
	
}
}
