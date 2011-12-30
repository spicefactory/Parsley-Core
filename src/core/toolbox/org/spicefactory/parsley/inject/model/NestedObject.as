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

package org.spicefactory.parsley.inject.model {
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ResolvableValue;

/**
 * Represents an inline object reference.
 * 
 * @author Jens Halm
 */
public class NestedObject implements ResolvableValue {


	private var definition:DynamicObjectDefinition;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param definition the definition for the nested object
	 */	
	function NestedObject (definition:DynamicObjectDefinition) {
		this.definition = definition;
	}

	public function resolve (target:ManagedObject) : * {
		var child:DynamicObject = target.context.addDynamicDefinition(definition);
		target.synchronizeLifecycle(child);
		return child.instance;
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{NestedObject(type=" + definition.type + ")}";
	}	
	
	
}

}
