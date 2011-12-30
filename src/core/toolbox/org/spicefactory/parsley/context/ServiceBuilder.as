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

package org.spicefactory.parsley.context {
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.bootstrap.ServiceRegistry;

/**
 * Builder for specifying replacements or decorators for the core kernel services.
 * 
 * @author Jens Halm
 */
public class ServiceBuilder {
	
	
	private var setup:ContextBuilderSetup;
	private var property:Property;
	
	private var replacement:ServiceSetup;
	private var decorators:Array = new Array();
	
	
	/**
	 * @private
	 */
	function ServiceBuilder (setup:ContextBuilderSetup, property:Property = null) {
		this.setup = setup;
		this.property = property;
	}

	/**
	 * Sets the implementation for this service, replacing the existing registration.
	 * 
	 * @param type the implementation type of the service
	 * @param params the parameters to pass to the constructor of the service
	 * @return the original setup instance for method chaining
	 */
	public function setImplementation (type:Class, ...params) : ContextBuilderSetup {
		replacement = new ServiceSetup(type, params);
		return setup;
	}
	
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
	 * @return the original setup instance for method chaining
	 */
	public function addDecorator (type:Class, ...params) : ContextBuilderSetup {
		decorators.push(new ServiceSetup(type, params));
		return setup;
	}

	/**
	 * @private
	 */
	public function apply (registry:ServiceRegistry) : void {
		var service:Service = property.getValue(registry);
		configureService(service);
	}
	
	/**
	 * @private
	 */
	public function configureService (service:Service) : void {
		if (replacement) {
			replacement.apply(service.setImplementation);
		}
		for each (var decorator:ServiceSetup in decorators) {
			decorator.apply(service.addDecorator);
		}
	}
	
	
}
}

class ServiceSetup {
	private var params:Array;
	function ServiceSetup (type:Class, params:Array) {
		this.params = [type].concat(params);
	}
	public function apply (f:Function) : void {
		f.apply(null, params);
	}
}
