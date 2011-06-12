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

package org.spicefactory.parsley.core.context.provider {

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.system.ApplicationDomain;

/**
 * Static utility method to create an ObjectProvider for an existing instance.
 * 
 * @author Jens Halm
 */
public class Provider {
	
	
	/**
	 * Creates an ObjectProvider for an existing instance, simply wrapping it.
	 * Useful if existing instances must be passed to a method that expects an ObjectProvider instance
	 * as a parameter, like most of the methods for registering message receivers for example.
	 * 
	 * <p>This utility method should only be used in cases where <code>ObjectDefinition.objectLifecycle.synchronizeProvider</code>
	 * cannot be used, since it does not take care of any synchronization issues for singletons that get created upon
	 * container initialization.</p>
	 * 
	 * @param instance the instance to wrap
	 * @param domain the ApplicationDomain to use for reflecting on the instance
	 * @return a new ObjectProvider wrapping the specified instance 
	 */
	public static function forInstance (instance:Object, domain:ApplicationDomain = null) : ObjectProvider {
		return new SimpleInstanceProvider(instance, domain);
	}
	
	/**
	 * Creates an ObjectProvider for a singleton definition.
	 * 
	 * @param definition the definition for the object to create a provider for
	 * @param context the Context to use to retrieve the actual instance
	 * @return a new ObjectProvider for the specified singleton definition 
	 */
	public static function forDefinition (definition:SingletonObjectDefinition, context:Context) : ObjectProvider {
		return new ContextObjectProvider(definition, context);
	}
	
	
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.system.ApplicationDomain;

class SimpleInstanceProvider implements ObjectProvider {
	
	
	private var _instance:Object;
	private var _type:ClassInfo;
	
	
	function SimpleInstanceProvider (instance:Object, domain:ApplicationDomain = null) {
		_instance = instance;
		_type = ClassInfo.forInstance(instance, domain);
	}
	
	public function get instance () : Object {
		return _instance;
	}
	
	public function get type () : ClassInfo {
		return _type;
	}
	
	
}

class ContextObjectProvider implements ObjectProvider {

	private var definition:SingletonObjectDefinition;
	private var context:Context;
	private var _instance:Object;

	function ContextObjectProvider (definition:SingletonObjectDefinition, context:Context) {
		this.context = context;
		this.definition = definition;
	}

	public function get instance () : Object {
		if (_instance == null) {
			if (!context.containsObject(definition.id)) {
				throw new ContextError("Invalid ObjectProvider: Context does not contain an object with id " + definition.id);
			}
			_instance = context.getObject(definition.id);
		}
		return _instance;
	}
	
	public function get type () : ClassInfo {
		return definition.type;
	}
	
}

