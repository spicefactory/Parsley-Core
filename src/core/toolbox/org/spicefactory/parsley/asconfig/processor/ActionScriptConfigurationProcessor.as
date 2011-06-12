/*
 * Copyright 2009-2010 the original author or authors.
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

package org.spicefactory.parsley.asconfig.processor {

import org.spicefactory.parsley.config.NestedConfigurationElement;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.util.ClassUtil;
import org.spicefactory.parsley.asconfig.ConfigurationBase;
import org.spicefactory.parsley.asconfig.metadata.DynamicObjectDefinitionMetadata;
import org.spicefactory.parsley.asconfig.metadata.InternalProperty;
import org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.Configurations;
import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.errors.ConfigurationProcessorError;
import org.spicefactory.parsley.core.errors.ConfigurationUnitError;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;

/**
 * ConfigurationProcessor implementation that processes ActionScript configuration classes.
 * May also be used for MXML configuration since those classes also compile to plain AS3 classes.
 * 
 * @author Jens Halm
 */
public class ActionScriptConfigurationProcessor implements ConfigurationProcessor {

	
	private static const log:Logger = LogContext.getLogger(ActionScriptConfigurationProcessor);

	
	private var configClasses:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param configClasses the classes that contain the ActionScript configuration
	 */
	function ActionScriptConfigurationProcessor (configClasses:Array) {
		this.configClasses = configClasses;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		var config:Configuration = Configurations.forRegistry(registry);
		var errors:Array = new Array();
		for each (var configClass:Class in configClasses) {
			try {
				
				processClass(configClass, config);
				
			}
			catch (e:Error) {
				log.error("Error processing {0}: {1}", configClass, e);
				errors.push(e);
			}
		}
		if (errors.length > 0) {
			throw new ConfigurationProcessorError(this, errors);	
		}
	}
	
	/**
	 * Processes a single configuration class.
	 * 
	 * @param configClass the configuration class to process
	 * @param config the configuration associated with this processor
	 */
	protected function processClass (configClass:Class, config:Configuration) : void {
		var ci:ClassInfo = ClassInfo.forClass(configClass, config.domain);
		var configInstance:Object = new configClass();
		
		if (configInstance is ConfigurationBase) {
			ConfigurationBase(configInstance).init(config.registry.properties);
		}

		var errors:Array = new Array();
		for each (var property:Property in ci.getProperties()) {
			try {
				if (isValidRootConfig(property)) {
							
					processProperty(property, configInstance, config);
					
				} 
			}
			catch (e:Error) {
				errors.push(e);						
			}
		}
		if (errors.length > 0) {
			throw new ConfigurationUnitError(configClass, errors);
		}
	}
	
	private function processProperty (property:Property, configClass:Object, config:Configuration) : void {
		try {
			if (property.type.isType(RootConfigurationElement)) {
				RootConfigurationElement(property.getValue(configClass)).process(config);
			}
			else {
				createDefinition(property, configClass, config);
			}
		}
		catch (e:Error) {
			log.error("Error processing {0}: {1}", property, e);
			throw new ConfigurationUnitError(property, [e]);
		}
	}
	
	private function createDefinition (property:Property, configClass:Object, config:Configuration) : void {
		var metadata:Object = getMetadata(property);
		var id:String = (metadata.id != null) ? metadata.id : property.name;
		if (metadata is ObjectDefinitionMetadata) {
			var singleton:ObjectDefinitionMetadata = ObjectDefinitionMetadata(metadata);
			
			var builder:ObjectDefinitionBuilder = config.builders.forClass(property.type.getClass());
			
			builder
				.lifecycle()
					.instantiator(new ConfigClassPropertyInstantiator(configClass, property));
			
			builder
				.asSingleton()
					.id(id)
					.lazy(singleton.lazy)
					.order(singleton.order)
					.register();
		}
		else {
			var dynBuilder:ObjectDefinitionBuilder = config.builders.forClass(property.type.getClass());
			
			dynBuilder
				.lifecycle()
					.instantiator(new ConfigClassPropertyInstantiator(configClass, property));
			
			dynBuilder
				.asDynamicObject()
					.id(id)
					.register();
		}
	}
	
	private function isValidRootConfig (property:Property) : Boolean {
		return (property.getMetadata(InternalProperty).length == 0 
				&& property.readable 
				&& !property.namespaceURI
				&& !property.type.isType(NestedConfigurationElement) 
				&& !property.type.isType(ObjectDefinitionDecorator));
	}
	
	private function getMetadata (property:Property) : Object {
		var dynMetadataArray:Array = property.getMetadata(DynamicObjectDefinitionMetadata);
		if (dynMetadataArray.length > 0) {
			return DynamicObjectDefinitionMetadata(dynMetadataArray[0]); 
		}
		var definitionMetaArray:Array = property.getMetadata(ObjectDefinitionMetadata);
		return (definitionMetaArray.length > 0) 
				? ObjectDefinitionMetadata(definitionMetaArray[0]) 
				: new ObjectDefinitionMetadata();
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		var classNames:Array = new Array();
		for each (var type:Class in configClasses) {
			classNames.push(ClassUtil.getSimpleName(type));
		}
		return "ActionScriptConfig{" + classNames.join(",") + "}";
	}
}
}

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ContainerObjectInstantiator;

class ConfigClassPropertyInstantiator implements ContainerObjectInstantiator {

	private var configClass:Object;
	private var property:Property;

	function ConfigClassPropertyInstantiator (configClass:Object, property:Property) {
		this.configClass = configClass;
		this.property = property;
	}
	
	public function instantiate (target:ManagedObject) : Object {
		return property.getValue(configClass);
	}
	
}

