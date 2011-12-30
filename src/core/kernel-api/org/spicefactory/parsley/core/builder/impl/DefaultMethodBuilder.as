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

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.builder.MethodBuilder;
import org.spicefactory.parsley.core.builder.MethodProcessorBuilder;
import org.spicefactory.parsley.core.processor.MethodProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.inject.processor.MethodInvocationProcessor;

/**
 * Default MethodBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultMethodBuilder implements MethodBuilder, ObjectDefinitionBuilderPart {
	
	
	private var method:Method;
	private var builder:DefaultMethodProcessorBuilder;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param method the method to configure
	 * @param context the context for this builder
	 */
	function DefaultMethodBuilder (method:Method) {
		this.method = method;
	}


	/**
	 * @inheritDoc
	 */
	public function invoke (...params): void {
		params = ParameterBuilder.processParameters(method, params);
		process(new MethodInvocationProcessor(params));
	}

	/**
	 * @inheritDoc
	 */
	public function process (processor: MethodProcessor): MethodProcessorBuilder {
		builder = new DefaultMethodProcessorBuilder(processor, method);
		return builder;
	}

	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		target.addProcessor(builder.build(target));
	}

	
}
}

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.builder.MethodProcessorBuilder;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.MethodProcessor;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.processor.impl.DefaultObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

class DefaultMethodProcessorBuilder implements MethodProcessorBuilder {


	private var method: Method;
	
	private var _minParams: int = 0;
	private var _maxParams: int = int.MAX_VALUE;
	
	private var initPhase: InitPhase = InitPhase.preInit();
	private var destroyPhase: DestroyPhase = DestroyPhase.preDestroy();
	
	private var processor: MethodProcessor;


	public function DefaultMethodProcessorBuilder (processor: MethodProcessor, method:Method) {
		this.processor = processor;
		this.method = method;
	}


	public function initIn (phase: InitPhase): MethodProcessorBuilder {
		initPhase = phase;
		return this;
	}

	public function destroyIn (phase: DestroyPhase): MethodProcessorBuilder {
		destroyPhase = phase;
		return this;
	}

	public function minParams (count: int): MethodProcessorBuilder {
		_minParams = count;
		return this;
	}

	public function maxParams (count: int): MethodProcessorBuilder {
		_maxParams = count;
		return this;
	}

	public function build (target:ObjectDefinition): ObjectProcessorConfig {
		validateMethod();
		var initializer: Function = function (processor: MethodProcessor): void {
			processor.targetMethod(method);
		};
		var singleton: Boolean = (target is SingletonObjectDefinition);
		return new DefaultObjectProcessorConfig(processor, initPhase, destroyPhase, method, singleton, initializer);
	}
	
	
	private function validateMethod (): void {
		var params: int = method.parameters.length;
		if (params < _minParams) {
			throw new IllegalStateError("Method " + method + " must at least have " + _minParams + " parameter(s)");
		}
		if (params > _maxParams) {
			throw new IllegalStateError("Method " + method + " cannot have more than " + _maxParams + " parameter(s)");
		}
	}
	
	
}
