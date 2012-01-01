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

package org.spicefactory.parsley.core.builder.ref {

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ResolvableValue;

/**
 * Represent a reference to an object in the Parsley Context by type.
 * 
 * @author Jens Halm
 */
public class ObjectTypeReference implements ResolvableValue {


	private var _type:Class;
	private var _required:Boolean;
	private var _defaultValue:Object;
	

	/**
	 * Creates a new instance.
	 * 
	 * @param type the type of the referenced object
	 * @param required whether this instance represents a required dependency
	 */	
	function ObjectTypeReference (type:Class, required:Boolean = true, defaultValue: Object = null) {
		_type = type;
		_required = required;
		_defaultValue = defaultValue;
	}

	/**
	 * Indicates whether this instance represents a required dependency.
	 */
	public function get required () : Boolean {
		return _required;
	}

	/**
	 * The type of the referenced object.
	 */
	public function get type () : Class {
		return _type;
	}
	
	/**
	 * Sets the type of the referenced object.
	 * May be used by subclasses that determine the expected type lazily.
	 * 
	 * @param type the type of the referenced object
	 */
	protected function setType (type: Class): void {
		_type = type;
	}
	
	public function resolve (target:ManagedObject) : * {
		if (type == Context) {
			return target.context;
		}
		var def:ObjectDefinition = target.context.findDefinitionByType(type);
		
		if (def) {
			return target.resolveObjectReference(def);
		}
		else if (!required) {
			return _defaultValue;
		}
		else {
			throw new ContextError("Required object of type " + type + " does not exist");
		}
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{Injection(type=" + type + ")}";
	}	
	
	
}

}
