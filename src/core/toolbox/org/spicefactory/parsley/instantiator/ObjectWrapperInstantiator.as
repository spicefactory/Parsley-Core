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

package org.spicefactory.parsley.instantiator {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ContainerObjectInstantiator;

/**
 * ObjectInstantiator implementation that wraps an existing instance. 
 * Also implements the ContainerObjectInstantiator marker interface since such an instantiator
 * usually cannot be overridden by other configuration artifacts.
 * 
 * @author Jens Halm
 */
public class ObjectWrapperInstantiator implements ContainerObjectInstantiator {
	
	
	private var instance:Object;	
	
	
	/**
	 * Creates a new instantiator instance.
	 * 
	 * @param instance the existing instance to wrap
	 */
	function ObjectWrapperInstantiator (instance:Object) {
		this.instance = instance;
	}

	
	/**
	 * @inheritDoc
	 */
	public function instantiate (target:ManagedObject) : Object {
		return instance;
	}
	
	
}
}

