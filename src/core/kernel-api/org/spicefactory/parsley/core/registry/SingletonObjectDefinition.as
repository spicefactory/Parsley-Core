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
 
package org.spicefactory.parsley.core.registry {

/**
 * Represents the configuration for a singleton object.
 * Such an object has additional properties not needed for dynamic or nested object definitions.
 * 
 * @author Jens Halm
 */
public interface SingletonObjectDefinition extends ObjectDefinition {
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#lazy
	 */
	function get lazy () : Boolean;
	
	/**
	 * @copy org.spicefactory.parsley.asconfig.metadata.ObjectDefinitionMetadata#order
	 */
	function get order () : int;
	
	/**
	 * The configuration for asynchronously initializing objects.
	 */
    function get asyncInitConfig () : AsyncInitConfig;
    
    function set asyncInitConfig (config:AsyncInitConfig) : void;
	
	
}
}
