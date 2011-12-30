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
import org.spicefactory.parsley.messaging.processor.MethodReceiverProcessor;
import org.spicefactory.parsley.messaging.receiver.DefaultMessageHandler;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * API for defining a message handler.
 * 
 * @author Jens Halm
 */
public class MessageHandler {
	
	
	private var info:MessageReceiverInfo = new MessageReceiverInfo();

	private var method:String;
	private var scopeName:String;
	private var messageType:Class;
	
	private var _messageProperties:Array;
	
	
	/**
	 * @private
	 */
	function MessageHandler (method:String) {
		this.method = method;
	}

	/**
	 * Sets the name of the scope this handler should be applied to.
	 * 
	 * @param name the name of the scope this handler should be applied to
	 * @return this builder instance for method chaining
	 */	
	public function scope (name:String) : MessageHandler {
		scopeName = name;
		return this;
	}
	
	/**
	 * Sets the type of the messages the handler wants to handle.
	 * 
	 * @param value the type of the messages the handler wants to handle
	 * @return this builder instance for method chaining
	 */
	public function type (value:Class) : MessageHandler {
		messageType = value;
		return this;
	}
	
	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	public function selector (value:*) : MessageHandler {
		info.selector = value;
		return this;
	}
	
	/**
	 * Sets the execution order for this handler. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this handler
	 * @return this builder instance for method chaining
	 */
	public function order (value:int) : MessageHandler {
		info.order = value;
		return this;
	}
	
	/**
	 * Sets the optional list of names of properties of the message that should be used as method parameters
	 * instead passing the message itself as a parameter.
	 * 
	 * @param value list of names of properties of the message that should be used as method parameters
	 * @return this builder for method chaining
	 */
	public function messageProperties (value:Array) : MessageHandler {
		_messageProperties = value;
		return this;
	}
	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder) : void {
		if (_messageProperties && !messageType) {
			throw new ContextError("Message type must be specified if messageProperties attribute is used");
		}
		
		if (messageType) info.type = ClassInfo.forClass(messageType, builder.registry.domain);
		
		var factory:Function = function (): Object {
			return new DefaultMessageHandler(info, _messageProperties);
		};
		
		builder.method(method).process(new MethodReceiverProcessor(factory, scopeName));
	}
	
	
	/**	
	 * Creates a new builder for a message handler.
	 * 
	 * @param method the name of the target method to invoke
	 * @return a new builder for a message handler 
	 */
	public static function forMethod (method:String) : MessageHandler {
		return new MessageHandler(method);
	}
	
	
}
}
