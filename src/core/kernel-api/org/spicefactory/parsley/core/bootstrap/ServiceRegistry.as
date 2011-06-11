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
 * The registry for the configurations of all seven IOC kernel services for one particular Context.
 * 
 * @author Jens Halm
 */
public interface ServiceRegistry {
	
	
	/**
	 * The configuration for the service that handles the initialization of a Context.
	 */
	function get bootstrapManager () : Service;
	
	/**
	 * The configuration for the service that implements the messaging system.
	 */
	function get messageRouter () : Service;
	
	/**
	 * The configuration for the Context implementation.
	 */
	function get context () : Service;
	
	/**
	 * The configuration for service that allows to register object definitions.  
	 */
	function get definitionRegistry () : Service;
	
	/**
	 * The configuration for the service that handles the lifecycle of managed objects. 
	 */
	function get lifecycleManager () : Service;
	
	/**
	 * The configuration for the service that manages the scopes for a particular Context.
	 */
	function get scopeManager () : Service;
	
	/**
	 * The configuration for the service that manages all aspects of view wiring.
	 */
	function get viewManager () : Service;
	
	
}
}
