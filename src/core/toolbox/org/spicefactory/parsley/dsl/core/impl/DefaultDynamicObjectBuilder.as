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
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultDynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.IdGenerator;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.dsl.core.DynamicObjectBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;

/**
 * Default DynamicObjectBuilder implementation.
 * 
 * @author Jens Halm
 */
public class DefaultDynamicObjectBuilder implements DynamicObjectBuilder {
	
	
	private var context:ObjectDefinitionContext;
	private var builder:ObjectDefinitionBuilder;
	
	private var _decorators:Array = new Array();
	private var _id:String;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context for this builder
	 * @param builder the root builder for the target definition
	 */
	function DefaultDynamicObjectBuilder (context:ObjectDefinitionContext, builder:ObjectDefinitionBuilder) {
		this.context = context;
		this.builder = builder;
	}

	
	/**
	 * @inheritDoc
	 */
	public function id (value:String) : DynamicObjectBuilder {
		_id = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function decorators (value:Array) : DynamicObjectBuilder {
		_decorators = _decorators.concat(value);
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function build () : DynamicObjectDefinition {
		if (_id == null) _id = IdGenerator.nextObjectId;
		var def:DefaultDynamicObjectDefinition 
				= new DefaultDynamicObjectDefinition(context.targetType, _id, context.config.registry, context.parent);
		return context.processDefinition(def, _decorators, builder) as DynamicObjectDefinition;
	}
	
	/**
	 * @inheritDoc
	 */
	public function register () : DynamicObjectDefinition {
		var def:DynamicObjectDefinition = build();
		context.config.registry.registerDefinition(def);
		return def;
	}
	
	
}
}
