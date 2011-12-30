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

package org.spicefactory.parsley.messaging.processor {

import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.processor.SingletonPreProcessor;
import org.spicefactory.parsley.core.processor.StatefulObjectProcessor;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.scope.Scope;

import flash.utils.getQualifiedClassName;

/**
 * Processor that registers and unregisters any kind of message receiver.
 * 
 * @author Jens Halm
 */
public class MessageReceiverProcessor implements StatefulObjectProcessor, SingletonPreProcessor {


	/**
	 * The factory to invoke for creating new receiver instances.
	 */
	protected var receiverFactory:Function;
	
	/**
	 * The name of the scope the receiver should get registered in.
	 */
	protected var scopeName:String;
	
	private var receiver:MessageReceiver;
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param factory the factory that produces new MessageReceiver instances for each target object
	 * @param scopeName the name of the scope the receivers listen to
	 */
	function MessageReceiverProcessor (factory:Function, scopeName:String) {
		this.receiverFactory = factory;
		this.scopeName = scopeName;
	}
	

	/**
	 * @inheritDoc
	 */
	public function preProcess (definition: SingletonObjectDefinition): void {
		var provider:ObjectProvider = Provider.forDefinition(definition);
		createReceiver(provider, definition.registry.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroyBeforeInit (definition: SingletonObjectDefinition): void {
		removeReceiver(definition.registry.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		if (!receiver) {
			var provider:ObjectProvider = Provider.forInstance(target.instance, target.definition.registry.domain);
			createReceiver(provider, target.context);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		removeReceiver(target.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulObjectProcessor {
		throw new AbstractMethodError();
	}

	private function createReceiver (provider: ObjectProvider, context: Context) : void {

		receiver = receiverFactory();
		prepareReceiver(receiver, provider);
		
		var scope: Scope = context.scopeManager.getScope(scopeName);
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
			var name:String = getQualifiedClassName(receiver);
			receiver = null;
			throw new ContextError("Unsupported MessageReceiver type: " + name);
		}
	}
	
	/**
	 * Prepares the receiver, primarily passing the ObjectProvider and potentially
	 * the target member information (e.g. Property or Method).
	 * 
	 * @param receiver the new receiver to configure
	 * @param provider the target provider that has been created for the receiver
	 */
	protected function prepareReceiver (receiver: MessageReceiver, provider: ObjectProvider): void {
		throw new AbstractMethodError();
	}
	
	private function removeReceiver (context: Context) : void {
		if (!receiver) return;
		var scope: Scope = context.scopeManager.getScope(scopeName);
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
		return "[MessageReceiver(scope=" + scopeName + ")]";
	}

	
}
}

