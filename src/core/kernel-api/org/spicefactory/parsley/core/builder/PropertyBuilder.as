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


import org.spicefactory.parsley.core.processor.PropertyProcessor;

/**
 * Builder for applying configuration to a single property.
 * 
 * @author Jens Halm
 */
public interface PropertyBuilder {
	
	
	/**
	 * Sets the value of this property. This may be a simple value
	 * or an instance that implements <code>ResolvableValue</code> to be resolved
	 * at the time the value will be injected into the property, like those values returned
	 * by <code>Inject.byType()</code> and related methods.
	 * 
	 * @param value the property value to apply
	 */
	function value (value:*) : void;
	
	/**
	 * Adds a processor for this property.
	 * 
	 * @param processor the property processor to add
	 * @return a builder for configuring the processor
	 */
	function process (processor: PropertyProcessor): PropertyProcessorBuilder;
	
	
}
}
