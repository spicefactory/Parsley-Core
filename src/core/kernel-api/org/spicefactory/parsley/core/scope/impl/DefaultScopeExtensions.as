/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.core.scope.impl {
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.scope.ScopeExtensions;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Default implementation of the ScopeExtensions interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeExtensions implements ScopeExtensions {


	private var factories:Dictionary;
	private var instances:Dictionary = new Dictionary();
	
	private var initCallback:Function;


	/**
	 * Creates a new instance.
	 * 
	 * @param types all extensions for this instance mapped by type
	 * @param initCallback the callback to invoke when creating a new instance of a scope extension
	 */
	function DefaultScopeExtensions (types:Dictionary, initCallback:Function) {
		this.factories = types;
		this.initCallback = initCallback;
	}

	
	/**
	 * @inheritDoc
	 */
	public function forType (type:Class) : Object {
		if (!instances[type]) {
			var service:Service = factories[type];
			if (service == null) {
				throw new ContextError("No scope extension registered for type " 
							+ getQualifiedClassName(type));
			}
			instances[type] = service.newInstance(initCallback);
		}
		return instances[type];
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasType (type:Class) : Boolean {
		return (factories[type] != undefined);
	}
	
	
}
}
