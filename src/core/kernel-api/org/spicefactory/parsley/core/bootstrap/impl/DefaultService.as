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

package org.spicefactory.parsley.core.bootstrap.impl {
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.context.impl.DefaultLookupStatus;

/**
 * Default implementation of the Service interface.
 * 
 * @author Jens Halm
 */
public class DefaultService implements Service {
	
	
	private var initCallback:Function;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param serviceInterface the interface all implementations of this service must implement
	 */
	function DefaultService (serviceInterface:Class) {
		_serviceInterface = serviceInterface;
	}

	
	private var _parents:Array = new Array();
	
	/**
	 * Adds a parent service to be used to pull additional decorators and the default implementation from.
	 * 
	 * @param parent a parent service to add to this service 
	 */
	public function addParent (parent:Service) : void {
		_parents.push(parent);
	}
	
	
	private var _serviceInterface:Class;
	
	/**
	 * @inheritDoc
	 */
	public function get serviceInterface () : Class {
		return _serviceInterface;
	}
	
	
	private var _decorators:Array = new Array();
	
	/**
	 * @inheritDoc
	 */
	public function getDecorators (status:LookupStatus = null) : Array {
		var decorators:Array = _decorators;
		var parentDecorators:Array;
		for each (var parent:Service in _parents) {
			if (!status) {
				status = new DefaultLookupStatus(this);
			}
			if (status.addInstance(parent)) {
				parentDecorators = parent.getDecorators(status);
				if (parentDecorators.length) {
					decorators = decorators.concat(parentDecorators);
				}
			}
			
		}
		return decorators;
	}
	
	
	private var _factory:ServiceFactory;
	
	/**
	 * @inheritDoc
	 */
	public function get factory () : ServiceFactory {
		return (_factory) ? _factory : (_parents.length) ? _parents[0].factory : null;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function addDecorator (type:Class, ...params) : void {
		_decorators.push(new ServiceFactory(type, params, serviceInterface));
	}
	
	/**
	 * @inheritDoc
	 */
	public function setImplementation (type:Class, ...params) : void {
		_factory = new ServiceFactory(type, params, serviceInterface);
	}

	/**
	 * @inheritDoc
	 */
	public function newInstance(initCallback:Function = null) : Object {
		var service:Object = factory.newInstance();
		if (initCallback != null) {
			initCallback(service);
		}
		for each (var decorator:ServiceFactory in getDecorators()) {
			service = decorator.newInstance(service);
			if (initCallback != null) {
				initCallback(service);
			}
		}
		return service;
	}
	
	
}
}
