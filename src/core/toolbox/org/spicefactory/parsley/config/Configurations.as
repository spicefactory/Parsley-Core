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
import org.spicefactory.parsley.config.impl.DefaultConfigurationFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.metadata.MetadataDecoratorAssembler;

/**
 * Central entry point for retrieving Configuration instances for the core DSL.
 * 
 * @author Jens Halm
 */
public class Configurations {
	

	private static var _factory:ConfigurationFactory;
	
	
	/**
	 * The factory to use for creating Configuration instances.
	 * Only needs to be set explicitly when the configuration DSL must be customized,
	 * otherwise the default implementation will be used automatically.
	 */
	public static function get factory () : ConfigurationFactory {
		if (!_factory) {
			_factory = new DefaultConfigurationFactory();
			_factory.addDecoratorAssembler(new MetadataDecoratorAssembler());
		}
		return _factory;
	}
	
	public static function set factory (value:ConfigurationFactory) : void {
		_factory = value;
	}
	
	/**
	 * Retrieves the Configuration instance for the specified registry which
	 * serves as the entry point for the framework's core configuration DSL.
	 * 
	 * @param registry the registry to retrieve the configuration for
	 * @return the Configuration instance for the specified registry
	 */
	public static function forRegistry (registry:ObjectDefinitionRegistry) : Configuration {
		return factory.createConfiguration(registry);
	}
	
	
}
}
