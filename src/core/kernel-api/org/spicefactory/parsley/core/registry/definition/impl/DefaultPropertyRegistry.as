/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.PropertyRegistry;
import org.spicefactory.parsley.core.registry.definition.PropertyValue;
import org.spicefactory.parsley.tag.model.ObjectIdReference;
import org.spicefactory.parsley.tag.model.ObjectTypeReference;

import flash.utils.Dictionary;

[Deprecated]
/**
 * @author Jens Halm
 */
public class DefaultPropertyRegistry extends AbstractRegistry implements PropertyRegistry {


	private var properties:Dictionary = new Dictionary();
	private var targetType:ClassInfo;
	
	
	function DefaultPropertyRegistry (def:ObjectDefinition) {
		super(def);
		this.targetType = def.type;
	}

	public function addValue (name:String, value:*) : PropertyRegistry {
		checkState();
		var property:Property = getProperty(targetType, name, false, true);
		properties[name] = new PropertyValue(property, value);		
		return this;
	}
	
	public function addIdReference (name:String, id:String, required:Boolean = true) : PropertyRegistry {
		checkState();
		var property:Property = getProperty(targetType, name, false, true);
		properties[name] = new PropertyValue(property, new ObjectIdReference(id, required));		
		return this;
	}
	
	public function addTypeReference (name:String, required:Boolean = true, type:ClassInfo = null) : PropertyRegistry {
		checkState();
		var property:Property = getProperty(targetType, name, false, true);
		if (type != null && !type.isType(property.type.getClass())) {
			throw new ObjectDefinitionBuilderError("The type reference to " + type.name
					+ " is not applicable for the target type " + property.type.name + " of " + property);
		}
		type = (type == null || type.name == "*") ? property.type : type;
		properties[name] = new PropertyValue(property, new ObjectTypeReference(type, required));		
		return this;
	}
	
	private function getProperty (type:ClassInfo, name:String, readableRequired:Boolean, writableRequired:Boolean) : Property {
		var property:Property = type.getProperty(name);
		if (property == null) {
			throw new IllegalArgumentError("Property with name " + name + " does not exist in Class " + type.name);
		}
		if (readableRequired && !property.readable) {
			throw new IllegalArgumentError("Property " + name + " of Class " + type.name + " is not readable");
		}
		if (readableRequired && !property.writable) {
			throw new IllegalArgumentError("Property " + name + " of Class " + type.name + " is not writable");
		}
		return property;
	}
	
	public function removeValue (name:String) : void {
		checkState();
		delete properties[name];
	}
	
	public function getValue (name:String) : * {
		return PropertyValue(properties[name]).value;
	}
	
	public function getAll () : Array {
		var all:Array = new Array();
		for each (var pv:Object in properties) {
			all.push(pv);	
		}
		return all;
	}
	
	
}

}
