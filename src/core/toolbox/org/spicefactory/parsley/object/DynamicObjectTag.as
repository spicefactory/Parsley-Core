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

package org.spicefactory.parsley.object {

import org.spicefactory.parsley.config.RootConfigurationElement;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[DefaultProperty("decorators")]
[XmlMapping(elementName="dynamic-object")]
/**
 * Represents the root tag for an dynamic object definition in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class DynamicObjectTag implements RootConfigurationElement {
	
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#id
	 */
	public var id:String;
	
	/**
	 * The type of the object configured by this definition.
	 */
	public var type:Class = Object;
	
	[ArrayElementType("org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator")]
	[ChoiceId("decorators")]
	/**
	 * The ObjectDefinitionDecorator instances added to this definition.
	 */
	public var decorators:Array = new Array();
	

	/**
	 * @inheritDoc
	 */
	public function process (registry:ObjectDefinitionRegistry) : void {
		registry.builders
			.forClass(type)
				.asDynamicObject()
					.id(id)
					.decorators(decorators)
					.register();
	}
	
	
}
}
