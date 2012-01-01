/*
 * Copyright 2011 the original author or authors.
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
 
package org.spicefactory.parsley.command.tag {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.core.builder.instantiator.ObjectWrapperInstantiator;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[DefaultProperty("command")]
[XmlMapping(elementName="command-factory")]

/**
 * Represents a factory for a managed command in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class CommandFactoryTag implements RootConfigurationElement {
	
	
	/**
	 * The id the command should be registered with in the Context.
	 */
	public var id:String;
	
	/**
	 * The command to create a factory for.
	 */
	public var command:NestedCommandTag;
	

	/**
	 * @inheritDoc
	 */
	public function process (registry:ObjectDefinitionRegistry) : void {
		
		if (!command) {
			throw new IllegalStateError("No command specified for this factory");
		}
		
		var factory:ManagedCommandFactory = command.resolve(registry);
			
		registry.builders
			.forClass(ManagedCommandFactory)
			.instantiate(new ObjectWrapperInstantiator(factory))
			.asSingleton()
				.id(id)
				.register();
			
	}
	
	
}
}
