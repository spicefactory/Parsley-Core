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
import org.spicefactory.parsley.dsl.messaging.MessageBindingBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageReceiverBuilder;

/**
 * Builder for applying configuration to a single property.
 * 
 * @author Jens Halm
 */
public interface PropertyBuilder {
	
	/**
	 * Sets a reference by type to another object in the registry to be injected into this property.
	 * If the type parameter is omitted it will be deduced
	 * by reflecting on the property type. Using this feature requires that only one 
	 * object of a matching type is regisrered for the Context.
	 * 
	 * @param type the type of the referenced object
	 * @return this builder for method chaining
	 */
	function injectByType (type:Class = null, optional:Boolean = false) : void;

	/**
	 * Sets a reference by id to another object in the registry to be injected into this property.
	 * 
	 * @param id the id of the referenced object
	 * @return this builder for method chaining
	 */
	function injectById (id:String, optional:Boolean = false) : void;

	/**
	 * Adds a definition of an object to be created at runtime to the list of constructor arguments.
	 * For each injection a new instance will be created from that definition.
	 * 
	 * @param definition the definition of the object
	 * @return this builder for method chaining
	 */
	function injectFromDefinition (definition:DynamicObjectDefinition) : void;
	
	/**
	 * Sets the value of this property. This may be a simple value
	 * or an instance that implements <code>ResolvableValue</code> to be resolved
	 * at the time the value will be injected into the method.
	 * 
	 * @param value the property value
	 * @return this builder for method chaining
	 */
	function value (value:*) : void;
	
	/**
	 * Instructs the framework to inject a message dispatcher function into
	 * this property. If the scope paremeter is omitted, which is the preferrable
	 * option in most cases, then the messages will be dispatched through all scopes
	 * available for the Context the configured object belongs to
	 * 
	 * @param scope the scope to dispatch messages through
	 */
	function messageDispatcher (scope:String = null) : void;
	
	/**
	 * Sets this propety as the target for a message binding.
	 * The builder returned by this method should be used to 
	 * specify further options of the binding.
	 * 
	 * @return a builder to specify the options for the message binding
	 */
	function messageBinding () : MessageBindingBuilder;
	
	/**
	 * Sets this propety as the target for a binding to a command status.
	 * The builder returned by this method should be used to 
	 * specify further options of the binding.
	 * 
	 * @return a builder to specify the options for the command status binding
	 */
	function commandStatus () : MessageReceiverBuilder;
	
	/**
	 * Sets this propety as the target for a binding to a resource.
	 * The builder returned by this method should be used to 
	 * specify further options of the binding, like bundle and resource name.
	 * 
	 * @return a builder to specify the options for the resource binding
	 */
	function resourceBinding (bundle:String, key:String) : void;	
	
	
}
}
