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
import org.spicefactory.lib.reflect.FunctionBase;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.tag.model.ObjectIdReference;
import org.spicefactory.parsley.tag.model.ObjectTypeReference;

[Deprecated]
/**
 * @author Jens Halm
 */
public class AbstractParameterRegistry extends AbstractRegistry {
	
	private var args:Array = new Array();
	private var func:FunctionBase;
	
	function AbstractParameterRegistry (func:FunctionBase, def:ObjectDefinition) {
		super(def);
		this.func = func;
	}
		
	protected function doAddValue (value:*) : void {
		checkState();
		args.push(value);
	}
	
	protected function doAddIdReference (id:String) : void {
		checkState();
		args.push(new ObjectIdReference(id, nextParamRequired()));		
	}
	
	protected function doAddTypeReference (type:ClassInfo = null) : void {
		checkState();
		if (args.length >= func.parameters.length) {
			throw new IllegalArgumentError("Cannot determine target type for parameter at index"
					+ args.length + " of " + func);
		}
		var param:Parameter = Parameter(func.parameters[args.length]);
		type = (type == null || type.name == "*") ? param.type : type;
		args.push(new ObjectTypeReference(type, nextParamRequired()));	
	}
	
	private function nextParamRequired () : Boolean {
		if (args.length >= func.parameters.length) {
			return false; // either rest param or illegal
		}
		return Parameter(func.parameters[args.length]).required;
	}
	
	public function getAt (index:uint) : * {
		return args[index];	
	}
	
	public function getAll () : Array {
		return args.concat();
	}
	
}
}
