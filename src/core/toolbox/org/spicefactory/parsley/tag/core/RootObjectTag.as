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

package org.spicefactory.parsley.tag.core {

import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.config.RootConfigurationElement;

[DefaultProperty("decorators")]
[XmlMapping(elementName="object")]
/**
 * Represents the root object tag for an object definition in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class RootObjectTag implements RootConfigurationElement {
	
	
	/**
	 * The type of the object configured by this definition.
	 */
	public var type:Class = Object;
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#id
	 */
	public var id:String;
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#lazy
	 */
	public var lazy:Boolean = false;
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#order
	 */
	public var order:int = int.MAX_VALUE;

	[ArrayElementType("org.spicefactory.parsley.tag.core.ObjectDecoratorMarker")]
	[ChoiceId("decorators")]
	/**
	 * The ObjectDefinitionDecorator instances added to this definition.
	 */
	public var decorators:Array = new Array();
	
	
	/**
	 * @inheritDoc
	 */
	public function process (config:Configuration) : void {
		config.builders
			.forClass(type)
				.asSingleton()
					.id(id)
					.lazy(lazy)
					.order(order)
					.decorators(decorators)
					.register();
	}
	
	
}
}
