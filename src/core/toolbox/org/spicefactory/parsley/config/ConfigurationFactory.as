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
 * Responsible for creating Configuration instances to be used by the core configuration DSL.
 * 
 * @author Jens Halm
 */
public interface ConfigurationFactory {
	
	
	/**
	 * Adds a custom assemble for decorators to this factory.
	 * Usually there is one assembler installed by default that fetches decorators
	 * for the target definition from metadata tags on the classes members.
	 * 
	 * @param assembler the assembler to add to this factory
	 */
	function addDecoratorAssembler (assembler:DecoratorAssembler) : void;
	
	/**
	 * Creates a new Configuration instance for the specified registry.
	 * 
	 * @param registry the registry to create a new Configuration instance for
	 * @return a new Configuration instance
	 */
	function createConfiguration (registry:ObjectDefinitionRegistry) : Configuration;
	
	
}
}
