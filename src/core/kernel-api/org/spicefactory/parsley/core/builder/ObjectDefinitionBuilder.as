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

package org.spicefactory.parsley.core.builder {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.processor.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

/**
 * The core interface for applying configuration for a single object definition.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionBuilder {
	
	
	/**
	 * The type of object to be created by this builder.
	 */
	function get typeInfo () : ClassInfo;
	
	/**
	 * The registry associated with this builder.
	 */
	function get registry () : ObjectDefinitionRegistry;
	
	
	/**
	 * Allows to specify injections or simple values to be passed
	 * to the constructor when the target instance gets instantiated.
	 * 
	 * @return this builder for method chaining
	 */
	function constructorArgs (...args) : ObjectDefinitionBuilder;
	
	/**
	 * Allows to specify injections or other features for a single property
	 * 
	 * @param name the name of the property
	 * @return a builder that allows to specify injections or other features for a single property
	 */
	function property (name:String) : PropertyBuilder;
	
	/**
	 * Allows to specify injections or other features for a single method
	 * 
	 * @param name the name of the method
	 * @return a builder that allows to specify injections or other features for a single method
	 */
	function method (name:String) : MethodBuilder;

	
	/**
	 * Sets the object responsible for creating instances from this definition.
	 * 
	 * @param type the object responsible for creating instances from this definition.
	 * @return this builder for method chaining
	 */
	function instantiate (value:ObjectInstantiator) : ObjectDefinitionBuilder;
	
	/**
	 * Adds a processor for the objects configured by this definition.
	 * 
	 * @param processor the object processor to add
	 * @return a builder for configuring the processor
	 */
	function process (processor:ObjectProcessor) : ObjectProcessorBuilder
	
	/**
	 * Sets the instance that will replace (or wrap) the final object definition.
	 * This is an advanced feature. From all the builtin tags only the Factory tag
	 * uses this hook.
	 * 
	 * @param replacer the instance that will replace the final object definition
	 * @return this builder for method chaining
	 */
	function replace (replacer:ObjectDefinitionReplacer) : ObjectDefinitionBuilder;
	
	/**
	 * Sets this object as asynchronously initializing. Such an object will not be considered
	 * as fully initialized before it has thrown its complete event. Only has an effect for
	 * singleton definition.
	 * 
	 * @return a builder for asynchronous object initialization in case custom event types need to be specified
	 */
	function asyncInit () : AsyncInitBuilder;
	
	
	/**
	 * Allows to specify options for a singleton object and to build and register the final definition.
	 * 
	 * @return a builder that allows to specify options for a singleton object and to build and register the final definition
	 */
	function asSingleton () : SingletonBuilder;
	
	/**
	 * Allows to specify options for a dynamic object and to build and register the final definition.
	 * In contrast to a registered singleton, a dynamic object can spawn multiple instances from the
	 * same definition and get removed from the Context.
	 * 
	 * @return a builder that allows to specify options for a dynamic object object 
	 * and to build and register the final definition
	 */
	function asDynamicObject () : DynamicObjectBuilder;
	
	
}
}
