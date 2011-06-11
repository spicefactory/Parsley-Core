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

package org.spicefactory.parsley.core.bootstrap {
import org.spicefactory.parsley.core.context.Context;

/**
 * Responsible for processing the configuration and initializing a Context.
 * 
 * @author Jens Halm
 */
public interface BootstrapProcessor {


	/**
	 * Adds a configuration processor.
	 * 
	 * @param processor the processor to add
	 */	
	function addProcessor (processor:ConfigurationProcessor) : void;
	
	/**
	 * The environment info for this processor. Gives access to settings and collaborating services. 
	 */
	function get info () : BootstrapInfo;
	
	/**
	 * Finally processes the configuration, applying all processors that were added and
	 * initializing the Context.
	 * 
	 * This process may be asynchronous. Listeners for the completion or error events
	 * can be registered with the returned Context.
	 * 
	 * @return the Context, possibly not yet fully initialized
	 */
	function process () : Context; 


}
}
