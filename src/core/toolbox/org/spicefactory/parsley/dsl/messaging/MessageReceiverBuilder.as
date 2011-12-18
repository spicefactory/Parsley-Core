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

package org.spicefactory.parsley.dsl.messaging {

/**
 * Builder for all message receiver types that only offer the standard set
 * of attributes supported by all receivers.
 * 
 * @author Jens Halm
 */
public interface MessageReceiverBuilder {

	
	/**
	 * Sets the name of the scope this message receiver should be applied to.
	 * 
	 * @param name the name of the scope this message receiver should be applied to
	 * @return this builder instance for method chaining
	 */
	function scope (name:String) : MessageReceiverBuilder;
	
	/**
	 * Sets the type of the messages the message receiver wants to handle.
	 * 
	 * @param value the type of the messages the message receiver wants to handle
	 * @return this builder instance for method chaining
	 */
	function type (value:Class) : MessageReceiverBuilder;

	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	function selector (value:*) : MessageReceiverBuilder;
	
	/**
	 * Sets the execution order for this message receiver. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this message receiver
	 * @return this builder instance for method chaining
	 */
	function order (value: int): MessageReceiverBuilder;

	/**
	 * Indicates whether the result should be processed immediately
	 * after the command finished executing (when set to true) or after the entire
	 * sequence or flow finished (when set to false - the default).
	 * Has no effect on the execution of a single command that is not
	 * a sequence or flow.
	 * 
	 * @param value indicates whether the result should be processed immediately
	 * @return this builder instance for method chaining
	 */
	function immediate (value: Boolean): MessageReceiverBuilder;
	
	
}
}
