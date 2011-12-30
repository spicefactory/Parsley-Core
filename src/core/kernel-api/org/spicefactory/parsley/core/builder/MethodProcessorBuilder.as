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
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;

/**
 * Builder for applying configuration to a single method processor.
 * 
 * @author Jens Halm
 */
public interface MethodProcessorBuilder {
	
	
	/**
	 * Specify the phase the processor should be invoked in during initialization.
	 * The default is <code>InitPhase.preInit()</code>.
	 * 
	 * @param phase the phase the processor should be invoked in during initialization
	 * @return this builder instance for method chaining
	 */
	function initIn (phase: InitPhase) : MethodProcessorBuilder;
	
	/**
	 * Specify the phase the processor should be invoked in when the target instance
	 * gets removed from the Context.
	 * The default is <code>DestroyPhase.postDestroy()</code>.
	 * 
	 * @param phase the phase the processor should be invoked in when the target instance
	 * gets removed from the Context
	 * @return this builder instance for method chaining
	 */
	function destroyIn (phase: DestroyPhase) : MethodProcessorBuilder;
	
	/**
	 * Specifies the minimum of method parameters expected by this processor.
	 * 
	 * @param count the minimum of method parameters expected by this processor
	 * @return this builder instance for method chaining
	 */
	function minParams (count: int) : MethodProcessorBuilder;
	
	/**
	 * Specifies the maximum of method parameters expected by this processor.
	 * 
	 * @param count the maximum of method parameters expected by this processor
	 * @return this builder instance for method chaining
	 */
	function maxParams (count: int) : MethodProcessorBuilder;
	
	
}
}
