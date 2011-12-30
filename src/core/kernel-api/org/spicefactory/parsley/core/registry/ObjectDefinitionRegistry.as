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

import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.core.context.Context;


/**
 * Dispatched when configuration for this registry has been frozen.
 * After this event has been dispatched any attempt to modify this registry or any
 * of the definitions it contains will lead to an Error.
 * 
 * @eventType org.spicefactory.parsley.core.events.ObjectDefinitionRegistryEvent.FROZEN
 */
[Event(name="frozen", type="org.spicefactory.parsley.core.events.ObjectDefinitionRegistryEvent")]

/**
 * A registry for object definitions.
 * 
 * <p>All builtin <code>Context</code> implementations use such a registry internally.</p>
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionRegistry extends IEventDispatcher {
	
	
	/**
	 * The ApplicationDomain to use for reflection.
	 */
	function get domain () : ApplicationDomain;

	/**
	 * Properties that may be used to build or process ObjectDefinitions.
	 */
	function get properties () : ConfigurationProperties;
	
	/**
	 * The Context associated with this registry.
	 * During processing of ObjectDefinitions the <code>configured</code> property of the Context
	 * is still false and any attempt to fetch objects from the Context will lead
	 * to an Error. It is primarily exposed in case an extension wants to keep
	 * a reference to the Context for later use.
	 */
	function get context () : Context;
	
	/**
	 * A factory for obtaining builders for object definitions.
	 */
	function get builders () : ObjectDefinitionBuilderFactory;
	
	
	/**
	 * Returns the number of definitions in this registry that match the specified type.
	 * If the type parameter is omitted the number of all definitions in this registry will be returned.
	 * 
	 * @param type the type to check for matches
	 * @return the number of definitions in this registry that match the specified type
	 */
	function getDefinitionCount (type:Class = null) : uint;

	/**
	 * Returns the ids of the definitions in this registry that match the specified type.
	 * If the type parameter is omitted the ids of all definitions in this registry will be returned.
	 * 
	 * @param type the type to check for matches
	 * @return the ids of the definitions in this registry that match the specified type
	 */
	function getDefinitionIds (type:Class = null) : Array;

	
	/**
	 * Checks whether this registry contains a definition with the specified id.
	 * 
	 * @param id the id to check
	 * @return true if this registry contains an definition with the specified id  
	 */
	function containsDefinition (id:String) : Boolean;


	/**
	 * Returns the definition with the specified id or null if no such definition exists.
	 * 
	 * @param id the id of the definition
	 * @return the definition with the specified id
	 */
	function getDefinition (id:String) : ObjectDefinition;
	
	/**
	 * Returns the definition for the specified type or null if no such definition exists.
	 * This method will throw an Error if it finds more than one match.
	 * 
	 * @param type the type for which the definition should be returned
	 * @return the definition for the specified type
	 */
	function getDefinitionByType (type:Class) : ObjectDefinition;
	
	/**
	 * Returns all definitions that match the specified type. This includes subclasses or objects implementing
	 * the interface in case the type parmeter is an interface. When no match is found an empty Array will be returned.
	 * 
	 * @param type the type for which all definitions should be returned
	 * @return all definitions that match the specified type
	 */
	function getAllDefinitionsByType (type:Class) : Array;


	/**
	 * Registers an object definition with this registry.
	 * 
	 * @param definition the definition to add to this registry
	 */
	function registerDefinition (definition:ObjectDefinition) : void;	
	
	/**
	 * Unregisters an object definition from this registry.
	 *
  	 * @param definition the definition to remove from this registry
	 */
	function unregisterDefinition (definition:ObjectDefinition) : void;
	
	
	/**
	 * Freezes this registry. After calling this method any attempt to modify this registry or any
	 * of the definitions it contains will lead to an Error.
	 */
	function freeze () : void;
	
	/**
	 * Indicates whether this registry has been frozen. When true any attempt to modify this registry or any
	 * of the definitions it contains will lead to an Error.
	 */	
	function get frozen () : Boolean;
	

	
	
}

}
