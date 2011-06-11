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
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.dsl.core.PropertyBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.dsl.impl.ObjectProcessorBuilderPart;
import org.spicefactory.parsley.dsl.messaging.MessageBindingBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageReceiverBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.DefaultMessageBindingBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.DefaultMessageReceiverBuilder;
import org.spicefactory.parsley.dsl.messaging.impl.MessageReceiverInfo;
import org.spicefactory.parsley.processor.core.PropertyProcessor;
import org.spicefactory.parsley.processor.messaging.MessageDispatcherProcessor;
import org.spicefactory.parsley.processor.resources.ResourceBindingProcessor;
import org.spicefactory.parsley.tag.model.NestedObject;
import org.spicefactory.parsley.tag.model.ObjectIdReference;
import org.spicefactory.parsley.tag.model.ObjectTypeReference;

/**
 * Default PropertyBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultPropertyBuilder implements PropertyBuilder {
	
	
	private var context:ObjectDefinitionContext;
	private var property:Property;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the property to configure
	 * @param context the context for this builder
	 */
	function DefaultPropertyBuilder (property:Property, context:ObjectDefinitionContext) {
		this.property = property;		
		this.context = context;
	}

	
	/**
	 * @inheritDoc
	 */
	public function injectByType (type:Class = null, optional:Boolean = false) : void {
		var info:ClassInfo = (type == null) ? property.type : ClassInfo.forClass(type, context.config.domain);
		var value:Object = new ObjectTypeReference(info, !optional);
		var factory:ObjectProcessorFactory = PropertyProcessor.newFactory(property, value);
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectById (id:String, optional:Boolean = false) : void {
		var factory:ObjectProcessorFactory = PropertyProcessor.newFactory(property, new ObjectIdReference(id, !optional));
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectFromDefinition (definition:DynamicObjectDefinition) : void {
		var factory:ObjectProcessorFactory = PropertyProcessor.newFactory(property, new NestedObject(definition));
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
	}
	
	/**
	 * @inheritDoc
	 */
	public function value (value:*) : void {
		var factory:ObjectProcessorFactory = PropertyProcessor.newFactory(property, value);
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageDispatcher (scope:String = null) : void {
		context.addBuilderPart(new ObjectProcessorBuilderPart(MessageDispatcherProcessor
				.newFactory(property, context.config.context.scopeManager, scope)));
	}
	
	/**
	 * @inheritDoc
	 */
	public function messageBinding () : MessageBindingBuilder {
		var info:MessageReceiverInfo = new MessageReceiverInfo(context.config);
		var builder:DefaultMessageBindingBuilder = new DefaultMessageBindingBuilder(property, info);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function commandStatus () : MessageReceiverBuilder {
		var builder:DefaultMessageReceiverBuilder 
				= DefaultMessageReceiverBuilder.forCommandStatus(property, context.config);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function resourceBinding (bundle:String, key:String) : void {
		var factory:ObjectProcessorFactory = ResourceBindingProcessor.newFactory(property, key, bundle);
		context.addBuilderPart(new ObjectProcessorBuilderPart(factory));
	}
	
	
}
}
