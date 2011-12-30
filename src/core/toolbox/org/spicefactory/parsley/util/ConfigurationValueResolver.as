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

package org.spicefactory.parsley.util {

import org.spicefactory.parsley.config.NestedConfigurationElement;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

/**
 * Responsible for resolving some special tags that can be used in MXML or XML configuration
 * for specifying object references or arrays possibly containing references.
 * 
 * @author Jens Halm
 */
public class ConfigurationValueResolver {
	
	
	/**
	 * Resolves special tags for object references or inline object definitions
	 * and returns representations that can be used in object definitions.
	 * 
	 * @param value the value (tag) to resolve
	 * @param config the associated configuration
	 * @return the resolved configuration value
	 */
	public function resolveValue (value:*, registry:ObjectDefinitionRegistry) : Object {
		if (value is NestedConfigurationElement) {
			return NestedConfigurationElement(value).resolve(registry);
		}
		else {
			return value;
		}
	} 

	/**
	 * Resolves special tags for object references or inline object definitions
	 * that the specified Array possibly contains
	 * and replaces them with representations that can be used in object definitions.
	 * 
	 * @param values the Array to resolve
	 * @param config the associated configuration
	 */	
	public function resolveValues (values:Array, registry:ObjectDefinitionRegistry) : void {
		for (var i:int = 0; i < values.length; i++) {
			values[i] = resolveValue(values[i], registry);
		}
	}	


}
}
