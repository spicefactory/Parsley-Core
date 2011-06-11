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

package org.spicefactory.parsley.core.messaging.receiver {
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * Handles errors thrown by regular message targets or interceptors.
 * 
 * @author Jens Halm
 */
public interface MessageErrorHandler extends MessageReceiver {
	
	
	/**
	 * The type of Error this handler is interested in.
	 * Like with matching message classes this works in a polymorphic way.
	 * Specifying the base Error class creates an ErrorHandler that handles
	 * all errors for a particular message type.
	 */
	function get errorType () : Class;
	
	/**
	 * Handles an error thrown by a regular message target or interceptor. 
	 * Processing further error handlers and targets will
	 * only happen if proceed is called on the specified processor.
	 * 
	 * @param processor the processor for the message
	 * @param error the error thrown by a message target
	 */
	function handleError (processor:MessageProcessor, error:Error) : void ;

	
}
}
