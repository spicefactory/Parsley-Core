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

package org.spicefactory.parsley.dsl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.dsl.core.ConstructorBuilder;
import org.spicefactory.parsley.dsl.core.DynamicObjectBuilder;
import org.spicefactory.parsley.dsl.core.EventBuilder;
import org.spicefactory.parsley.dsl.core.MethodBuilder;
import org.spicefactory.parsley.dsl.core.PropertyBuilder;
import org.spicefactory.parsley.dsl.core.SingletonBuilder;
import org.spicefactory.parsley.dsl.lifecycle.LifecycleBuilder;

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
	 * The configuration associated with this builder.
	 */
	function get config () : Configuration;
	
	
	/**
	 * Allows to specify injections or simple values for constructor arguments
	 * 
	 * @return a builder that allows to specify injections or simple values for constructor arguments
	 */
	function constructorArgs () : ConstructorBuilder;
	
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
	 * Allows to specify features for a single event type dispatched by the target object
	 * 
	 * @param name the name of the event
	 * @return a builder that allows to specify features for a single event type
	 */
	function event (name:String) : EventBuilder;
	
	/**
	 * Allows to specify custom functionality that controls object creation and lifecycle.
	 * 
	 * @return a builder that allows to specify custom functionality that controls object creation and lifecycle
	 */
	function lifecycle () : LifecycleBuilder;
	
	
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
