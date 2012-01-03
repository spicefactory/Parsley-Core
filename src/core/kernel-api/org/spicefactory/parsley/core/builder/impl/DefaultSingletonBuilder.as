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

import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.SingletonBuilder;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.processor.SingletonPreProcessor;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultSingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.IdGenerator;

/**
 * Default SingletonBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultSingletonBuilder implements SingletonBuilder {
	
	
	private var context:ObjectDefinitionContext;
	private var builder:ObjectDefinitionBuilder;
	
	private var _decorators:Array = new Array();
	private var _id:String;
	private var _lazy:Boolean = false;
	private var _order:int = int.MAX_VALUE;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context for this builder
	 * @param builder the root builder for the target definition
	 */
	function DefaultSingletonBuilder (context:ObjectDefinitionContext, builder:ObjectDefinitionBuilder) {
		this.context = context;
		this.builder = builder;
	}

	
	/**
	 * @inheritDoc
	 */
	public function id (value:String) : SingletonBuilder {
		_id = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function decorators (value:Array) : SingletonBuilder {
		_decorators = _decorators.concat(value);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function lazy (value:Boolean) : SingletonBuilder {
		_lazy = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function order (value:int) : SingletonBuilder {
		_order = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function build () : SingletonObjectDefinition {
		if (_id == null) _id = IdGenerator.nextObjectId;
		var def:DefaultSingletonObjectDefinition 
				= new DefaultSingletonObjectDefinition(context.targetType, _id, context.registry, _lazy, _order);
		var result:SingletonObjectDefinition 
				= context.processDefinition(def, _decorators, builder) as SingletonObjectDefinition;
		prepareSingletonProcessors(result);
		return result;
	}
	
	private function prepareSingletonProcessors (definition: SingletonObjectDefinition): void {
		var singletonProcessors: Array;
		for each (var config: ObjectProcessorConfig in definition.processors) {
			if (config.processor is SingletonPreProcessor) {
				singletonProcessors ||= [];
				singletonProcessors.push(config);
			}
		}
		if (singletonProcessors) {
			new SingletonProcessors(singletonProcessors, definition);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function register () : SingletonObjectDefinition {
		var def:SingletonObjectDefinition = build();
		context.registry.registerDefinition(def);
		return def;
	}
	
	
}
}

import org.spicefactory.parsley.core.processor.SingletonPreProcessor;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

class SingletonProcessors {
	
	private var processors: Array;
	private var definition: SingletonObjectDefinition;
	
	function SingletonProcessors (processors: Array, definition: SingletonObjectDefinition) {
		this.processors = processors;
		this.definition = definition;
		
		definition.registry.context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
	}
	
	private function contextConfigured (event:ContextEvent) : void {
		definition.registry.context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		definition.registry.context.addEventListener(ContextEvent.INITIALIZED, contextInitialized);
		definition.registry.context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		
		for each (var config: ObjectProcessorConfig in processors) {
			SingletonPreProcessor(config.processor).preProcess(definition);
		}
	}
	
	private function contextInitialized (event:ContextEvent) : void {
		removeListeners();
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		removeListeners();
		
		// TODO - 3.1 - this timing leaves a small window where destroy and destoryBeforeInit might get called
		for each (var config: ObjectProcessorConfig in processors) {
			SingletonPreProcessor(config.processor).destroyBeforeInit(definition);
		}
	}
	
	private function removeListeners (): void {
		definition.registry.context.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		definition.registry.context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	
	
}