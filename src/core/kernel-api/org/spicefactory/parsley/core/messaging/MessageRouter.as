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

import org.spicefactory.parsley.core.command.ObservableCommand;

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
	 * Processes the observers registered for the specified command and its current status.
	 * 
	 * @param command the command to process the observers for
	 * @param cache the cache of observers for the message type that triggered the command
	 * @param result the result of the command
	 * @param status the status of the command
	 */
    function observeCommand (command:ObservableCommand, cache:MessageReceiverCache) : void;
    
	
}
}
