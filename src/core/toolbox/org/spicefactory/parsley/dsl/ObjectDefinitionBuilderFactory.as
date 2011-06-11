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

/**
 * A factory for builders that can be used to create ObjectDefinitions programmatically, 
 * using the franmework's configuration DSL.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionBuilderFactory {
	
	/**
	 * Returns a builder for the specified type.
	 * 
	 * @param type the type to create a builder for
	 * @return a new builder for the specified type
	 */
	function forClass (type:Class) : ObjectDefinitionBuilder;
	
	/**
	 * Returns a builder for the specified instance.
	 * In this case the target instance will not be created by the container,
	 * it will simply configure and manage the existing instance.
	 * 
	 * @param type the type to create a definition for
	 * @return a new builder for the specified instance
	 */
	function forInstance (instance:Object) : ObjectDefinitionBuilder;

	
}
}
