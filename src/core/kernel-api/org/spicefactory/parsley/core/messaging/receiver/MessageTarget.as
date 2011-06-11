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
 * Represent a regular target for a message. This interface should be implemented
 * by all general-purpose message receivers which are not interceptors or error handlers. 
 * Builtin implementations are MessageHandler, MessagePropertyHandler, MessageBinding and 
 * CommandProxy.
 * 
 * @author Jens Halm
 */
public interface MessageTarget extends MessageReceiver {
	
	
	/**
	 * Handles a message for this target.
	 * The specified processor may be used to control the message processing,
	 * like canceling or suspending a message.
	 * 
	 * @param processor the processor for the message
	 */
	function handleMessage (processor:MessageProcessor) : void ;

	
}
}
