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
import org.spicefactory.parsley.core.bootstrap.impl.DefaultService;
import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.context.impl.DefaultLookupStatus;
import org.spicefactory.parsley.core.scope.ScopeExtensionRegistry;

import flash.utils.Dictionary;

/**
 * Default implementation of the ScopeExtensionRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeExtensionRegistry implements ScopeExtensionRegistry {

	
	private var _parents:Array = new Array();
	
	private var types:Dictionary = new Dictionary();
	
	private var activeTypes:Dictionary;
	
	
	/**
	 * @inheritDoc
	 */
	public function forType (type:Class) : Service {
		var service:Service = types[type] as Service;
		if (!service) {
			service = new DefaultService(type);
			types[type] = service;
		}
		return service;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getAll (status:LookupStatus = null) : Dictionary {
		if (!activeTypes) {
			activeTypes = new Dictionary();
			for (var type:Object in types) {
				if (Service(types[type]).factory) {
					activeTypes[type] = types[type];
				}
			}
			for each (var parent:ScopeExtensionRegistry in _parents) {
				if (!status) {
					status = new DefaultLookupStatus(this);
				}
				if (status.addInstance(parent)) {
					var inheritedTypes:Dictionary = parent.getAll(status);
					for (var inheritedType:Object in inheritedTypes) {
						var service:DefaultService = activeTypes[inheritedType];
						if (!service) {
							service = types[inheritedType];
							if (!service) {
								service = new DefaultService(inheritedType as Class);
							}
							activeTypes[inheritedType] = service;
						}
						service.addParent(inheritedTypes[inheritedType]);
					}
				}
			}
		}
		return activeTypes;
	}
	
	
	/**
	 * Adds a parent registry to be used to pull additional extensions from.
	 * 
	 * @parent a parent registry
	 */
	public function addParent (parent:ScopeExtensionRegistry) : void {
		_parents.push(parent);	
	}
	
	
}
}
