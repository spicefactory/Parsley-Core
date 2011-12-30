/*
 * Copyright 2011 the original author or authors.
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
import org.spicefactory.parsley.core.builder.ObjectProcessorBuilder;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.ObjectProcessor;
import org.spicefactory.parsley.core.processor.impl.DefaultObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

/**
 * Default implementation of the ObjectProcessorBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultObjectProcessorBuilder implements ObjectProcessorBuilder, ObjectDefinitionBuilderPart {


	private var type:ClassInfo;
	
	private var _expectedType: Class;
	
	private var initPhase: InitPhase = InitPhase.preInit();
	private var destroyPhase: DestroyPhase = DestroyPhase.preDestroy();
	
	private var processor: ObjectProcessor;


	/**
	 * @private
	 */
	public function DefaultObjectProcessorBuilder (processor: ObjectProcessor, type:ClassInfo) {
		this.processor = processor;
		this.type = type;
	}

	
	/**
	 * @inheritDoc
	 */
	public function initIn (phase: InitPhase): ObjectProcessorBuilder {
		initPhase = phase;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function destroyIn (phase: DestroyPhase): ObjectProcessorBuilder {
		destroyPhase = phase;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function expectType (type: Class): ObjectProcessorBuilder {
		_expectedType = type;
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function apply (target: ObjectDefinition): void {
		validateType();
		var singleton: Boolean = (target is SingletonObjectDefinition);
		target.addProcessor(new DefaultObjectProcessorConfig(processor, initPhase, destroyPhase, null, singleton));
	}
	
	
	private function validateType (): void {
		if (_expectedType && !type.isType(_expectedType)) {
			throw new IllegalStateError("Target class " + type.name + " is not of the expected type " 
				+ _expectedType);
		}
	}
	
	
}
}
