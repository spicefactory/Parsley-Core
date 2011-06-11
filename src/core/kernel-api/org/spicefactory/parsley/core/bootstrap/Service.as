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
import org.spicefactory.parsley.core.bootstrap.impl.ServiceFactory;
import org.spicefactory.parsley.core.context.LookupStatus;

/**
 * Represents the configuration of a single IOC kernel service.
 * It allows to either specify or replace the implementation of this service
 * or add decorators.
 * 
 * @author Jens Halm
 */
public interface Service {
	
	
	/**
	 * The interface all implementations of this service must implement.
	 */
	function get serviceInterface () : Class;
	
	/**
	 * All decorators added to this service.
	 * An Array of <code>ServiceFactory</code> instances.
	 * 
	 * @param status optional paramater to avoid duplicate lookups, for internal use only 
	 * @return all decorators added to this service
	 */
	function getDecorators (status:LookupStatus = null) : Array;
	
	/**
	 * The factory for the service implementation.
	 * This factory produces an instance where the decorators added to this service
	 * have not yet been applied.
	 */
	function get factory () : ServiceFactory;
	
	/**
	 * Adds a decorator for this service. Decorating services is the recommended way
	 * of adding funcitonality to the kernel services, as it allows to stack multiple
	 * third party decorators without overriding each others extension. The decorator
	 * class must implement the same interface as the decorated service and come with
	 * a constructor that accepts the decorated service as the first parameter. If you 
	 * pass additional parameters to this method they must be added as additional constructor
	 * parameters after this required first parameter.
	 * 
	 * @param type the implementation type of the service
	 * @param params the parameters to pass to the constructor of the decorator, after the first parameter which is
	 * always the decorated service itself
	 */
	function addDecorator (type:Class, ...params) : void;
	
	/**
	 * Sets the implementation for this service, replacing the existing registration.
	 * 
	 * @param type the implementation type of the service
	 * @param params the parameters to pass to the constructor of the service
	 */
	function setImplementation (type:Class, ...params) : void;
	
	/**
	 * Creates a new instance of this service, using the specified implementation
	 * and applying all decorators added to this service.
	 * 
	 * @param initCallback the callback to invoke immediately after instantiation of service and decorator instances
	 * @return a new instance of this service
	 */
	function newInstance (initCallback:Function = null) : Object;
	
	
}
}
