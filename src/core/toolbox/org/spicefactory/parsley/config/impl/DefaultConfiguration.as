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

package org.spicefactory.parsley.config.impl {
import org.spicefactory.parsley.dsl.impl.DefaultObjectDefinitionBuilderFactory;

import flash.system.ApplicationDomain;

import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.config.Configuration;

/**
 * Default implementation of the Configuration interface.
 * 
 * @author Jens Halm
 */
public class DefaultConfiguration implements Configuration {


	private var _registry:ObjectDefinitionRegistry;
	private var _assemblers:Array;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param registry the registry to for registering object definitions
	 * @param assemblers the assemblers to use for assembling decorators for object definitions
	 */
	function DefaultConfiguration (registry:ObjectDefinitionRegistry, assemblers:Array) {
		_registry = registry;
		_assemblers = assemblers;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get domain () : ApplicationDomain {
		return _registry.domain;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get registry () : ObjectDefinitionRegistry {
		return _registry;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get context () : Context {
		return _registry.context;
	}

	/**
	 * @inheritDoc
	 */	
	public function get builders () : ObjectDefinitionBuilderFactory {
		return new DefaultObjectDefinitionBuilderFactory(this, _assemblers);
	}

	
}
}
