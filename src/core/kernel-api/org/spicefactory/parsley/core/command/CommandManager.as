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

package org.spicefactory.parsley.core.command {

/**
 * Responsible for managing all active commands for a single scope.
 * Since each scope has its own manager, instances can be obtained through the 
 * <code>Scope.commandManager</code> property.
 * 
 * @author Jens Halm
 */
public interface CommandManager {

	/**
	 * Indicates whether this scope has any active commands triggered by a message
	 * that matches the specified type and selector.
	 * 
	 * @param messageType the type of the message that triggered the commands
	 * @param selector the selector of the message that triggered the commands
	 * @return true if there is at least one matching command in this scope.
	 */
	function hasActiveCommandsForTrigger (messageType:Class, selector:* = undefined) : Boolean;
	
	/**
	 * Indicates whether this scope has any active commands
	 * that matches the specified command type and id.
	 * 
	 * @param commandType the type of the command
	 * @param id the id the command is registered with in the Context
	 * @return true if there is at least one matching command in this scope.
	 */
	function hasActiveCommandsOfType (commandType:Class, id:String = null) : Boolean;
	
	/**
	 * Returns all active commands triggered by a message
	 * that matches the specified type and selector in this scope.
	 * 
	 * @param messageType the type of the message that triggered the commands
	 * @param selector the selector of the message that triggered the commands
	 * @return all matching ObservableCommand instances.
	 */
	function getActiveCommandsByTrigger (messageType:Class, selector:* = undefined) : Array;

	/**
	 * Returns all active commands of the specified type.
	 * If an id is specified it refers to the id the command is registered with
	 * in the Context.
	 * 
	 * @param commandType the type of the command
	 * @param id the id the command is registered with in the Context
	 * @return all matching ObservableCommand instances
	 */
	function getActiveCommandsByType (commandType:Class, id:String = null) : Array;
	
}
}
