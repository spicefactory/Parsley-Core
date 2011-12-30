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

import flash.errors.IllegalOperationError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.builder.DecoratorAssembler;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.builder.ObjectDefinitionReplacer;
import org.spicefactory.parsley.core.errors.ObjectDefinitionError;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;



/**
 * Represents the context for a single object definition build process.
 * 
 * @author Jens Halm
 */
public class ObjectDefinitionContext {


	private static var log:Logger = LogContext.getLogger(ObjectDefinitionContext);

	private var processed:Boolean;

	private var _targetType:ClassInfo;
	private var _registry:ObjectDefinitionRegistry;
	private var assemblers:Array;
	
	private var builderParts:Array = new Array();
	private var replacer:ObjectDefinitionReplacer;
	private var instantiator:ObjectInstantiator;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param targetType the type of the target object
	 * @param registry the registry the definition is associated with
	 * @param assemblers the assemblers to use to assemble the decorators for the target definition
	 */
	function ObjectDefinitionContext (targetType:ClassInfo, registry:ObjectDefinitionRegistry, assemblers:Array) {
		_targetType = targetType;
		_registry = registry;
		this.assemblers = assemblers;
	}

	/**
	 * The type of the class to be configured.
	 */
	public function get targetType () : ClassInfo {
		return _targetType;
	}

	/**
	 * The registry associated with the definition.
	 */
	public function get registry () : ObjectDefinitionRegistry {
		return _registry;
	}
	
	/**
	 * Adds a part to the builder that gets executed when building the final definition.
	 * 
	 * @param part the part to add to the builder
	 */
	public function addBuilderPart (part:ObjectDefinitionBuilderPart) : void {
		builderParts.push(part);
	}
	
	/**
	 * Sets the instantiator to apply to the target definition.
	 * 
	 * @param instantiator the instantiator to apply to the target definition
	 */
	public function setInstantiator (instantiator: ObjectInstantiator) : void {
		if (this.instantiator != null) {
			throw new IllegalStateError("Instantiator has already been set for " + targetType);
		}
		this.instantiator = instantiator;
	}
	
	/**
	 * Sets the instance that will replace (or wrap) the final object definition.
	 * This is an advanced feature. From all the builtin tags only the Factory tag
	 * uses this hook.
	 * 
	 * @param replacer the instance that will replace the final object definition
	 */	
	public function setDefinitionReplacer (replacer:ObjectDefinitionReplacer) : void {
		if (this.replacer != null) {
			throw new IllegalStateError("Replacer has already been set for " + targetType);
		}
		this.replacer = replacer;
	}
	
	/**
	 * Processes the specified definition, applying all builder parts added to this
	 * context, all decorators assembled by this context and the specified additional decorators 
	 * and finally invoking the definition replacer (if specified). If no replacer was specified
	 * this method usually should return the definition that was passed in.
	 * 
	 * @param target the target definition to process
	 * @param additionalDecorators decorators to add to the ones extracted by the standard assemblers
	 * @param builder the builder of the specified definition
	 * @return the final definition to use
	 */
	public function processDefinition (target:ObjectDefinition, additionalDecorators:Array, 
			builder:ObjectDefinitionBuilder) : ObjectDefinition {
		processDecorators(target, additionalDecorators, builder);
		applyBuilderParts(target);
		target.instantiator = instantiator;
		return applyDefinitionReplacer(target);
	}

	private function applyBuilderParts (target:ObjectDefinition) : void {
		for each (var part:ObjectDefinitionBuilderPart in builderParts) {
			part.apply(target);
		}
		builderParts = new Array();
	}
	
	private function applyDefinitionReplacer (target:ObjectDefinition) : ObjectDefinition {
		if (replacer == null) {
			return target;
		}
		var newDef:ObjectDefinition = replacer.replace(target);
		if (((newDef is SingletonObjectDefinition) && !(target is SingletonObjectDefinition))
				|| ((newDef is DynamicObjectDefinition) && !(target is DynamicObjectDefinition))) {
			throw new IllegalOperationError("Replaced definition '" + newDef 
					+ "' is not of the same type as the original '" + target + "'");		
		}
		return newDef;
	}
	
	
	/**
	 * Processes the decorators for this builder. This implementation processes all decorators obtained
	 * through the decorator assemblers registered for the core <code>Configuration</code> instance 
	 * (usually one assembler processing metadata tags)
	 * along with decorators which were explicitly added, 
	 * possibly through some additional configuration mechanism like MXML or XML.
	 * 
	 * @param definition the definition to process
	 * @param additionalDecorators the decorators to process in addition to the ones added through the assemblers
	 * @param builder the builder for the definition
	 * @return the resulting definition (possibly the same instance that was passed to this method)
	 */
	protected function processDecorators (definition:ObjectDefinition, additionalDecorators:Array, 
			builder:ObjectDefinitionBuilder) : void {
		var decorators:Array = new Array();
		if (!processed) {
			processed = true;				
			for each (var assembler:DecoratorAssembler in assemblers) {
				decorators = decorators.concat(assembler.assemble(definition.type));
			}
			decorators = decorators.concat(additionalDecorators);
		}
		else {
			decorators = additionalDecorators;
		}
		var errors:Array = new Array();
		for each (var decorator:ObjectDefinitionDecorator in decorators) {
			try {
				decorator.decorate(builder);
			}
			catch (e:Error) {
				log.error("Error applying {0}: {1}", decorator, e);
				errors.push(e);
			}
		}
		if (errors.length > 0) {
			throw new ObjectDefinitionError(definition, errors);
		} 
	}
}
}
