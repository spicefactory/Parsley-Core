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

package org.spicefactory.parsley.core.messaging.command {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;

/**
 * Represents a single Command execution.
 * 
 * @author Jens Halm
 */
public interface Command {
	
	
	/**
	 * The message that triggered the Command.
	 */
	function get message () : Message;
	
	/**
	 * The return value from the Command execution.
	 */
	function get returnValue () : *;
	
	/**
	 * The current status of the command.
	 */
	function get status () : CommandStatus;
	
	/**
	 * Returns the result for the specified target type.
	 * 
	 * <p>The type is only passed to the method to allow to select
	 * amongst multiple values (like choosing between <code>ResultEvent.result</code>
	 * and the event instance itself). Implementations should not throw an Error if
	 * the type does not match, as there might be a Converter registered for the target type.</p>
	 * 
	 * <p>This method should throw an error if the current status 
	 * is <code>EXECUTE</code> or <code>CANCEL</code>.</p>
	 * 
	 * @param targetType The expected type on the target (parameter or property)
	 * @return the best match for the specified target type
	 */
	function getResult (targetType:ClassInfo) : *;
	
	/**
	 * Sets (and potentially overrides) the result of this command.
	 * When a CommandStatus is passed to this method, the status of this command will also change.
	 * This is useful in cases where a regular result must be interpreted as an error condition
	 * or vice versa. When the status changes any active processor for command observers will
	 * rewind and start processing again.
	 * 
	 * @param result the new result to set for this command
	 * @param status the new status for this command 
	 */
	function setResult (result:Object, status:CommandStatus = null) : void;
	
	/**
	 * Adds a handler function to invoke when the Command changes its status. 
	 * This may either be a successful completion, or due to cancellation or an error. 
	 * Should only be used for internal extension logic, any callback that calls
	 * back into application code should use the <code>addObserver</code> method.
	 * 
	 * @param handler the handler to invoke upon command completion
	 * @param params any additional parameters that should be passed to the handler in addition to the Command itself
	 */
	function addStatusHandler (handler:Function, ...params) : void;
	
	/**
	 * Adds an observer to be invoked when this Command changes its status.
	 * In contrast to the simple status handler functions, an observer will be executed
	 * within the regular <code>MessageRouter</code> processing together with any matching observers
	 * registered directly for the scope. This means that they will also adhere
	 * to all error handling rules configured for that scope. Therefor an observer
	 * should always be preferred over a simple status handler for any functionality 
	 * that calls back into application code.
	 * 
	 * @param observer the observer to be invoked upon command completion
	 */
	function addObserver (observer:CommandObserver) : void;
	
	/**
	 * Indicates whether at least one observer has been added directly to this command, matching the specified status.
	 * 
	 * @param status the status to check the matching commands for
	 * @return true when at least one observer has been added directly to this command, matching the specified status
	 */
	function hasObserver (status:CommandStatus) : Boolean;
	
	/**
	 * Returns the observers directly added to this command, matching the specified status.
	 * 
	 * @param status the status to return the matching commands for
	 * @return the observers directly added to this command, matching the specified status
	 */
	function getObservers (status:CommandStatus) : Array;
	
	
}
}
