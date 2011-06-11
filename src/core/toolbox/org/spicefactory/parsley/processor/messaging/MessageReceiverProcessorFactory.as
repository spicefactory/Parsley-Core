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

package org.spicefactory.parsley.processor.messaging {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.scope.Scope;

import flash.events.Event;

/**
 * Processor that registers and unregisters any kind of message receiver.
 * This implementation adds synchronization features for singleton definitions to make sure
 * that they do not miss messages in case the dispatching object is initialized earlier.
 * To accomplish this the processor registers a proxy receiver before the actual target 
 * object gets created.
 * 
 * @author Jens Halm
 */
public class MessageReceiverProcessorFactory implements ObjectProcessorFactory {


	private var definition:SingletonObjectDefinition;
	private var receiverFactory:MessageReceiverFactory;
	private var context:Context;
	private var scope:Scope;
	
	private var processor:MessageReceiverProcessor;

	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param definition the definition for the target object receiving the message
	 * @param factory the factory that produces new MessageReceiver instances for each target object
	 * @param context the Context the receiving object belongs to
	 * @param scopeName the name of the scope the receivers listen to
	 */
	function MessageReceiverProcessorFactory (definition:ObjectDefinition, factory:MessageReceiverFactory, 
			context:Context, scopeName:String) {
		this.receiverFactory = factory;
		this.scope = context.scopeManager.getScope(scopeName);
		this.context = context;
		if (definition is SingletonObjectDefinition) {
			this.definition = SingletonObjectDefinition(definition);
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
		}
	}
	
	private function contextConfigured (event:Event) : void {
		context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		processor = new MessageReceiverProcessor(Provider.forDefinition(definition, context), receiverFactory, scope);
		processor.createReceiver();
	}
	
	private function contextDestroyed (event:Event) : void {
		context.removeEventListener(ContextEvent.DESTROYED, contextConfigured);
		processor.removeReceiver();
	}

	/**
	 * @inheritDoc
	 */
	public function createInstance (target:ManagedObject) : ObjectProcessor {
		if (processor != null) {
			context.removeEventListener(ContextEvent.DESTROYED, contextConfigured);
			return processor;
		}
		else {
			var provider:ObjectProvider = Provider.forInstance(target.instance, target.definition.registry.domain);
			return new MessageReceiverProcessor(provider, receiverFactory, scope);
		}
	}
}
}

import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;

import flash.utils.getQualifiedClassName;

class MessageReceiverProcessor implements ObjectProcessor {


	private var receiverFactory:MessageReceiverFactory;
	private var provider:ObjectProvider;
	
	private var receiver:MessageReceiver;
	private var scope:Scope;
	
	
	function MessageReceiverProcessor (provider:ObjectProvider, factory:MessageReceiverFactory, scope:Scope) {
		this.receiverFactory = factory;
		this.scope = scope;
		this.provider = provider;
	}

	
	public function preInit () : void {
		if (!receiver) {
			createReceiver();
		}
	}
	
	public function postDestroy () : void {
		if (receiver) {
			removeReceiver();
		}
	}
		
	public function createReceiver () : void {
		receiver = receiverFactory.createReceiver(provider);
		if (receiver is MessageTarget) {
			scope.messageReceivers.addTarget(MessageTarget(receiver));
		}
		else if (receiver is CommandObserver) {
			scope.messageReceivers.addCommandObserver(CommandObserver(receiver));
		}
		else if (receiver is MessageErrorHandler) {
			scope.messageReceivers.addErrorHandler(MessageErrorHandler(receiver));
		}
		else {
			receiver = null;
			throw new ContextError("Unsupported MessageReceiver type: " + getQualifiedClassName(receiver));
		}
	}
	
	public function removeReceiver () : void {
		if (receiver is MessageTarget) {
			scope.messageReceivers.removeTarget(MessageTarget(receiver));
		}
		else if (receiver is CommandObserver) {
			scope.messageReceivers.removeCommandObserver(CommandObserver(receiver));
		}
		else if (receiver is MessageErrorHandler) {
			scope.messageReceivers.removeErrorHandler(MessageErrorHandler(receiver));
		}
		receiver = null;
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[MessageReceiver(scope=" + scope.name + ")]";
	}	
	
	
}


