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
import org.spicefactory.parsley.dsl.lifecycle.ObserveMethodBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageErrorBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageHandlerBuilder;
import org.spicefactory.parsley.dsl.messaging.MessageReceiverBuilder;

/**
 * Builder for applying configuration to a single method.
 * 
 * @author Jens Halm
 */
public interface MethodBuilder {
	
	/**
	 * Instructs the container to inject the matching object for all
	 * parameters of this method. Parameter types will be deduced
	 * by reflecting on the method's signature.
	 */
	function injectAllByType () : void;
	
	/**
	 * Adds a reference by type to another object in the registry to the list of method parameters.
	 * If the type parameter is omitted it will be deduced
	 * by reflecting on the method's signature. Using this feature requires that only one 
	 * object of a matching type is regisrered for the Context.
	 * 
	 * @param type the type of the referenced object
	 * @return this builder for method chaining
	 */
	function injectByType (type:Class = null) : MethodBuilder;

	/**
	 * Adds a reference by id to another object in the registry to the list of method parameters.
	 * 
	 * @param id the id of the referenced object
	 * @return this builder for method chaining
	 */
	function injectById (id:String) : MethodBuilder;
	
	/**
	 * Adds a definition of an object to be created at runtime to the list of method parameters.
	 * For each injection a new instance will be created from that definition.
	 * 
	 * @param definition the definition of the object
	 * @return this builder for method chaining
	 */
	function injectFromDefinition (definition:DynamicObjectDefinition) : MethodBuilder;
	
	/**
	 * Adds a value to the list of method parameters. This may be a simple value
	 * or an instance that implements <code>ResolvableValue</code> to be resolved
	 * at the time the value will be injected into the method.
	 * 
	 * @param value the value to add
	 * @return this builder for method chaining
	 */
	function value (value:*) : MethodBuilder;
	
	
	/**
	 * Configures this method as a factory method that produces the actual target
	 * instance to be made available for injection. This is equivalent of using the <code>[Factory]</code>
	 * metadata tag above the method in the class definition. The type of the target instance
	 * will be deduced by reflecting on the return type of the method. Thus feature
	 * cannot be used to create a generic factory with <code>Object</code> as the return
	 * type. In such a case you should look into writing a custom <code>RootConfigurationElement</code>.
	 */
	function factory () : void;
	
	/**
	 * Configures this method to be invoked after the object has been fully intialized.
	 * This is equivalent of using the <code>[Init]</code>
	 * metadata tag above the method in the class definition. 
	 */
	function initMethod () : void;
	
	/**
	 * Configures this method to be invoked when the object has been removed from the Context or
	 * the Context gets destroyed.
	 * This is equivalent of using the <code>[Destroy]</code>
	 * metadata tag above the method in the class definition. 
	 */
	function destroyMethod () : void;
	
	/**
	 * Configures this method as an object lifecycle observer.
	 * The builder returned by this method should be used to 
	 * specify further options for the observer.
	 * 
	 * @return a builder to specify the options for the observer
	 */
	function observe () : ObserveMethodBuilder;
	

	/**
	 * Configures this method as a command error handler.
	 * The builder returned by this method should be used to 
	 * specify further options for the command error handler.
	 * 
	 * @return a builder to specify the options for the command error handler
	 */
	function commandError () : MessageReceiverBuilder;
	
	/**
	 * Configures this method as a command result handler.
	 * The builder returned by this method should be used to 
	 * specify further options for the command result handler.
	 * 
	 * @return a builder to specify the options for the command result handler
	 */
	function commandResult () : MessageReceiverBuilder;
	
	/**
	 * Configures this method as a command complete handler.
	 * The builder returned by this method should be used to 
	 * specify further options for the command complete handler.
	 * 
	 * @return a builder to specify the options for the command complete handler
	 */
	function commandComplete () : MessageReceiverBuilder;
	
	/**
	 * Configures this method as a message error handler.
	 * The builder returned by this method should be used to 
	 * specify further options for the error handler.
	 * 
	 * @return a builder to specify the options for the message error handler
	 */
	function messageError () : MessageErrorBuilder;
	
	/**
	 * Configures this method as a message handler.
	 * The builder returned by this method should be used to 
	 * specify further options for the handler.
	 * 
	 * @return a builder to specify the options for the message handler
	 */
	function messageHandler () : MessageHandlerBuilder;
	
	
}
}
