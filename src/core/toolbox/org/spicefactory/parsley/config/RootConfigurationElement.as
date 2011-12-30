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

package org.spicefactory.parsley.config {

import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
/**
 * Represent a root configuration element in MXML or XML configuration files.
 * 
 * @author Jens Halm
 */
public interface RootConfigurationElement {
	
	/**
	 * Processes this configuration tag, possilbly creating and registering object definitions.
	 * 
	 * @param registry the registry associated with this element
	 */
	function process (registry: ObjectDefinitionRegistry): void;
	
}
}
