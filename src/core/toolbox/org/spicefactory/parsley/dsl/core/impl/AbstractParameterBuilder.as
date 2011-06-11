/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.dsl.core.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.FunctionBase;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.tag.model.NestedObject;
import org.spicefactory.parsley.tag.model.ObjectIdReference;
import org.spicefactory.parsley.tag.model.ObjectTypeReference;

/**
 * Base class for builders that accept parameters (constructors and methods).
 * 
 * @author Jens Halm
 */
public class AbstractParameterBuilder {
	
	
	/**
	 * The parameters for the target function.
	 */
	protected var params:Array = new Array();
	
	private var func:FunctionBase;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param func the target function
	 */
	function AbstractParameterBuilder (func:FunctionBase) {
		this.func = func;
	}
		
	/**
	 * Adds a parameter value.
	 * 
	 * @param value the parameter value to add
	 */
	protected function addValue (value:*) : void {
		params.push(value);
	}
	
	/**
	 * Adds a reference to another object in the Context by id.
	 * 
	 * @param id the id of the referenced object
	 */
	protected function addIdReference (id:String) : void {
		params.push(new ObjectIdReference(id, nextParamRequired()));		
	}
	
	/**
	 * Adds a reference to another object in the Context by type.
	 * Requires that there is only one matching object in the Context.
	 * If the type is omitted it will be deduced from the type
	 * of the parameter.
	 * 
	 * @param type the type of the referenced object
	 */
	protected function addTypeReference (type:ClassInfo = null) : void {
		if (params.length >= func.parameters.length) {
			throw new IllegalArgumentError("Cannot determine target type for parameter at index"
					+ params.length + " of " + func);
		}
		var param:Parameter = Parameter(func.parameters[params.length]);
		type = (type == null || type.name == "*") ? param.type : type;
		params.push(new ObjectTypeReference(type, nextParamRequired()));	
	}
	
	/**
	 * Adds a definition of an object to be created at runtime.
	 * For each injection a new instance will be created from that definition.
	 * 
	 * @param definition the definition of the object
	 */
	protected function addDefinition (definition:DynamicObjectDefinition) : void {
		params.push(new NestedObject(definition));
	}
	
	/**
	 * Adds references to other objects in the Context by type for all remaining
	 * parameters of the target function.
	 */
	protected function addTypeReferences () : void {
		if (params.length >= func.parameters.length) {
			throw IllegalStateError("ParameterBuilder for " + func + " already contains values for all paramerers");
		}
		for (var i:int = params.length; i < func.parameters.length; i++) {
			var param:Parameter = Parameter(func.parameters[i]);
			params.push(new ObjectTypeReference(param.type, param.required));	
		}
	}
	
	private function nextParamRequired () : Boolean {
		if (params.length >= func.parameters.length) {
			return false; // either rest param or illegal
		}
		return Parameter(func.parameters[params.length]).required;
	}
	
	
}
}
