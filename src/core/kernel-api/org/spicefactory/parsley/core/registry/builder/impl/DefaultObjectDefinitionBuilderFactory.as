/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.registry.builder.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.builder.DynamicObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.builder.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.core.registry.builder.SingletonObjectDefinitionBuilder;

[Deprecated(replacement="new configuration DSL")]
/**
 * @author Jens Halm
 */
public class DefaultObjectDefinitionBuilderFactory implements ObjectDefinitionBuilderFactory {

	private var registry:ObjectDefinitionRegistry;
	
	function DefaultObjectDefinitionBuilderFactory (registry:ObjectDefinitionRegistry) {
		this.registry = registry;
	}
	
	public function forSingletonDefinition (type:Class) : SingletonObjectDefinitionBuilder {
		return new DefaultSingletonObjectDefinitionBuilder(ClassInfo.forClass(type, registry.domain), registry);
	}
	
	public function forRootDefinition (type:Class) : SingletonObjectDefinitionBuilder {
		return new DefaultSingletonObjectDefinitionBuilder(ClassInfo.forClass(type, registry.domain), registry);
	}
	
	public function forDynamicDefinition (type:Class) : DynamicObjectDefinitionBuilder {
		return new DefaultDynamicObjectDefinitionBuilder(ClassInfo.forClass(type, registry.domain), registry);
	}
	
	public function forNestedDefinition (type:Class) : DynamicObjectDefinitionBuilder {
		return new DefaultDynamicObjectDefinitionBuilder(ClassInfo.forClass(type, registry.domain), registry);
	}
	
	public function forViewDefinition (type:Class) : DynamicObjectDefinitionBuilder {
		return new DefaultDynamicObjectDefinitionBuilder(ClassInfo.forClass(type, registry.domain), registry);
	}
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.builder.DynamicObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.builder.SingletonObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.builder.impl.AbstractObjectDefinitionBuilder;
import org.spicefactory.parsley.core.registry.impl.DefaultDynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultSingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.IdGenerator;

class DefaultSingletonObjectDefinitionBuilder extends AbstractObjectDefinitionBuilder implements SingletonObjectDefinitionBuilder {


	private var _singleton:Boolean = true;
	private var _id:String;
	private var _lazy:Boolean = false;
	private var _order:int = int.MAX_VALUE;
	private var _instantiator:ObjectInstantiator;

	
	function DefaultSingletonObjectDefinitionBuilder (type:ClassInfo, registry:ObjectDefinitionRegistry) {
		super(type, registry);
	}
	
	
	public function singleton (value:Boolean) : SingletonObjectDefinitionBuilder {
		_singleton = value;
		return this;
	}
	
	public function id (value:String) : SingletonObjectDefinitionBuilder {
		_id = value;
		return this;
	}
	
	public function lazy (value:Boolean) : SingletonObjectDefinitionBuilder {
		_lazy = value;
		return this;
	}
	
	public function order (value:int) : SingletonObjectDefinitionBuilder {
		_order = value;		
		return this;
	}
	
	public function instantiator (value:ObjectInstantiator) : SingletonObjectDefinitionBuilder {
		_instantiator = value;
		return this;
	}

	public function decorator (value:ObjectDefinitionDecorator) : SingletonObjectDefinitionBuilder {
		decoratorList.push(value);		
		return this;
	}
	
	public function decorators (value:Array) : SingletonObjectDefinitionBuilder {
		this.decoratorList = this.decoratorList.concat(value);		
		return this;
	}
	
	public function build () : ObjectDefinition {
		if (_id == null) _id = IdGenerator.nextObjectId;
		var def:ObjectDefinition = (_singleton) 
				? new DefaultSingletonObjectDefinition(type, _id, registry, _lazy, _order)
				: new DefaultDynamicObjectDefinition(type, _id, registry);
		def.instantiator = _instantiator;
		def = processDecorators(registry, def);
		return def;
	}
	
	public function buildAndRegister () : ObjectDefinition {
		var def:ObjectDefinition = build();
		registry.registerDefinition(def);
		return def;
	}
	
}

class DefaultDynamicObjectDefinitionBuilder extends AbstractObjectDefinitionBuilder implements DynamicObjectDefinitionBuilder {


	private var _id:String;
	private var _instantiator:ObjectInstantiator;

	
	function DefaultDynamicObjectDefinitionBuilder (type:ClassInfo, registry:ObjectDefinitionRegistry) {
		super(type, registry);
	}
	
	
	public function id (value:String) : DynamicObjectDefinitionBuilder {
		_id = value;
		return this;
	}
	
	public function instantiator (value:ObjectInstantiator) : DynamicObjectDefinitionBuilder {
		_instantiator = value;
		return this;
	}

	public function decorator (value:ObjectDefinitionDecorator) : DynamicObjectDefinitionBuilder {
		decoratorList.push(value);		
		return this;
	}
	
	public function decorators (value:Array) : DynamicObjectDefinitionBuilder {
		this.decoratorList = this.decoratorList.concat(value);		
		return this;
	}
	
	public function build () : DynamicObjectDefinition {
		if (_id == null) _id = IdGenerator.nextObjectId;
		var def:DynamicObjectDefinition = new DefaultDynamicObjectDefinition(type, _id, registry);
		def.instantiator = _instantiator;
		def = processDecorators(registry, def) as DynamicObjectDefinition;
		return def;
	}
	
	public function buildAndRegister () : DynamicObjectDefinition {
		var def:DynamicObjectDefinition = build();
		registry.registerDefinition(def);
		return def;
	}
	
}