/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.messaging {
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * Registry for receivers of messages dispatched through a MessageRouter.
 * 
 * <p>There are three types of receivers: First the regular targets like MessageHandlers and
 * MessageBindings, second interceptors which have some additional power and may cancel or suspend
 * the processing of a message and finally error handlers which are only invoked in case a regular
 * target or an interceptor threw an error.</p>
 * 
 * @author Jens Halm
 */
public interface MessageReceiverRegistry {
	
	/**
	 * Adds a regular target (like a MessageHandler or MessageBinding) to this registry.
	 * 
	 * @param target the target to add to this registry
	 */
	function addTarget (target:MessageTarget) : void;

	/**
	 * Removes a regular target (like a MessageHandler or MessageBinding) from this registry.
	 * 
	 * @param target the target to remove from this registry
	 */
	function removeTarget (target:MessageTarget) : void;
	
	/**
	 * Adds an error handler to this registry.
	 * 
	 * @param handler the error handler to add to this registry
	 */
	function addErrorHandler (handler:MessageErrorHandler) : void;

	/**
	 * Removes an error handler from this registry.
	 * 
	 * @param handler the error handler to remove from this registry
	 */
	function removeErrorHandler (handler:MessageErrorHandler) : void;

	/**
	 * Adds an observer for a matching command execution to this registry.
	 * 
	 * @param observer the observer to add to this registry
	 */
	function addCommandObserver (observer:CommandObserver) : void;

	/**
	 * Removes an observer for a matching command execution from this registry.
	 * 
	 * @param observer the observer to remove from this registry
	 */
	function removeCommandObserver (observer:CommandObserver) : void;	
	
}
}
