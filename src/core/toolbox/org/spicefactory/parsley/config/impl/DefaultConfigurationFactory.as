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
import org.spicefactory.parsley.config.DecoratorAssembler;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.config.ConfigurationFactory;

/**
 * Default implementation of the ConfigurationFactory interface.
 * 
 * @author Jens Halm
 */
public class DefaultConfigurationFactory implements ConfigurationFactory {
	
	
	private var assemblers:Array = new Array();
	

	/**
	 * @inheritDoc
	 */
	public function addDecoratorAssembler (assembler:DecoratorAssembler) : void {
		assemblers.push(assembler);
	}
	
	/**
	 * @inheritDoc
	 */
	public function createConfiguration (registry:ObjectDefinitionRegistry) : Configuration {
		return new DefaultConfiguration(registry, assemblers);
	}
	
	
}
}
