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
import org.spicefactory.parsley.core.registry.impl.IdGenerator;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultSingletonObjectDefinition;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.dsl.core.SingletonBuilder;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;

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
				= new DefaultSingletonObjectDefinition(context.targetType, _id, context.config.registry, _lazy, _order, context.parent);
		return context.processDefinition(def, _decorators, builder) as SingletonObjectDefinition;
	}
	
	/**
	 * @inheritDoc
	 */
	public function register () : SingletonObjectDefinition {
		var def:SingletonObjectDefinition = build();
		context.config.registry.registerDefinition(def);
		return def;
	}
	
	
}
}
