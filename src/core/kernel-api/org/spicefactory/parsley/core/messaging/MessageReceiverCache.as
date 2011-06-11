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
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;

/**
 * A cache of receivers for a particular message type which MessageRouter implementations use for performance optimizations.
 * 
 * @author Jens Halm
 */
public interface MessageReceiverCache {
	
	
	/**
	 * Returns the receivers for the specified receiver kind and selector value.
	 * 
	 * @param message the message to retrieve the receivers for
	 * @param kind the kind of receivers to return
	 * @return the receivers for the specified receiver kind and messag
	 */
	function getReceivers (message:Message, kind:MessageReceiverKind) : Array;
	
	/**
	 * Returns the value of the selector property of the specified message instance.
	 * 
	 * @param message the message instance
	 * @return the value of the selector property of the specified message instance
	 */
	function getSelectorValue (message:Object) : *;
		
}
}
