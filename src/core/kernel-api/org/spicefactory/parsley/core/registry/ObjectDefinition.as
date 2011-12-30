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
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;

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
	 * Returns the attribute for the specified key or null if no such attribute exists.
	 * 
	 * @param key the key to return the value for
	 * @return the attribute for the specified key or null if no such attribute exists
	 */
	function getAttribute (key:Object) : Object;
    
    /**
     * Sets the attribute for the specified key and value.
     * This hook might be used in rare cases where one ObjectProcessor might set values
     * another processor might need to access to perform its task. Most processors
     * should only have self-contained logic.
     * It is recommended to use Class instances as keys and not Strings to avoid
     * naming conflicts.
     * 
     * @param key the key of the attribute
     * @param value the value of the attribute
     */
    function setAttribute (key:Object, value:Object) : void;
    
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
	 * Adds the specified processor to this definition.
	 * The processor will get invoked for each new instance created from this definition.
	 * 
	 * @param processor the configuration for the processor to add to this definition
	 */
	function addProcessor (processor:ObjectProcessorConfig) : void;
	
	/**
	 * Returns all processor factories added to this instance.
	 * Modifications on the returned Array are not reflected within the definition.
	 * The Array will contain instances of <code>ObjectProcessorConfig</code>.
	 */
	function get processors () : Array;


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

	
}

}

