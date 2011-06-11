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
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.MessageHandlerBuilder;

/**
 * Default implementation for the MessageHandlerBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageHandlerBuilder implements MessageHandlerBuilder, ObjectDefinitionBuilderPart {
	
	
	private var info:MessageReceiverInfo;
	private var builderPartDelegate:MessageHandlerBuilderPartBase;
	
	
	/**
	 * @private
	 */
	function DefaultMessageHandlerBuilder (delegate:MessageHandlerBuilderPartBase, info:MessageReceiverInfo) {
		builderPartDelegate = delegate;
		this.info = info;
	}

	/**
	 * @inheritDoc
	 */	
	public function scope (name:String) : MessageHandlerBuilder {
		info.scope = name;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function type (value:Class) : MessageHandlerBuilder {
		info.type = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function selector (value:*) : MessageHandlerBuilder {
		info.selector = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function order (value:int) : MessageHandlerBuilder {
		info.order = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageProperties (value:Array) : MessageHandlerBuilder {
		builderPartDelegate.messageProperties = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		builderPartDelegate.apply(target);
	}
	
	
	/**	
	 * Creates a new builder for a command.
	 * 
	 * @param target the target method to invoke
	 * @param config the configuration for the associated registry
	 * @return a new builder for a command 
	 */
	public static function forCommand (target:Method, config:Configuration) : DefaultMessageHandlerBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:MessageHandlerBuilderPartBase = new CommandBuilderPart(target, info);
		return new DefaultMessageHandlerBuilder(builderPart, info);
	}
	
	/**	
	 * Creates a new builder for a message handler.
	 * 
	 * @param target the target method to invoke
	 * @param config the configuration for the associated registry
	 * @return a new builder for a message handler 
	 */
	public static function forMessageHandler (target:Method, config:Configuration) : DefaultMessageHandlerBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(config);
		var builderPart:MessageHandlerBuilderPartBase = new MessageHandlerBuilderPart(target, info);
		return new DefaultMessageHandlerBuilder(builderPart, info);
	}
	
	
}
}

import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.messaging.impl.MessageReceiverInfo;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.messaging.MessageReceiverProcessorFactory;
import org.spicefactory.parsley.processor.messaging.receiver.DefaultCommandTarget;
import org.spicefactory.parsley.processor.messaging.receiver.MessageHandler;

class MessageHandlerBuilderPartBase implements ObjectDefinitionBuilderPart {
	
	protected var info:MessageReceiverInfo;
	protected var method:Method;
	public var messageProperties:Array;
	
	function MessageHandlerBuilderPartBase (target:Method, info:MessageReceiverInfo) {
		this.method = target;
		this.info = info;
	}
	
	public function apply (target:ObjectDefinition) : void {
		throw new AbstractMethodError();
	}
	
}

class MessageHandlerBuilderPart extends MessageHandlerBuilderPartBase {
	
	function MessageHandlerBuilderPart (target:Method, info:MessageReceiverInfo) {
		super(target, info);
	}

	public override function apply (target:ObjectDefinition) : void {
		if (messageProperties != null && info.type == null) {
			throw new ContextError("Message type must be specified if messageProperties attribute is used");
		}
		var messageType:ClassInfo = (info.type != null) ? ClassInfo.forClass(info.type, info.config.domain) : null;
		var factory:MessageReceiverFactory 
				= MessageHandler.newFactory(method.name, info.selector, messageType, messageProperties, info.order);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
	}
	
}

class CommandBuilderPart extends MessageHandlerBuilderPartBase {
	
	function CommandBuilderPart (target:Method, info:MessageReceiverInfo) {
		super(target, info);
	}

	public override function apply (target:ObjectDefinition) : void {
		if (messageProperties != null && info.type == null) {
			throw new ContextError("Message type must be specified if messageProperties attribute is used");
		}
		var messageType:ClassInfo = (info.type != null) ? ClassInfo.forClass(info.type, info.config.domain) : null;
		var factory:MessageReceiverFactory 
				= DefaultCommandTarget.newFactory(method.name, info.selector, messageType, messageProperties, info.order);
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, info.config.context, info.scope));
	}
	
}





