/*
 * Copyright 2008-2010 the original author or authors.
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
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.SingletonObjectDefinitionWrapper;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.dsl.core.ObjectDefinitionReplacer;

/**
 * The logic for transparently replacing the definition of a factory with the definition for the actual
 * target instance produced by that factory.
 * 
 * @author Jens Halm
 */
public class FactoryDefinitionReplacer implements ObjectDefinitionReplacer {


	private var config:Configuration;
	
	private var method:Method;
	
	/**
	 * Creates a new instance.
	 * 
	 * @param method the factory method
	 * @param config the configuration for the associated registry
	 */
	function FactoryDefinitionReplacer (method:Method, config:Configuration) {
		this.method = method;
		this.config = config;
	}

	/**
	 * @inheritDoc
	 */
	public function replace (definition:ObjectDefinition) : ObjectDefinition {
		
		// Specified definition is for the factory, must be registered as a root factory, 
		// even if the original definition is for a nested object
		var factoryDefinition:SingletonObjectDefinition = new SingletonObjectDefinitionWrapper(definition);
		config.registry.registerDefinition(factoryDefinition);
		
		// Must create a new definition for the target type
		var builder:ObjectDefinitionBuilder = config.builders.forClass(method.returnType.getClass());	
		
		builder
			.lifecycle()
				.instantiator(new FactoryMethodInstantiator(factoryDefinition, method));
					
		if (definition is SingletonObjectDefinition) {
			return builder
				.asSingleton()
					.id(definition.id)
					.lazy(SingletonObjectDefinition(definition).lazy)
					.order(SingletonObjectDefinition(definition).order)
					.build();
		}
		else {
			return builder
				.asDynamicObject()
					.build();
		}
	}
	
	
}
}

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

class FactoryMethodInstantiator implements ObjectInstantiator {

	
	private var definition:ObjectDefinition;
	private var method:Method;


	function FactoryMethodInstantiator (definition:ObjectDefinition, method:Method) {
		this.definition = definition;
		this.method = method;
	}

	
	public function instantiate (target:ManagedObject) : Object {
		var factory:Object = target.context.getObject(definition.id);
		if (factory == null) {
			throw new ContextError("Unable to obtain factory of type " + definition.type.name);
		}
		var instance:Object = method.invoke(factory, []);
		if (instance == null) {
			throw new ContextError("Factory " + method + " returned null");
		}
		return instance; 
	}
	
	
}
