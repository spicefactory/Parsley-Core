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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.ServiceRegistry;

/**
 * Builder that allows to register replacements or decorators for all seven IOC kernel services.
 * 
 * @author Jens Halm
 */
public class ServiceRegistryBuilder implements SetupPart {
	
	private var setup:ContextBuilderSetup;
	
	private var delegates:Array = new Array();
	private var services:ClassInfo;
	
	
	/**
	 * @private
	 */
	function ServiceRegistryBuilder (setup:ContextBuilderSetup) {
		this.setup = setup;
		this.services = ClassInfo.forClass(ServiceRegistry);
	}

	/**
	 * Returns the builder for specifying the implementation or decorators for the core Context service.
	 * 
	 * @return the builder for specifying the implementation or decorators for the core Context service
	 */
	public function context () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("context"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that allows
	 * to register object definitions.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that allows
	 * to register object definitions
	 */
	public function definitionRegistry () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("definitionRegistry"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that
	 * handles the lifecycle of managed objects.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that
	 * handles the lifecycle of managed objects
	 */
	public function lifecycleManager () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("lifecycleManager"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the messaging system.
	 * 
	 * @return the builder for specifying the implementation or decorators for the messaging system
	 */
	public function messageRouter () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("messageRouter"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that
	 * manages the scopes for a particular Context.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that
	 * manages the scopes for a particular Context
	 */
	public function scopeManager () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("scopeManager"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that
	 * manages all aspects of view wiring.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that
	 * manages all aspects of view wiring
	 */
	public function viewManager () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("viewManager"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that
	 * manages decoupled publishers and subscribers.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that
	 * manages decoupled publishers and subscribers
	 */
	public function bindingManager () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("bindingManager"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * Returns the builder for specifying the implementation or decorators for the service that
	 * manages persistent publishers.
	 * 
	 * @return the builder for specifying the implementation or decorators for the service that
	 * manages persistent publishers
	 */
	public function persistenceManager () : ServiceBuilder {
		var delegate:ServiceBuilder = new ServiceBuilder(setup, services.getProperty("persistenceManager"));
		delegates.push(delegate);
		return delegate;
	}
	
	/**
	 * @private
	 */
	public function apply (config:BootstrapConfig) : void {
		for each (var delegate:ServiceBuilder in delegates) {
			delegate.apply(config.services);
		}
	}
	
}
}
