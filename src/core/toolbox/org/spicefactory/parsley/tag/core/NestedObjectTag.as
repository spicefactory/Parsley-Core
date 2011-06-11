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
import org.spicefactory.parsley.config.NestedConfigurationElement;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.tag.model.NestedObject;

[DefaultProperty("decorators")]
[XmlMapping(elementName="object")]
/**
 * Tag that may be used for nested (inline) object definitions in MXML.
 * 
 * @author Jens Halm
 */
public class NestedObjectTag implements NestedConfigurationElement {

	
	/**
	 * The type of the object.
	 */
	public var type:Class = Object;
	
	[ArrayElementType("org.spicefactory.parsley.tag.core.ObjectDecoratorMarker")]
	[ChoiceId("decorators")]
	/**
	 * The ObjectDefinitionDecorator instances added to this definition.
	 */
	public var decorators:Array = new Array();	
	
	/**
	 * @inheritDoc
	 */
	public function resolve (config:Configuration) : Object {
		var def:DynamicObjectDefinition = config.builders
				.forClass(type)
					.asDynamicObject()
						.decorators(decorators)
						.build();
		return new NestedObject(def);
	}
	
	
}
}
