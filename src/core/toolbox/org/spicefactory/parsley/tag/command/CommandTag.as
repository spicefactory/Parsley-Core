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
 
package org.spicefactory.parsley.tag.command {

import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.dsl.command.DefaultManagedCommandFactory;

[DefaultProperty("links")]
[XmlMapping(elementName="command")]
/**
 * Represents the root tag for an dynamic object definition in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class CommandTag extends AbstractCommandTag implements NestedCommandTag {
	
	
	/**
	 * The type of the object configured by this definition.
	 */
	public var type:Class = Object;
	
	[ArrayElementType("org.spicefactory.parsley.config.ObjectDefinitionDecorator")]
	[ChoiceId("decorators")]
	/**
	 * The ObjectDefinitionDecorator instances added to this definition.
	 */
	public var config:Array = new Array();
	

	/**
	 * @inheritDoc
	 */
	public function resolve (config:Configuration) : ManagedCommandFactory {
		
		var def:DynamicObjectDefinition = config.builders
			.forClass(type)
				.asDynamicObject()
					.decorators(this.config)
					.build();
					
		return new DefaultManagedCommandFactory(def);
	}
	
	
}
}
