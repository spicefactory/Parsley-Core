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

package org.spicefactory.parsley.dsl.messaging.impl {
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.MessageReceiverBuilder;

/**
 * Default implementation for the MessageReceiverBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageReceiverBuilder implements MessageReceiverBuilder, ObjectDefinitionBuilderPart {
	
	
	private var info:MessageReceiverInfo;
	private var builderPartDelegate:ObjectDefinitionBuilderPart;
	
	
	/**
	 * @private
	 */
	function DefaultMessageReceiverBuilder (delegate:ObjectDefinitionBuilderPart, info:MessageReceiverInfo) {
		builderPartDelegate = delegate;
		this.info = info;
	}

	
	/**
	 * @inheritDoc
	 */
	public function scope (name:String) : MessageReceiverBuilder {
		info.scope = name;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function type (value:Class) : MessageReceiverBuilder {
		info.type = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function selector (value:*) : MessageReceiverBuilder {
		info.selector = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function order (value:int) : MessageReceiverBuilder {
		info.order = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		builderPartDelegate.apply(target);
	}
	
	
	/**	
	 * Creates a new builder for a command status.
	 * 
	 * @param target the property to bind the status to
	 * @param config the configuration for the associated registry
	 * @return a new builder for a command status 
	 */
	public static function forCommandStatus (target:Property, config:Configuration) : DefaultMessageReceiverBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:ObjectDefinitionBuilderPart = new CommandStatusBuilderPart(target, info);
		return new DefaultMessageReceiverBuilder(builderPart, info);
	}
	
	/**	
	 * Creates a new builder for a command result handler.
	 * 
	 * @param target the method that handles the result
	 * @param config the configuration for the associated registry
	 * @return a new builder for a command result handler 
	 */
	public static function forCommandResult (target:Method, config:Configuration) : DefaultMessageReceiverBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:ObjectDefinitionBuilderPart = new CommandResultBuilderPart(target, CommandStatus.COMPLETE, info);
		return new DefaultMessageReceiverBuilder(builderPart, info);
	}
	
	/**	
	 * Creates a new builder for a command error handler.
	 * 
	 * @param target the method that handles the error
	 * @param config the configuration for the associated registry
	 * @return a new builder for a command error handler 
	 */
	public static function forCommandError (target:Method, config:Configuration) : DefaultMessageReceiverBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:ObjectDefinitionBuilderPart = new CommandResultBuilderPart(target, CommandStatus.ERROR, info);
		return new DefaultMessageReceiverBuilder(builderPart, info);
	}
	
	/**	
	 * Creates a new builder for a command complete handler.
	 * 
	 * @param target the method that handles the error
	 * @param config the configuration for the associated registry
	 * @return a new builder for a command error handler 
	 */
	public static function forCommandComplete (target:Method, config:Configuration) : DefaultMessageReceiverBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:ObjectDefinitionBuilderPart = new CommandResultBuilderPart(target, CommandStatus.COMPLETE, info, false);
		return new DefaultMessageReceiverBuilder(builderPart, info);
	}
	
	
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.messaging.command.CommandManager;
import org.spicefactory.parsley.core.messaging.command.CommandStatus;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ResolvableValue;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.impl.MessageReceiverInfo;
import org.spicefactory.parsley.processor.core.PropertyProcessor;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.messaging.MessageReceiverProcessorFactory;
import org.spicefactory.parsley.processor.messaging.receiver.CommandStatusFlag;
import org.spicefactory.parsley.processor.messaging.receiver.DefaultCommandObserver;

class CommandResultBuilderPart implements ObjectDefinitionBuilderPart {
	
	private var info:MessageReceiverInfo;
	private var method:Method;
	private var status:CommandStatus;
	private var supportsResult:Boolean;
	
	function CommandResultBuilderPart (target:Method, status:CommandStatus, info:MessageReceiverInfo, supportsResult:Boolean = true) {
		this.method = target;
		this.info = info;
		this.status = status;
		this.supportsResult = supportsResult;
	}

	public function apply (target:ObjectDefinition) : void {
		var messageType:ClassInfo = (info.type != null) ? ClassInfo.forClass(info.type, info.config.domain) : null;
		var factory:MessageReceiverFactory 
				= DefaultCommandObserver.newFactory(method.name, status, info.selector, messageType, info.order, supportsResult);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
	}
	
}

class CommandStatusBuilderPart implements ObjectDefinitionBuilderPart {
	
	private var info:MessageReceiverInfo;
	private var property:Property;
	
	function CommandStatusBuilderPart (target:Property, info:MessageReceiverInfo) {
		this.property = target;
		this.info = info;
	}

	public function apply (target:ObjectDefinition) : void {
		var messageType:ClassInfo = (info.type != null) ? ClassInfo.forClass(info.type, info.config.domain) : ClassInfo.forClass(Object);
		var manager:CommandManager = info.config.context.scopeManager.getScope(info.scope).commandManager;

		var factory:MessageReceiverFactory;
		
		factory = CommandStatusFlag.newFactory(property.name, manager, CommandStatus.EXECUTE, messageType, info.selector, int.MIN_VALUE);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
		
		factory = CommandStatusFlag.newFactory(property.name, manager, CommandStatus.COMPLETE, messageType, info.selector, int.MIN_VALUE);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
		
		factory = CommandStatusFlag.newFactory(property.name, manager, CommandStatus.ERROR, messageType, info.selector, int.MIN_VALUE);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
		
		factory = CommandStatusFlag.newFactory(property.name, manager, CommandStatus.CANCEL, messageType, info.selector, int.MIN_VALUE);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));

		target.addProcessorFactory(PropertyProcessor.newFactory(property, 
														new CommandStatusValue(manager, messageType.getClass(), info.selector)));
	}
}

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
		return manager.hasActiveCommands(messageType, selector);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{CommandStatus}";
	}	
	
}



