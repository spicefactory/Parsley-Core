/*
 * Copyright 2011 the original author or authors.
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

import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * Responsible for processing command observers. Will be passed to registered CommandObserver instances
 * which may chose to cancel or suspend and later resume the message processing.
 * 
 * @author Jens Halm
 */
public interface CommandObserverProcessor extends MessageProcessor {
	
	/**
	 * The actual command instance.
	 */
	function get command () : Object;
	
	/**
	 * The result produced by the command.
	 */
	function get result () : Object;
	
	/**
	 * The status of the command.
	 */
	function get commandStatus () : CommandStatus;
	
	/**
	 * Indicates whether this processor handles a root command or a nested command.
	 * This property is true if the command is a simple standalone command or the root
	 * command of a sequence or flow. It is flow if it is a command nested in a sequence
	 * or flow. 
	 */
	function get root () : Boolean;
	
	/**
	 * Changes the result that the command produced.
	 * Subsequent command observers (if any) will receive the new result.
	 * Observers that had already been processed will not get invoked a second time.
	 * 
	 * @param result the new result to pass to subsequent command observers
	 * @param error true if the result represents an error
	 */
	function changeResult (result:Object, error:Boolean = false) : void;
	
}
}
