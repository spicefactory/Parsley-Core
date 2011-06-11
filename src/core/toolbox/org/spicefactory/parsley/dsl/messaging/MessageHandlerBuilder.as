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
 * Builder for regular message handlers and commands.
 * 
 * @author Jens Halm
 */
public interface MessageHandlerBuilder {
	
	
	/**
	 * Sets the name of the scope this handler should be applied to.
	 * 
	 * @param name the name of the scope this handler should be applied to
	 * @return this builder instance for method chaining
	 */
	function scope (name:String) : MessageHandlerBuilder;
	
	/**
	 * Sets the type of the messages the handler wants to handle.
	 * 
	 * @param value the type of the messages the handler wants to handle
	 * @return this builder instance for method chaining
	 */
	function type (value:Class) : MessageHandlerBuilder;

	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	function selector (value:*) : MessageHandlerBuilder;
	
	/**
	 * Sets the execution order for this handler. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this handler
	 * @return this builder instance for method chaining
	 */
	function order (value:int) : MessageHandlerBuilder;
	
	/**
	 * Sets the optional list of names of properties of the message that should be used as method parameters
	 * instead passing the message itself as a parameter.
	 * 
	 * @param value list of names of properties of the message that should be used as method parameters
	 * @return this builder for method chaining
	 */
	function messageProperties (value:Array) : MessageHandlerBuilder;
	
	
}
}
