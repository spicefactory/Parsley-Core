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

package org.spicefactory.parsley.core.bootstrap {
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

/**
 * Responsible for processing configuration and adding object definitions to a registry.
 * Parsley contains implementations of this interface that process MXML, XML or ActionScript configuration respectively.
 * 
 * @author Jens Halm
 */
public interface ConfigurationProcessor {
	
	/**
	 * Processes all configuration artifacts and adds object definitions to the specified registry.
	 * 
	 * @param registry the registry to process
	 */
	function processConfiguration (registry:ObjectDefinitionRegistry) : void;
	
}
}
