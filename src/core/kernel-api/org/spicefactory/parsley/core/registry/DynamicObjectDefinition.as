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
 * Represents the configuration for a dynamic object.
 * Such an object can be created and removed from the Context dynamically.
 * 
 * @author Jens Halm
 */
public interface DynamicObjectDefinition extends ObjectDefinition {
	
	
	/**
	 * Creates a copy of this definition wrapping the existing instance.
	 * 
	 * @param instance the instance to wrap
	 * @return a new ObjectDefinition wrapping the existing instance
	 */
	function copyForInstance (instance:Object) : DynamicObjectDefinition;
	
	
}
}
