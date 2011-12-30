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

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.instantiator.ObjectWrapperInstantiator;

/**
 * Default implementation of the ObjectDefinitionBuilderFactory interface.
 * 
 * @author Jens Halm
 */
public class DefaultObjectDefinitionBuilderFactory implements ObjectDefinitionBuilderFactory {


	private var registry:ObjectDefinitionRegistry;
	private var assemblers:Array;


	/**
	 * @private
	 */
	function DefaultObjectDefinitionBuilderFactory (registry:ObjectDefinitionRegistry, assemblers:Array) {
		this.registry = registry;
		this.assemblers = assemblers;
	}

	
	/**
	 * @inheritDoc
	 */
	public function forClass (type:Class) : ObjectDefinitionBuilder {
		var info:ClassInfo = ClassInfo.forClass(type, registry.domain);
		var context:ObjectDefinitionContext = new ObjectDefinitionContext(info, registry, assemblers);
		return new DefaultObjectDefinitionBuilder(context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function forInstance (instance:Object) : ObjectDefinitionBuilder {
		var ci:ClassInfo = ClassInfo.forInstance(instance, registry.domain);
		var builder:ObjectDefinitionBuilder = forClass(ci.getClass());
		builder.instantiate(new ObjectWrapperInstantiator(instance));
		return builder;
	}
	
	
}
}
