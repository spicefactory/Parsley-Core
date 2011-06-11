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

package org.spicefactory.parsley.tag.util {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.FunctionBase;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Parameter;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.tag.model.ObjectTypeReference;

/**
 * Static utility methods for decorator implementations.
 * 
 * @author Jens Halm
 */
public class ReflectionUtil {
	
	
	/**
	 * Returns the method with the specified name for the given class.
	 * Throws an Error if no such method exists.
	 * 
	 * @param name the name of the method.
	 * @param type the class to look up the method for
	 * @return the Method instance for the specified name
	 */
	public static function getMethod (name:String, type:ClassInfo) : Method {
		var method:Method = type.getMethod(name);
		if (method == null) {
			throw new ContextError("Class " + type.name + " does not contain a method with name " + name);
		}
		return method;
	}
	
	/**
	 * Returns the property with the specified name for the given class.
	 * Throws an Error if no such property exists or if some requirements specified by the boolean parameters
	 * are not met.
	 * 
	 * @param name the name of the property
	 * @param type the class to look up the property for
	 * @param readableRequired whether the property must be readable
	 * @param writableRequired whether the property must be writable
	 * @return the Property instance for the specified name
	 */
	public static function getProperty (name:String, type:ClassInfo, 
			readableRequired:Boolean, writableRequired:Boolean) : Property {
		var property:Property = type.getProperty(name);
		if (property == null) {
			throw new IllegalArgumentError("Property with name " + name + " does not exist in Class " + type.name);
		}
		if (readableRequired && !property.readable) {
			throw new IllegalArgumentError("" + property + " is not readable");
		}
		if (writableRequired && !property.writable) {
			throw new IllegalArgumentError("" + property + " is not writable");
		}
		return property;		
	}
	
	/**
	 * Returns an Array containing an ObjectTypeReference instance for each of the
	 * parameters of the specified constructor or method.
	 * 
	 * @param target the constructor or method to process
	 * @return an Array containing an ObjectTypeReference instance for each of the
	 * parameters of the specified constructor or method
	 */
	public static function getTypeReferencesForParameters (target:FunctionBase) : Array {
		var params:Array = target.parameters;
		if (params.length == 0) {
			throw new IllegalArgumentError("Cannot inject into " + target 
					+ " as it does not have any parameters");
		}
		var refs:Array = new Array();
		for each (var param:Parameter in params) {
			refs.push(new ObjectTypeReference(param.type, param.required));
		}
		return refs;
	}
	
	
}
}
