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
 * Builder for message bindings.
 * 
 * @author Jens Halm
 */
public interface MessageBindingBuilder {
	
	
	/**
	 * Sets the name of the scope this binding should be applied to.
	 * 
	 * @param name the name of the scope this binding should be applied to
	 * @return this builder instance for method chaining
	 */
	function scope (name:String) : MessageBindingBuilder;
	
	/**
	 * Sets the type of the messages the binding wants to handle.
	 * 
	 * @param value the type of the messages the binding wants to handle
	 * @return this builder instance for method chaining
	 */
	function type (value:Class) : MessageBindingBuilder;

	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	function selector (value:*) : MessageBindingBuilder;
	
	/**
	 * Sets the execution order for this binding. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this binding
	 * @return this builder instance for method chaining
	 */
	function order (value:int) : MessageBindingBuilder;
	
	/**
	 * Sets the name of the property of the message type whose value should be bound to the target property.
	 * 
	 * @param value the name of the property of the message type whose value should be bound to the target property
	 * @return this builder instance for method chaining
	 */
	function messageProperty (value:String) : MessageBindingBuilder;
	
	
}
}
