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
import org.spicefactory.parsley.core.command.CommandObserverProcessor;
import org.spicefactory.parsley.core.command.CommandStatus;

/**
 * Represents a message receiver that gets invoked when an asnychronous command starts or finishes its execution.
 *  
 * @author Jens Halm
 */
public interface CommandObserver extends MessageReceiver {
	
	/**
	 * The status this observer is interested in. 
	 */
	function get status () : CommandStatus;
	
	/**
	 * Invoked when a matching command starts or finishes its execution.
	 * The specified processor may be used to control the processing of remaining observers,
	 * like canceling or suspending the processor.
	 * 
	 * @param processor the processor for the command observer
	 */
	function observeCommand (processor:CommandObserverProcessor) : void;
	
	
}
}
