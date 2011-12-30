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

import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

[DefaultProperty("links")]
[XmlMapping(elementName="command")]

/**
 * Tag for a single command declared in MXML or XML configuration.
 * 
 * @author Jens Halm
 */
public class CommandTag extends AbstractCommandTag implements NestedCommandTag {
	
	
	/**
	 * The type of the command configured by this definition.
	 */
	public var type:Class = Object;
	
	[ArrayElementType("org.spicefactory.parsley.core.builder.ObjectDefinitionDecorator")]
	[ChoiceId("decorators")]
	/**
	 * The ObjectDefinitionDecorator instances added to this definition.
	 */
	public var config:Array = new Array();
	

	/**
	 * @inheritDoc
	 */
	public function resolve (registry:ObjectDefinitionRegistry) : ManagedCommandFactory {
		
		var def:DynamicObjectDefinition = registry.builders
			.forClass(type)
				.asDynamicObject()
					.decorators(this.config)
					.id(id)
					.build();
					
		return new Factory(def);
	}
	
	
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.command.impl.DefinitionBasedCommandProxy;
import org.spicefactory.parsley.core.command.ManagedCommandFactory;
import org.spicefactory.parsley.core.command.ManagedCommandProxy;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

class Factory implements ManagedCommandFactory {


	private var target:DynamicObjectDefinition;
	
	
	function Factory (target:DynamicObjectDefinition) {
		this.target = target;
	}
	
	public function get type () : ClassInfo {
		return target.type;
	}
	
	public function newInstance () : ManagedCommandProxy {
		return new DefinitionBasedCommandProxy(target);
	}
	
	
}
