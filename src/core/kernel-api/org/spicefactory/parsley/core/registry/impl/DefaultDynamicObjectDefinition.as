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

package org.spicefactory.parsley.core.registry.impl {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.instantiator.ObjectWrapperInstantiator;

/**
 * Default implementation of the DynamicObjectDefinition interface.
 * 
 * @author Jens Halm
 */
public class DefaultDynamicObjectDefinition extends AbstractObjectDefinition implements DynamicObjectDefinition {

	/**
	 * Creates a new instance.
	 * 
	 * @param type the type to create a definition for
	 * @param id the id the object should be registered with
	 * @param registry the registry this definition belongs to
	 * @param parent the parent definition containing shared configuration for this definition
	 */
	function DefaultDynamicObjectDefinition (type:ClassInfo, id:String, registry:ObjectDefinitionRegistry) {
		super(type, id, registry);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function copyForInstance (instance:Object) : DynamicObjectDefinition {
		var def:DefaultDynamicObjectDefinition = new DefaultDynamicObjectDefinition(type, id, registry);
		def.populateFrom(this);
		def.instantiator = new ObjectWrapperInstantiator(instance);
		return def;
	}
	

}

}
