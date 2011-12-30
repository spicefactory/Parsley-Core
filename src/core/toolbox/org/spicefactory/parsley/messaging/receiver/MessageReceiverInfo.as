/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.messaging.receiver {


import org.spicefactory.lib.reflect.ClassInfo;

/**
 * The base configuration for a message receiver.
 * Holds only the properties common to all receivers.
 * 
 * @author Jens Halm
 */
public class MessageReceiverInfo {
	
	
	/**
	 * The type of the message the receiver listens to.
	 */
	public var type:ClassInfo;

	/**
	 * An optional selector value to be used in addition to selecting messages by type.
	 * Will be checked against the value of the property in the message marked with <code>[Selector]</code>
	 * or against the event type if the message is an event and does not have a selector property specified explicitly.
	 */
	public var selector:*;
	
	/**
	 * The execution order for this receiver. Will be processed in ascending order. 
	 * <p>The default is <code>int.MAX_VALUE</code>.</p>
	 */
	public var order:int = int.MAX_VALUE;
	
	
}
}
