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

package org.spicefactory.parsley.core.builder {
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

/**
 * Builder for the definition of a singleton object.
 * 
 * @author Jens Halm
 */
public interface SingletonBuilder {
	
	
	/**
	 * Sets the (optional) id the object should be registered with.
	 * 
	 * @param value the id the object should be registered with
	 * @return this builder for method chaining
	 */
	function id (value:String) : SingletonBuilder;
	
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
	function decorators (value:Array) : SingletonBuilder;
	
	/**
	 * Specifies whether this object should be lazily initialized.
	 * If set to false the object will be instantiated upon Context initialization.
	 * 
	 * @param value whether this object should be lazily initialized
	 * @return this builder for method chaining
	 */
	function lazy (value:Boolean) : SingletonBuilder;
	
	/**
	 * Sets the initialization order value for this object. 
	 * Will be processed in ascending order. 
	 * The default value is <code>int.MAX_VALUE</code>.
	 * 
	 * @param value the initialization order value for this object 
	 * @return this builder for method chaining
	 */
	function order (value:int) : SingletonBuilder;
	
	
	/**
	 * Builds and returns the final definition without registering it.
	 * An object that does not get registered cannot be used for injection and cannot
	 * be retrieved through the Context API. But this definition can be used
	 * as a nested (inline) reference or adding it to the Context dynamically at a later point. 
	 * 
	 * @return the final definition produced by this builder
	 */
	function build () : SingletonObjectDefinition;
	
	/**
	 * Builds, registers and returns the final definition. This method delegates
	 * to the <code>build</code> method to produce the final definition and then registers
	 * it with the underlying registry.
	 * 
	 * @return the final definition produced by this builder
	 */
	function register () : SingletonObjectDefinition;
	
	
}
}
