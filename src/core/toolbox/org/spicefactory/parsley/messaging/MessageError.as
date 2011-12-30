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
import org.spicefactory.parsley.messaging.processor.MethodReceiverProcessor;
import org.spicefactory.parsley.messaging.receiver.DefaultMessageErrorHandler;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * API for configuring methods that should handle errors that were thrown
 * by a regular message target.
 * 
 * @author Jens Halm
 */
public class MessageError {

	
	private var info:MessageReceiverInfo = new MessageReceiverInfo();

	private var method:String;
	private var scopeName:String;
	private var messageType:Class;
	
	private var _errorType:Class;
	
	
	/**
	 * @private
	 */
	function MessageError (method:String) {
		this.method = method;
	}

	/**
	 * Sets the name of the scope this error handler should be applied to.
	 * 
	 * @param name the name of the scope this error handler should be applied to
	 * @return this builder instance for method chaining
	 */
	public function scope (name:String) : MessageError {
		scopeName = name;
		return this;
	}
	
	/**
	 * Sets the type of the messages the error handler wants to handle.
	 * 
	 * @param value the type of the messages the error handler wants to handle
	 * @return this builder instance for method chaining
	 */
	public function type (value:Class) : MessageError {
		messageType = value;
		return this;
	}
	
	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	public function selector (value:*) : MessageError {
		info.selector = value;
		return this;
	}
	
	/**
	 * Sets the execution order for this error handler. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this error handler
	 * @return this builder instance for method chaining
	 */
	public function order (value:int) : MessageError {
		info.order = value;
		return this;
	}
	
	/**
	 * Sets the type of the error that this handler is interested in.
	 * The default is the top level Error class.
	 * 
	 * @param value the type of the error that this handler is interested in
	 * @return this builder instance for method chaining
	 */
	public function errorType (type:Class) : MessageError {
		_errorType = type;
		return this;
	}

	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder) : void {
		
		if (messageType) info.type = ClassInfo.forClass(messageType, builder.registry.domain);
		
		var errorTypeInfo:ClassInfo 
				= (_errorType) ? ClassInfo.forClass(_errorType, builder.registry.domain) : null;
		
		var factory:Function = function (): Object {
			return new DefaultMessageErrorHandler(info, errorTypeInfo);
		};
		
		builder.method(method).process(new MethodReceiverProcessor(factory, scopeName));
	}
	
	/**	
	 * Creates a new builder for a message error handler.
	 * 
	 * @param method the name of the target method to invoke in case of errors
	 * @return a new builder for a message error handler 
	 */
	public static function forMethod (method:String) : MessageError {
		return new MessageError(method);
	}
	
	
}
}
