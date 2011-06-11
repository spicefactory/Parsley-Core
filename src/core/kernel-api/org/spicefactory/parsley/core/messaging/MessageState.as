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

package org.spicefactory.parsley.core.messaging {

/**
 * Enumeration for the current state of a processed message.
 * 
 * @author Jens Halm
 */
public class MessageState {
	
	
	/**
	 * Constant for the active state. While in this state
	 * a message processor will continue to invoke all remaining receivers.
	 */
	public static const ACTIVE:MessageState = new MessageState("active");

	/**
	 * Constant for the cancelled state. When in this state no further processing
	 * of the message is possible.
	 */
	public static const CANCELLED:MessageState = new MessageState("cancelled");

	/**
	 * Constant for the suspended state. When in this state processing of message
	 * receivers is suspended, but may be resumed later by calling <code>MessageProcessor.resume()</code>
	 */
	public static const SUSPENDED:MessageState = new MessageState("suspended");
	
	/**
	 * Constant for the complete state. This state signals that processing of the
	 * message completed successfully.
	 */
	public static const COMPLETE:MessageState = new MessageState("complete");

	
	private var _key:String;
	
	/**
	 * @private
	 */
	function MessageState (key:String) {
		_key = key;
	}

	/**
	 * @private
	 */
	public function toString () : String {
		return _key;
	}
	
	
}
}
