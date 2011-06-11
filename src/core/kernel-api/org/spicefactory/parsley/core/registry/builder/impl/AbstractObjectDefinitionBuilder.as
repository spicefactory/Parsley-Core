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
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.Configurations;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

[Deprecated(replacement="new configuration DSL")]
/**
 * @author Jens Halm
 */
public class AbstractObjectDefinitionBuilder {
	
	private var _type:ClassInfo;
	private var _registry:ObjectDefinitionRegistry;
	
	protected var decoratorList:Array = new Array();
	
	function AbstractObjectDefinitionBuilder (type:ClassInfo, registry:ObjectDefinitionRegistry) {
		_type = type;
		_registry = registry;
	}

	protected function get type () : ClassInfo {
		return _type;
	}
	
	protected function get registry () : ObjectDefinitionRegistry {
		return _registry;
	}
	
	protected function processDecorators (registry:ObjectDefinitionRegistry, definition:ObjectDefinition) : ObjectDefinition {
		var config:Configuration = Configurations.forRegistry(registry);
		var builder:ObjectDefinitionBuilder = config.builders.forClass(definition.type.getClass());
		if (definition is SingletonObjectDefinition) {
			var singleton:SingletonObjectDefinition = SingletonObjectDefinition(definition);
			if (singleton.instantiator)
					builder.lifecycle().instantiator(singleton.instantiator);
			return builder
				.asSingleton()
				.decorators(decoratorList)
				.id(singleton.id)
				.lazy(singleton.lazy)
				.order(singleton.order)
				.build();
		}
		else {
			var dynObj:DynamicObjectDefinition = DynamicObjectDefinition(definition);
			if (dynObj.instantiator)
					builder.lifecycle().instantiator(dynObj.instantiator);
			return builder
				.asDynamicObject()
				.decorators(decoratorList)
				.id(dynObj.id)
				.build();
		}
	}

}
}
