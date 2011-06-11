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

/**
 * The BootstrapManager is the entry point for building a new Context. It exposes the configuration instance
 * that can be used to specify settings, configuration processors and services and a method to create a processor
 * that is responsible for applying the configuration and initializing a new Context.
 * 
 * @author Jens Halm
 */
public interface BootstrapManager {
	
	
	/**
	 * The configuration to be used when building a new Context.
	 * Can be used to specify settings, configuration processors and replacements or decorators for the kenerl services.
	 */
	function get config () : BootstrapConfig;
	
	/**
	 * Creates a new processor responsible for applying the configuration and initializing a new Context.
	 * 
	 * @return a new processor responsible for applying the configuration and initializing a new Context
	 */
	function createProcessor () : BootstrapProcessor;
	
	
}
}
