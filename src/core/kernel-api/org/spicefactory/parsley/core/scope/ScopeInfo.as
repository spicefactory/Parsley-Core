/*
 * Copyright 2009-2011 the original author or authors.
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

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;

/**
 * Holds the definition and state (like all registered message receivers) for a single scope. Instances of this class
 * will be shared by all ScopeManagers of all Context instances that
 * a scope is associated with.
 * 
 * @author Jens Halm
 */
public interface ScopeInfo {
	
	
	/**
	 * The name of the scope.
	 */	
	function get name () : String;
	
	/**
	 * The unique id of the scope.
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
	 * Returns the cache of message receivers for the specified message type.
	 * If no cache for that type exists yet, implementations should create and return a new
	 * cache instance.
	 * 
	 * @param type the message type to return the receiver cache for
	 * @return the cache of message receivers for the specified message type
	 */
	function getMessageReceiverCache (type:ClassInfo) : MessageReceiverCache;
	
	/**
	 * The manager for active commands in this scope.
	 */
	function get commandManager () : CommandManager;
	
	/**
	 * Adds an actice command to the command manager of this scope.
	 * As the CommandManager is a public API it does not contain a comparable method itself.
	 */
	function addActiveCommand (command:ObservableCommand) : void;
	
	/**
	 * The registry for observers of lifecycle events dispatched by objects within this scope.
	 */
	function get lifecycleObservers () : LifecycleObserverRegistry; 
	
	/**
	 * Returns all matching observers for the specified target type, id and lifecycle phase.
	 * 
	 * @param type the object type to return the observers for
	 * @param lifecycle the lifecycle phase of the observed object
	 * @param id the id of the observerd object
	 * @return all matching observers
	 */
	function selectLifecycleObservers (type:ClassInfo, phaseKey:String, id:String = null) : Array

	/**
	 * The extensions registered for this scope.
	 */
	function get extensions () : ScopeExtensions;
	

}
}
