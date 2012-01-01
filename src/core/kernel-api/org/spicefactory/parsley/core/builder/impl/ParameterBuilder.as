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
package org.spicefactory.parsley.core.builder.impl {

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.FunctionBase;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.parsley.core.builder.ImplicitTypeReference;
import org.spicefactory.parsley.core.builder.ref.ObjectTypeReference;

/**
 * Utility class for resolving parameters of constructors and methods.
 * 
 * @author Jens Halm
 */
public class ParameterBuilder {
	
	
	/**
	 * Returns the parameters to be passed to the specified constructor or method
	 * based on the (potentially) unresolved values passed with the second argument.
	 * If the target method expects one or more parameters but the specified
	 * value array is empty the default behavior
	 * is to assume injection by type for all parameters. Otherwise the value
	 * will get processed and any implicit type reference found in the array
	 * gets notified of the required target type.
	 * 
	 * @param target the target (method or constructor) to process the parameters for
	 * @param values the potentially unresolved or empty Array of parameters
	 * @return the parameters as they should be applied to the target 
	 */
	public static function processParameters (target: FunctionBase, values: Array) : Array {
		
		if (values.length == 0) {
			return getTypeReferences(target);
		}
		
		resolveImplicitTypeReferences(target, values);
		validateParameterCount(target, values.length);
		
		return values;
	}

	private static function getTypeReferences (target: FunctionBase) : Array {
		var params:Array = target.parameters;
		var refs:Array = new Array();
		for each (var param:Parameter in params) {
			refs.push(new ObjectTypeReference(param.type.getClass(), param.required));
		}
		return refs;
	}
	
	private static function resolveImplicitTypeReferences (target: FunctionBase, values: Array) : void {
		var params: Array = target.parameters; 
		for (var i:int = 0; i < values.length; i++) {
			
			var value: Object = values[i];
			if (value is ImplicitTypeReference) {
				var param: Parameter = (i < params.length) ? params[i] : null;
				if (!param) {
					throw new IllegalArgumentError("Cannot resolve implicit type reference for parameter at index"
							+ i + " of " + target);			 
				}
				ImplicitTypeReference(value).expectedType(param.type.getClass());
			}
		}
	}
	
	private static function validateParameterCount (target: FunctionBase, count: uint): void {
		if (target.parameters.length > count) {
			var firstMissing: Parameter = target.parameters[count];
			if (firstMissing.required) {
				throw new IllegalArgumentError("Less values than the number of required parameters were provided for " + target);
			}
		}
		// we cannot reflect on rest parameters, so we ignore the case when we get more parameters than expected
	}
	
	
}
}
