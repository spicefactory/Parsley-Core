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
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.core.ConstructorBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.instantiator.ConstructorInstantiator;

/**
 * Default ConstructorBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultConstructorBuilder extends AbstractParameterBuilder implements ConstructorBuilder, ObjectDefinitionBuilderPart {
	
	
	private var context:ObjectDefinitionContext;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context for this builder
	 */
	function DefaultConstructorBuilder (context:ObjectDefinitionContext) {
		super(context.targetType.getConstructor());
		this.context = context;
	}

	/**
	 * @inheritDoc
	 */
	public function injectAllByType () : void {
		addTypeReferences();
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectByType (type:Class = null) : ConstructorBuilder {
		var info:ClassInfo = (type == null) ? null : ClassInfo.forClass(type, context.config.domain);
		addTypeReference(info);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectById (id:String) : ConstructorBuilder {
		addIdReference(id);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function injectFromDefinition (definition:DynamicObjectDefinition) : ConstructorBuilder {
		addDefinition(definition);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function value (value:*) : ConstructorBuilder {
		addValue(value);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		target.instantiator = new ConstructorInstantiator(params);
	}

	
}
}
