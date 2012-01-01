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

package org.spicefactory.parsley.core.builder.impl {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.builder.AsyncInitBuilder;
import org.spicefactory.parsley.core.builder.DynamicObjectBuilder;
import org.spicefactory.parsley.core.builder.MethodBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionReplacer;
import org.spicefactory.parsley.core.builder.ObjectProcessorBuilder;
import org.spicefactory.parsley.core.builder.PropertyBuilder;
import org.spicefactory.parsley.core.builder.SingletonBuilder;
import org.spicefactory.parsley.core.builder.instantiator.ConstructorInstantiator;
import org.spicefactory.parsley.core.processor.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

/**
 * Default implementation of the ObjectDefinitionBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultObjectDefinitionBuilder implements ObjectDefinitionBuilder {


	private var context:ObjectDefinitionContext;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context of the definition to build
	 */
	function DefaultObjectDefinitionBuilder (context:ObjectDefinitionContext) {
		this.context = context;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get typeInfo () : ClassInfo {
		return context.targetType;
	}

	/**
	 * @inheritDoc
	 */
	public function get registry () : ObjectDefinitionRegistry {
		return context.registry;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function constructorArgs (...args) : ObjectDefinitionBuilder {
		args = ParameterBuilder.processParameters(typeInfo.getConstructor(), args);
		instantiate(new ConstructorInstantiator(args));
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function property (name:String) : PropertyBuilder {
		var property: Property = typeInfo.getProperty(name);
		if (!property) {
			throw new IllegalStateError("Property with name " + name + " does not exist in class " + typeInfo.name);
		}
		var builder: DefaultPropertyBuilder = new DefaultPropertyBuilder(property);
		context.addBuilderPart(builder);
		return builder;
	}
	
	/**
	 * @inheritDoc
	 */
	public function method (name:String) : MethodBuilder {
		var method: Method = typeInfo.getMethod(name);
		if (!method) {
			throw new IllegalStateError("Method with name " + name + " does not exist in class " + typeInfo.name);
		}
		var builder: DefaultMethodBuilder = new DefaultMethodBuilder(method);
		context.addBuilderPart(builder);
		return builder;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function instantiate (value: ObjectInstantiator): ObjectDefinitionBuilder {
		context.setInstantiator(value);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function process (processor: ObjectProcessor): ObjectProcessorBuilder {
		var builder:DefaultObjectProcessorBuilder = new DefaultObjectProcessorBuilder(processor, typeInfo);
		context.addBuilderPart(builder);
		return builder;
	}

	/**
	 * @inheritDoc
	 */
	public function replace (replacer: ObjectDefinitionReplacer): ObjectDefinitionBuilder {
		context.setDefinitionReplacer(replacer);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function asyncInit (): AsyncInitBuilder {
		var builder:DefaultAsyncInitBuilder = new DefaultAsyncInitBuilder();
		context.addBuilderPart(builder);
		return builder;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function asSingleton () : SingletonBuilder {
		return new DefaultSingletonBuilder(context, this);
	}
	
	/**
	 * @inheritDoc
	 */
	public function asDynamicObject () : DynamicObjectBuilder {
		return new DefaultDynamicObjectBuilder(context, this);
	}

	
}
}

