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
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.util.ClassUtil;

import flash.utils.getQualifiedClassName;

/**
 * A simple factory for creating service instances. It allows to register the implementation class, optionally the
 * interface the service must implement and parameters to pass to the constructor.
 * 
 * @author Jens Halm
 */
public class ServiceFactory {
	
	// TODO - 3.1 - this class might live behing an interface, too
	
	private var requiredInterface:Class;
	private var _implementation:Class;
	private var params:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param implementation the class that implements the service
	 * @param params the parameters to pass to the constructor of the service
	 * @param requiredInterface the interface the service implementation must implement
	 */
	function ServiceFactory (implementation:Class, params:Array = null, requiredInterface:Class = null) {
		_implementation = implementation;
		this.params = (params) ? params : [];
		this.requiredInterface = requiredInterface;
	}
	
	
	/**
	 * The class that implements the service.
	 */
	public function get implementation () : Class {
		return _implementation;
	}

	
	/**
	 * Creates a new instance of the service.
	 * 
	 * @param params additional parameters to pass to the constructor of the service, prepended to the ones 
	 * specified when creating this factory.
	 */
	public function newInstance (...params) : Object {
		params = (params && params.length) ? params.concat(this.params) : this.params; 
		var service:Object = ClassUtil.createNewInstance(implementation, params);
		if (requiredInterface && !(service is requiredInterface)) {
			throw new IllegalStateError("Service implementation " + getQualifiedClassName(implementation)
					+ " does not implement the interface " + getQualifiedClassName(requiredInterface));
		}
		return service;
	}
	
	
}
}
