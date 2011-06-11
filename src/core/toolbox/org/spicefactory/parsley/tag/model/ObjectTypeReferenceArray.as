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

package org.spicefactory.parsley.tag.model {
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ResolvableValue;

/**
 * Represent a reference to an object in the Parsley Context by type.
 * 
 * @author Jens Halm
 */
public class ObjectTypeReferenceArray implements ResolvableValue {


	private var type:ClassInfo;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param id the type of the referenced objects
	 */	
	function ObjectTypeReferenceArray (type:ClassInfo) {
		this.type = type;
	}

	public function resolve (target:ManagedObject) : * {
		var defs:Array = target.context.findAllDefinitionsByType(type.getClass());
		var resolved:Array = new Array();
		for each (var def:ObjectDefinition in defs) {
			resolved.push(target.resolveObjectReference(def));
		}
		return resolved;
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{ArrayInjection(type=" + type.name + ")}";
	}	
	
	
}

}
