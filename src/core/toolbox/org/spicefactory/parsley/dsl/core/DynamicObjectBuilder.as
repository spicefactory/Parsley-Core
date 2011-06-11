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

/**
 * Builder for a definition of a dynamic object.
 * Such an object can be removed from the Context, either by application code
 * or, in case of injections, by the container when the target object gets disposed.
 * 
 * @author Jens Halm
 */
public interface DynamicObjectBuilder {
	
	
	/**
	 * Sets the (optional) id the object should be registered with.
	 * 
	 * @param value the id the object should be registered with
	 * @return this builder for method chaining
	 */
	function id (value:String) : DynamicObjectBuilder;
	
	/**
	 * Sets the additional decorators that should be processed for the definition.
	 * Since version 2.3 it is no longer recommended to programmatically create and apply
	 * decorators since the new configuration DSL provides a more convenient mechanism.
	 * This method should be used by tag implementations that allow to specify decorators
	 * as nested tags (like the root &lt;Object&gt; tag).
	 * 
	 * @param value decorators that should be processed for the definition
	 * @return this builder for method chaining
	 */
	function decorators (value:Array) : DynamicObjectBuilder;
	
	/**
	 * Builds and returns the final definition without registering it.
	 * An object that does not get registered cannot be used for injection and cannot
	 * be retrieved through the Context API. But this definition can be used
	 * as a nested (inline) reference or adding it to the Context dynamically at a later point. 
	 * 
	 * @return the final definition produced by this builder
	 */
	function build () : DynamicObjectDefinition;
	
	/**
	 * Builds, registers and returns the final definition. This method delegates
	 * to the <code>build</code> method to produce the final definition and then registers
	 * it with the underlying registry.
	 * 
	 * @return the final definition produced by this builder
	 */
	function register () : DynamicObjectDefinition;
	
	
}
}
