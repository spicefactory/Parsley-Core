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
package org.spicefactory.parsley.inject {

import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.inject.model.ImplicitObjectTypeReference;
import org.spicefactory.parsley.inject.model.NestedObject;
import org.spicefactory.parsley.inject.model.ObjectIdReference;
import org.spicefactory.parsley.inject.model.ObjectTypeReference;

/**
 * API for defining injections to be passed to configurations
 * for property values, method invocations or constructor injection.
 * The values will be resolved at the time the value gets injected.
 * 
 * @author Jens Halm
 */
public class Inject {
	
	

	/**
	 * Specifies an injection by id.
	 * If the Context does not contain an object of the specified id 
	 * an error will be thrown.
	 * 
	 * @param id the id the dependency is configured with in the Context
	 * @return an object that can get passed to various configuration methods
	 * that accept values for setting properties or invoking methods
	 */
	public static function byId (id: String): Object {
		return new ObjectIdReference(id);
	}
	
	/**
	 * Specifies an injection by type.
	 * If the Context does not contain an object with a matching type (or subtype) 
	 * an error will be thrown.
	 * If the type parameter is omitted, the type will get deduced from the target
	 * member (constructor, property, method). This option can only be used with
	 * injection targets the container can reflect on.
	 * 
	 * @param type the id the dependency is configured with in the Context
	 * @return an object that can get passed to various configuration methods
	 * that accept values for setting properties or invoking methods
	 */
	public static function byType (type: Class = null): Object {
		return type ? new ObjectTypeReference(type) : new ImplicitObjectTypeReference();
	}
	
	/**
	 * Specifies an injection based on an existing object definition.
	 * At injection time the definition will be used to create a new instance.
	 * 
	 * @param definition the definition to use for creating the instance to inject
	 * @return an object that can get passed to various configuration methods
	 * that accept values for setting properties or invoking methods
	 */
	public static function fromDefinition (definition: DynamicObjectDefinition): Object {
		return new NestedObject(definition);
	}
	
	/**
	 * Specifies an optional injection by id.
	 * If the Context does not contain an object of the specified id 
	 * the specified default value will get injected (or nothing if omitted).
	 * 
	 * @param id the id the dependency is configured with in the Context
	 * @param defaultValue the value to inject if the dependency is not found
	 * @return an object that can get passed to various configuration methods
	 * that accept values for setting properties or invoking methods
	 */
	public static function ifIdAvailable (id: String, defaultValue: Object = null): Object {
		return new ObjectIdReference(id, false, defaultValue);
	}
	
	/**
	 * Specifies an optional injection by type.
	 * If the Context does not contain an object with a matching type (or subtype) 
	 * the specified default value will get injected (or nothing if omitted).
	 * If the type parameter is omitted, the type will get deduced from the target
	 * member (constructor, property, method). This option can only be used with
	 * injection targets the container can reflect on.
	 * 
	 * @param type the id the dependency is configured with in the Context
	 * @param defaultValue the value to inject if the dependency is not found
	 * @return an object that can get passed to various configuration methods
	 * that accept values for setting properties or invoking methods
	 */
	public static function ifTypeAvailable (type: Class = null, defaultValue: Object = null): Object {
		return type ? new ObjectTypeReference(type, false, defaultValue) : new ImplicitObjectTypeReference(false, defaultValue);
	}


}
}
