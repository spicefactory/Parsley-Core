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

package org.spicefactory.parsley.core.registry {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.definition.ConstructorArgRegistry;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;
import org.spicefactory.parsley.core.registry.definition.MethodRegistry;
import org.spicefactory.parsley.core.registry.definition.PropertyRegistry;

/**
 * Represents the configuration for a single object definition.
 * The sub-interfaces <code>SingletonObjectDefinition</code> and <code>DynamicObjectDefinition</code>
 * represent the concrete definition types used in an <code>ObjectDefinitionRegistry</code>.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinition {
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#id
	 */
	function get id () : String;
	
	/**
	 * The type of the configured object.
	 */
	function get type () : ClassInfo;
	
	/**
	 * The registry this definition is associated with.
	 */
	function get registry () : ObjectDefinitionRegistry;


	/**
	 * The object responsible for creating instances from this definition.
	 */
	function get instantiator () : ObjectInstantiator;
	
	function set instantiator (value:ObjectInstantiator) : void;

	/**
	 * Adds the specified processor factory to this definition.
	 * The factory will be invoked for each new instance created from this definition,
	 * so that each processor instance created by that factory manages the configuration
	 * and state of a single instance only.
	 * 
	 * @param factory the factory to add to this definition
	 */
	function addProcessorFactory (factory:ObjectProcessorFactory) : void;
	
	/**
	 * Returns all processor factories added to this instance.
	 * Modifications on the returned Array are not reflected within the definition.
	 * The Array will contain instances of <code>ObjectProcessorFactory</code>.
	 */
	function get processorFactories () : Array;

	/**
	 * The method to invoke on the configured object after it has been fully initialized.
	 */
	function get initMethod () : String;

	function set initMethod (name:String) : void;

	/**
	 * The method to invoke on the configured object before it gets destroyed and removed from the Context.
	 */
	function get destroyMethod () : String;

	function set destroyMethod (name:String) : void;

	/**
	 * Freezes this object definition. After calling this method any attempt to modify this definition will
	 * lead to an Error.
	 */
	function freeze () : void;
	
	/**
	 * Indicates whether this definition has been frozen. When true any attempt to modify this definition will
	 * lead to an Error.
	 */	
	function get frozen () : Boolean;

	
	
	[Deprecated]
	function get constructorArgs () : ConstructorArgRegistry;
	
	[Deprecated]
	function get properties () : PropertyRegistry;
	
	[Deprecated]
	function get injectorMethods () : MethodRegistry;

	[Deprecated]
	function get objectLifecycle () : LifecycleListenerRegistry;
	
	
}

}
