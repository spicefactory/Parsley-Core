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

package org.spicefactory.parsley.dsl.core.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.core.MethodBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.dsl.lifecycle.ObserveMethodBuilder;
import org.spicefactory.parsley.dsl.lifecycle.impl.DefaultObserveMethodBuilder;
import org.spicefactory.parsley.dsl.lifecycle.impl.FactoryDefinitionReplacer;
import org.spicefactory.parsley.dsl.messaging.MessageErrorBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageHandlerBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageReceiverBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.DefaultMessageErrorBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.DefaultMessageHandlerBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.DefaultMessageReceiverBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.MessageReceiverInfo;
import org.spicefactory.parsley.processor.core.MethodProcessor;

/**
 * Default MethodBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultMethodBuilder extends AbstractParameterBuilder implements MethodBuilder, ObjectDefinitionBuilderPart {
	
	
	private var method:Method;
	private var context:ObjectDefinitionContext;
	private var added:Boolean;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param method the method to configure
	 * @param context the context for this builder
	 */
	function DefaultMethodBuilder (method:Method, context:ObjectDefinitionContext) {
		super(method);
		this.method = method;
		this.context = context;
	}

	/**
	 * @inheritDoc
	 */
	public function injectAllByType () : void {
		addPart();
		addTypeReferences();
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectByType (type:Class = null) : MethodBuilder {
		addPart();
		var info:ClassInfo = (type == null) ? null : ClassInfo.forClass(type, context.config.domain);
		addTypeReference(info);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectById (id:String) : MethodBuilder {
		addPart();
		addIdReference(id);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectFromDefinition (definition:DynamicObjectDefinition) : MethodBuilder {
		addPart();
		addDefinition(definition);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function value (value:*) : MethodBuilder {
		addPart();
		addValue(value);
		return this;
	}
	
	private function addPart () : void {
		if (!added) {
			context.addBuilderPart(this);
			added = true;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		target.addProcessorFactory(MethodProcessor.newFactory(method, params));
	}

	/**
	 * @inheritDoc
	 */
	public function factory () : void {
		context.setDefinitionReplacer(new FactoryDefinitionReplacer(method, context.config));
	}
	
	/**
	 * @inheritDoc
	 */
	public function initMethod () : void {
		context.addBuilderFunction(function (target:ObjectDefinition) : void {
			target.initMethod = method.name;
		});
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroyMethod () : void {
		context.addBuilderFunction(function (target:ObjectDefinition) : void {
			target.destroyMethod = method.name;
		});
	}
	
	/**
	 * @inheritDoc
	 */
	public function observe () : ObserveMethodBuilder {
		var builder:DefaultObserveMethodBuilder = new DefaultObserveMethodBuilder(context, method.name);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function commandComplete () : MessageReceiverBuilder {
		var builder:DefaultMessageReceiverBuilder 
				= DefaultMessageReceiverBuilder.forCommandComplete(method, context.config);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function commandError () : MessageReceiverBuilder {
		var builder:DefaultMessageReceiverBuilder 
				= DefaultMessageReceiverBuilder.forCommandError(method, context.config);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function commandResult () : MessageReceiverBuilder {
		var builder:DefaultMessageReceiverBuilder 
				= DefaultMessageReceiverBuilder.forCommandResult(method, context.config);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageError () : MessageErrorBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(context.config);
		var builder:DefaultMessageErrorBuilder = new DefaultMessageErrorBuilder(method, info);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageHandler () : MessageHandlerBuilder {
		var builder:DefaultMessageHandlerBuilder = DefaultMessageHandlerBuilder.forMessageHandler(method, context.config);
		context.addBuilderPart(builder);
		return builder;
	}
	
	
}
}
