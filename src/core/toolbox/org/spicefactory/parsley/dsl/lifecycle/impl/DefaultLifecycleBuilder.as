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

package org.spicefactory.parsley.dsl.lifecycle.impl {
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.dsl.core.ObjectDefinitionReplacer;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.dsl.impl.ObjectProcessorBuilderPart;
import org.spicefactory.parsley.dsl.lifecycle.AsyncInitBuilder;
import org.spicefactory.parsley.dsl.lifecycle.LifecycleBuilder;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;

/**
 * Default implementation of the LifecycleBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultLifecycleBuilder implements LifecycleBuilder {


	private var context:ObjectDefinitionContext;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context of the definition to build
	 */
	function DefaultLifecycleBuilder (context:ObjectDefinitionContext) {
		this.context = context;
	}

	/**
	 * @inheritDoc
	 */
	public function instantiator (value:ObjectInstantiator) : LifecycleBuilder {
		context.addBuilderFunction(function (target:ObjectDefinition) : void {
			target.instantiator = value;
		});
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function asyncInit () : AsyncInitBuilder {
		var builder:DefaultAsyncInitBuilder = new DefaultAsyncInitBuilder();
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function processorFactory (factory:ObjectProcessorFactory) : LifecycleBuilder {
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageReceiverFactory (factory:MessageReceiverFactory, scope:String = null) : LifecycleBuilder {
		context.addBuilderPart(new MessageReceiverFactoryBuilderPart(factory, context.config.context, scope));
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function definitionReplacer (replacer:ObjectDefinitionReplacer) : LifecycleBuilder {
		context.setDefinitionReplacer(replacer);
		return this;
	}
	
	
}
}

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;
import org.spicefactory.parsley.processor.messaging.MessageReceiverProcessorFactory;

class MessageReceiverFactoryBuilderPart implements ObjectDefinitionBuilderPart {

	private var factory:MessageReceiverFactory;
	private var context:Context;
	private var scope:String;

	function MessageReceiverFactoryBuilderPart (factory:MessageReceiverFactory, context:Context, scope:String) {
		this.factory = factory;
		this.context = context;
		this.scope = scope;
	}

	public function apply (target:ObjectDefinition) : void {
		target.addProcessorFactory(new MessageReceiverProcessorFactory(target, factory, context, scope));
	}
}
