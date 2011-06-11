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

package org.spicefactory.parsley.dsl.core {
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

/**
 * Builder for constructor arguments.
 * 
 * @author Jens Halm
 */
public interface ConstructorBuilder {
	
	
	/**
	 * Instructs the container to inject the matching object for all
	 * parameters of this constructor. Parameter types will be deduced
	 * by reflecting on the constructor's signature.
	 */
	function injectAllByType () : void;
	
	/**
	 * Adds a reference by type to another object in the registry to the list of constructor arguments.
	 * If the type parameter is omitted it will be deduced
	 * by reflecting on the constructor's signature. Using this feature requires that only one 
	 * object of a matching type is regisrered for the Context.
	 * 
	 * @param type the type of the referenced object
	 * @return this builder for method chaining
	 */
	function injectByType (type:Class = null) : ConstructorBuilder;

	/**
	 * Adds a reference by id to another object in the registry to the list of constructor arguments.
	 * 
	 * @param id the id of the referenced object
	 * @return this builder for method chaining
	 */
	function injectById (id:String) : ConstructorBuilder;
	
	/**
	 * Adds a definition of an object to be created at runtime to the list of constructor arguments.
	 * For each injection a new instance will be created from that definition.
	 * 
	 * @param definition the definition of the object
	 * @return this builder for method chaining
	 */
	function injectFromDefinition (definition:DynamicObjectDefinition) : ConstructorBuilder;

	/**
	 * Adds a value to the list of constructor arguments. This may be a simple value
	 * or an instance that implements <code>ResolvableValue</code> to be resolved
	 * at the time the value will be injected into the constructor.
	 * 
	 * @param value the value to add
	 * @return this builder for method chaining
	 */
	function value (value:*) : ConstructorBuilder;
	
	
}
}
