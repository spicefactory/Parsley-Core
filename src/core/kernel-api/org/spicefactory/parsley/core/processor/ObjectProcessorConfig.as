/*
 * Copyright 2011 the original author or authors.
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
package org.spicefactory.parsley.core.processor {


import org.spicefactory.lib.reflect.Member;

/**
 * The configuration for a single object processor.
 * 
 * @author Jens Halm
 */
public interface ObjectProcessorConfig {
	

   	/**
   	 * The processor configured by this instance.
   	 */	
    function get processor (): ObjectProcessor;
   
   	/**
	 * The phase the processor should be invoked in during initialization.
	 */
    function get initPhase (): InitPhase;

	/**
	 * The phase the processor should be invoked in when the target instance
	 * gets removed from the Context or the Context gets destroyed.
	 */
    function get destroyPhase (): DestroyPhase;
   
    /**
     * The target member (property or method) to get processed.
     * May be null if the processor does not explitly deal with just one 
     * member of the target instance. The majority of built-in processors
     * have this property set.
     */
    function get target (): Member;
   
    /**
     * Prepares a processor for the next target instance.
     * This includes cloning the processor in case it is stateful
     * and gets applied to a non-singleton object. Otherwise
     * this instance may just return itself.
     * 
     * @return a processor for the next target instance
     */
    function prepareForNextTarget (): ObjectProcessorConfig;
   
   
}
}
