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
import org.spicefactory.parsley.comobserver.receiver.CommandStatusFlag;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.messaging.processor.PropertyReceiverProcessor;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;

/**
 * API for configuring properties that serve as a flag
 * for indicating whether any matching asynchronous command is currently active.
 * 
 * @author Jens Halm
 */
public class CommandStatus {
	
	
	private var info:MessageReceiverInfo = new MessageReceiverInfo();

	private var property:String;
	private var scopeName:String;
	private var messageType:Class = Object;
	
	
	/**
	 * @private
	 */
	function CommandStatus (property:String) {
		this.property = property;
		info.order = int.MIN_VALUE;
	}

	
	/**
	 * Sets the name of the scope this message receiver should be applied to.
	 * 
	 * @param name the name of the scope this message receiver should be applied to
	 * @return this builder instance for method chaining
	 */
	public function scope (name:String) : CommandStatus {
		scopeName = name;
		return this;
	}
	
	/**
	 * Sets the type of the messages the message receiver wants to handle.
	 * 
	 * @param value the type of the messages the message receiver wants to handle
	 * @return this builder instance for method chaining
	 */
	public function type (value:Class) : CommandStatus {
		messageType = value;
		return this;
	}
	
	/**
	 * Sets an optional selector value to be used in addition to selecting messages by type.
	 *
	 * @param value an optional selector value to be used in addition to selecting messages by type
	 * @return this builder instance for method chaining
	 */
	public function selector (value:*) : CommandStatus {
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
	public function order (value:int) : CommandStatus {
		info.order = value;
		return this;
	}
	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder) : void {
		
		info.type = ClassInfo.forClass(messageType, builder.registry.domain);
			
		var manager:CommandManager = builder.registry.context.scopeManager.getScope(scopeName).commandManager;

		var executeFactory:Function = function (): Object {
			return new CommandStatusFlag(info, MessageReceiverKind.COMMAND_EXECUTE_BY_TRIGGER, manager);
		};
		builder.property(property).process(new PropertyReceiverProcessor(executeFactory, scopeName))
			.mustWrite().expectType(Boolean);
		
		var completeFactory:Function = function (): Object {
			return new CommandStatusFlag(info, MessageReceiverKind.COMMAND_COMPLETE_BY_TRIGGER, manager);
		};
		builder.property(property).process(new PropertyReceiverProcessor(completeFactory, scopeName));
		
		var errorFactory:Function = function (): Object {
			return new CommandStatusFlag(info, MessageReceiverKind.COMMAND_ERROR_BY_TRIGGER, manager);
		};
		builder.property(property).process(new PropertyReceiverProcessor(errorFactory, scopeName));
		
		var cancelFactory:Function = function (): Object {
			return new CommandStatusFlag(info, MessageReceiverKind.COMMAND_CANCEL_BY_TRIGGER, manager);
		};
		builder.property(property).process(new PropertyReceiverProcessor(cancelFactory, scopeName));
		
		builder.property(property).value(new CommandStatusValue(manager, messageType, info.selector));
		
	}
	
	
	/**	
	 * Creates a new builder for a command status.
	 * 
	 * @param property the name of the property to bind the status to
	 * @return a new builder for a command status 
	 */
	public static function forProperty (property:String) : CommandStatus {
		return new CommandStatus(property);
	}

	
}
}

import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ResolvableValue;

class CommandStatusValue implements ResolvableValue {

	private var manager:CommandManager;
	private var messageType:Class;
	private var selector:*;

	function CommandStatusValue (manager:CommandManager, messageType:Class, selector:*) {
		this.manager = manager;
		this.messageType = messageType;
		this.selector = selector;
	}

	public function resolve (target:ManagedObject) : * {
		return manager.hasActiveCommandsForTrigger(messageType, selector);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{CommandStatus}";
	}	
	
}



