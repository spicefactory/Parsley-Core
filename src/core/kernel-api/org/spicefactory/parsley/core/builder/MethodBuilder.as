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


import org.spicefactory.parsley.core.processor.MethodProcessor;

/**
 * Builder for applying configuration to a single method.
 * 
 * @author Jens Halm
 */
public interface MethodBuilder {
	
	
	/**
	 * Instructs the builder to invoke the target method with the specified parameters
	 * during initialization of the target instance.
	 * Parameters may be a simple values or instances that implements <code>ResolvableValue</code> 
	 * to be resolved at the time the method will get invoked, like those values returned
	 * by <code>Inject.byType()</code> and related methods.
	 * 
	 * @param params the method parameters
	 */
	function invoke (...params) : void;
	
	/**
	 * Adds a processor for this method.
	 * 
	 * @param processor the method processor to add
	 * @return a builder for configuring the processor
	 */
	function process (processor: MethodProcessor): MethodProcessorBuilder;
	
	
}
}
