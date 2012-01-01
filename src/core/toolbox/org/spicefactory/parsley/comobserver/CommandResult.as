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

package org.spicefactory.parsley.comobserver {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.comobserver.receiver.DefaultCommandObserver;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.messaging.processor.MethodReceiverProcessor;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * API for configuring methods which should be invoked when
 * the result of a matching asynchronous command execution has been received.
 * 
 * @author Jens Halm
 */
public class CommandResult {
	
	
	private var info:MessageReceiverInfo = new MessageReceiverInfo();

	private var method:String;
	private var scopeName:String;
	private var messageType:Class;
	
	private var isImmediate:Boolean;
	
	
	/**
	 * @private
	 */
	function CommandResult (method:String) {
		this.method = method;
	}

	
	/**
	 * Sets the name of the scope this message receiver should be applied to.
	 * 
	 * @param name the name of the scope this message receiver should be applied to
	 * @return this builder instance for method chaining
	 */
	public function scope (name:String) : CommandResult {
		scopeName = name;
		return this;
	}
	
	/**
	 * Sets the type of the messages the message receiver wants to handle.
	 * 
	 * @param value the type of the messages the message receiver wants to handle
	 * @return this builder instance for method chaining
	 */
	public function type (value:Class) : CommandResult {
		messageType = value;
		return this;
	}
	
	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	public function selector (value:*) : CommandResult {
		info.selector = value;
		return this;
	}
	
	/**
	 * Sets the execution order for this message receiver. Will be processed in ascending order. 
	 * The default is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the execution order for this message receiver
	 * @return this builder instance for method chaining
	 */
	public function order (value:int) : CommandResult {
		info.order = value;
		return this;
	}
	
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
	public function immediate (value: Boolean): CommandResult {
		isImmediate = value;
		return this;
	}
	
	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder) : void {
		
		if (messageType) info.type = ClassInfo.forClass(messageType, builder.registry.domain);
		
		var factory:Function = function (): Object {
			return new DefaultCommandObserver(info, MessageReceiverKind.COMMAND_COMPLETE_BY_TRIGGER, true, isImmediate);
		};
		
		builder.method(method).process(new MethodReceiverProcessor(factory, scopeName));
	}
	
	/**	
	 * Creates a new builder for a command result handler.
	 * 
	 * @param method the method that handles the result
	 * @return a new builder for a command result handler 
	 */
	public static function forMethod (method:String) : CommandResult {
		return new CommandResult(method);
	}
	
	
}
}
