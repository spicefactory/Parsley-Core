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

package org.spicefactory.parsley.core.registry.impl {
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

[DefaultProperty("decorators")]

[Deprecated(replacement="ObjectDefinitionRegistry.builders")]
/**
 * @author Jens Halm
 */
public class DefaultObjectDefinitionFactory implements ObjectDefinitionFactory {

	public var type:Class = Object;
	public var id:String;
	public var lazy:Boolean = false;
	public var singleton:Boolean = true;
	public var order:int = int.MAX_VALUE;
	public var decorators:Array = new Array();
	private var instantiator:ObjectInstantiator;
	
	function DefaultObjectDefinitionFactory (
			type:Class, 
			id:String = null, 
			lazy:Boolean = false, 
			singleton:Boolean = true, 
			order:int = int.MAX_VALUE, 
			instantiator:ObjectInstantiator = null) {
		this.type = type;
		this.id = id;
		this.lazy = lazy;
		this.singleton = singleton;
		this.order = order;
		this.instantiator = instantiator;
	}

	public function createRootDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		if (id == null) id = IdGenerator.nextObjectId;
		if (singleton) {
			return registry.builders
						.forSingletonDefinition(type)
						.id(id)
						.lazy(lazy)
						.order(order)
						.instantiator(instantiator)
						.decorators(decorators)
						.build();
		}
		else {
			return registry.builders
						.forDynamicDefinition(type)
						.id(id)
						.instantiator(instantiator)
						.decorators(decorators)
						.build();
		}
	}
	
	public function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		return registry.builders
					.forDynamicDefinition(type)
					.decorators(decorators)
					.build();
	}
	
}
}
