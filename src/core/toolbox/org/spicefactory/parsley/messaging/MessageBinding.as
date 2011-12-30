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

package org.spicefactory.parsley.messaging {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.messaging.processor.PropertyReceiverProcessor;
import org.spicefactory.parsley.messaging.receiver.DefaultMessageBinding;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * API for defining a message binding.
 * This binds the value of a property of a managed object to the property
 * of the last matching message. Matching happens like with all other
 * message receivers based on message type and an optional selector.
 * 
 * @author Jens Halm
 */
public class MessageBinding {

	
	private var info:MessageReceiverInfo = new MessageReceiverInfo();

	private var scopeName:String;
	private var targetPropertyName:String;
	private var messagePropertyName:String;
	private var messageType:Class;
	
	
	/**
	 * @private
	 */
	function MessageBinding (targetPropertyName:String) {
		this.targetPropertyName = targetPropertyName;
	}

	/**
	 * Sets the name of the scope this binding should be applied to.
	 * 
	 * @param name the name of the scope this binding should be applied to
	 * @return this builder instance for method chaining
	 */
	public function scope (name:String) : MessageBinding {
		scopeName = name;
		return this;
	}
	
	/**
	 * Sets the type of the messages the binding wants to handle.
	 * 
	 * @param value the type of the messages the binding wants to handle
	 * @return this builder instance for method chaining
	 */
	public function type (value:Class) : MessageBinding {
		messageType = value;
		return this;
	}
	
	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	public function selector (value:*) : MessageBinding {
		info.selector = value;
		return this;
	}
	
	/**
	 * Sets the execution order for this binding. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this binding
	 * @return this builder instance for method chaining
	 */
	public function order (value:int) : MessageBinding {
		info.order = value;
		return this;
	}
	
	/**
	 * Sets the name of the property of the message type whose value should be bound to the target property.
	 * 
	 * @param value the name of the property of the message type whose value should be bound to the target property
	 * @return this builder instance for method chaining
	 */
	public function messageProperty (value:String) : MessageBinding {
		messagePropertyName = value;
		return this;
	}
	
	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder) : void {
		if (!messageType) {
			throw new ContextError("type attribute must be specified for MessageBindings");
		}
		info.type = ClassInfo.forClass(messageType, builder.registry.domain);
		
		var factory:Function = function (): Object { 
			return new DefaultMessageBinding(info, messagePropertyName);
		};
		
		builder
			.property(targetPropertyName)
			.process(new PropertyReceiverProcessor(factory, scopeName))
			.mustWrite();
	}
	
	
	/**	
	 * Creates a new builder for a message binding.
	 * 
	 * @param property the name of the target property which should be bound
	 * @return a new builder for a message binding 
	 */
	public static function forProperty (property:String) : MessageBinding {
		return new MessageBinding(property);
	}
	
	
}
}
