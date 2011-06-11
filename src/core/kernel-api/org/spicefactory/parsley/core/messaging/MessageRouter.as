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
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;

/**
 * The central message routing facility.
 * 
 * @author Jens Halm
 */
public interface MessageRouter {
	
	/**
	 * Dispatches the specified message, processing all interceptors, handlers and bindings that have
	 * registered for that message type.
	 * 
	 * @param message the message to dispatch
	 * @param cache the cache of receivers for the message type
	 */	
	function dispatchMessage (message:Message, cache:MessageReceiverCache) : void;
  
    /**
	 * Observes the specified command and dispatches messages to registered observers
	 * when the state of the command changes.
	 * 
	 * @param command the command to observe
	 * @param cache the cache of observers for the message type that triggered the command
	 * @param status the status of the command in case it differs from the status property of the command
	 */
    function observeCommand (command:Command, cache:MessageReceiverCache, status:CommandStatus = null) : void;
    
    // TODO - 3.0 - remove the 3rd parameter
	
}
}
