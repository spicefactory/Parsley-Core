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

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.builder.ImplicitTypeReference;
import org.spicefactory.parsley.core.builder.PropertyBuilder;
import org.spicefactory.parsley.core.builder.PropertyProcessorBuilder;
import org.spicefactory.parsley.core.builder.support.PropertySetterProcessor;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Default PropertyBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultPropertyBuilder implements PropertyBuilder, ObjectDefinitionBuilderPart {
	
	
	private var property:Property;
	
	private var builder:DefaultPropertyProcessorBuilder;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the property to configure
	 * @param context the context for this builder
	 */
	function DefaultPropertyBuilder (property:Property) {
		this.property = property;		
	}

	/**
	 * @inheritDoc
	 */
	public function value (value: *): void {
		if (value is ImplicitTypeReference) 
			ImplicitTypeReference(value).expectedType(property.type.getClass());
			
		process(new PropertySetterProcessor(value))
			.mustWrite();
	}

	/**
	 * @inheritDoc
	 */
	public function process (processor: PropertyProcessor): PropertyProcessorBuilder {
		builder = new DefaultPropertyProcessorBuilder(processor, property);
		return builder;
	}

	/**
	 * @inheritDoc
	 */
	public function apply (target: ObjectDefinition): void {
		target.addProcessor(builder.build(target));
	}

	
}
}


import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.builder.PropertyProcessorBuilder;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.impl.DefaultObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

class DefaultPropertyProcessorBuilder implements PropertyProcessorBuilder {


	private var property: Property;
	
	private var _mustRead: Boolean;
	private var _mustWrite: Boolean;
	private var _expectedType: Class;
	
	private var initPhase: InitPhase = InitPhase.preInit();
	private var destroyPhase: DestroyPhase = DestroyPhase.preDestroy();
	
	private var processor: PropertyProcessor;


	public function DefaultPropertyProcessorBuilder (processor: PropertyProcessor, property: Property) {
		this.processor = processor;
		this.property = property;
	}


	public function initIn (phase: InitPhase): PropertyProcessorBuilder {
		initPhase = phase;
		return this;
	}

	public function destroyIn (phase: DestroyPhase): PropertyProcessorBuilder {
		destroyPhase = phase;
		return this;
	}

	public function mustRead (): PropertyProcessorBuilder {
		_mustRead = true;
		return this;
	}

	public function mustWrite (): PropertyProcessorBuilder {
		_mustWrite = true;
		return this;
	}

	public function expectType (type: Class): PropertyProcessorBuilder {
		_expectedType = type;
		return this;
	}

	public function build (target:ObjectDefinition): ObjectProcessorConfig {
		var property: Property = getAndValidateProperty();
		var initializer: Function = function (processor: PropertyProcessor): void {
			processor.targetProperty(property);
		};
		var singleton: Boolean = (target is SingletonObjectDefinition);
		return new DefaultObjectProcessorConfig(processor, initPhase, destroyPhase, property, singleton, initializer);
	}
	
	
	private function getAndValidateProperty (): Property {
		if (_mustRead && !property.readable) {
			throw new IllegalStateError("Property " + property + " must be readable");
		}
		
		if (_mustWrite && !property.writable) {
			throw new IllegalStateError("Property " + property + " must be writable");
		}
		if (_expectedType && !property.type.isType(_expectedType)) {
			throw new IllegalStateError("Property " + property + " does not have the expected type " 
				+ _expectedType);
		}
		return property;
	}


	
	
}
