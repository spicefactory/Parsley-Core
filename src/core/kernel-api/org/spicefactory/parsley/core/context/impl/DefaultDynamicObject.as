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

package org.spicefactory.parsley.core.context.impl {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.lifecycle.ManagedObjectHandler;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

import flash.events.Event;

/**
 * Default implementation of the DynamicObject interface.
 * 
 * @author Jens Halm
 */
public class DefaultDynamicObject implements DynamicObject {
	
	
	private var _context:DefaultContext;
	private var _definition:DynamicObjectDefinition;
	private var _instance:Object;
	
	private var handler:ManagedObjectHandler;
	private var processed:Boolean;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the dynamic Context this instance belongs to
	 * @param definition the definition that was applied to the instance
	 * @param instance the actual instance that was dynamically added to the Context
	 */
	function DefaultDynamicObject (context:DefaultContext, definition:DynamicObjectDefinition, instance:Object = null) {
		_context = context;
		_definition = definition;
		_instance = instance;
		if (instance != null) {
			_definition = definition.copyForInstance(instance);
		}
		if (!_definition.frozen) {
			_definition.freeze();
		}
		if (!context.initialized) {
			context.addEventListener(ContextEvent.INITIALIZED, contextInitialized);
		}
		else {
			processInstance();
		}
	}
	
	private function contextInitialized (event:Event) : void {
		_context.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		processInstance();
	}
	
	private function processInstance () : void {
		if (processed) return;
		processed = true;
		handler = _context.lifecycleManager.createHandler(definition, context);
		handler.createObject();
		_instance = handler.target.instance;
		handler.configureObject();
	}

	/**
	 * @inheritDoc
	 */
	public function get definition () : DynamicObjectDefinition {
		return _definition;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get instance () : Object {
		if (handler == null && _context.configured) {
			processInstance();
		}
		return _instance;
	}
	
	/**
	 * The dynamic Context this instance belongs to.
	 */
	public function get context () : Context {
		return _context;
	}
	
	/**
	 * @inheritDoc
	 */
	public function remove () : void {
		if (handler) {
			handler.destroyObject();
		} else {
			_context.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		}
	}
}
}

