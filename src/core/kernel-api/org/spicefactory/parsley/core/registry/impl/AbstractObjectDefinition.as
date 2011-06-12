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

package org.spicefactory.parsley.core.registry.impl {

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.ContainerObjectInstantiator;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;

/** 
 * Abstract base class for all ObjectDefinition implementations.
 * 
 * @author Jens Halm
 */
public class AbstractObjectDefinition implements ObjectDefinition {

	
	private var _type:ClassInfo;
	private var _id:String;
	
	private var _registry:ObjectDefinitionRegistry;
	private var _parent:ObjectDefinition;
	
	private var _instantiator:ObjectInstantiator;
    private var _processorFactories:Array = new Array();	
	
	private var _initMethod:String;
	private var _destroyMethod:String;

	private var _frozen:Boolean;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the type to create a definition for
	 * @param id the id the object should be registered with
	 * @param registry the registry this definition belongs to
	 * @param parent the parent definition containing shared configuration for this definition
	 */
	function AbstractObjectDefinition (type:ClassInfo, id:String, 
			registry:ObjectDefinitionRegistry, parent:ObjectDefinition = null) {
		_type = type;
		_id = id;
		_registry = registry;
		_parent = parent;		
	}
	

	/**
	 * @inheritDoc
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get id () : String {
		return _id;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get registry () : ObjectDefinitionRegistry {
		return _registry;
	}

	/**
	 * @inheritDoc
	 */
	public function get instantiator () : ObjectInstantiator {
		return (_instantiator) ? _instantiator : ((_parent) ? _parent.instantiator : null);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addProcessorFactory (factory:ObjectProcessorFactory) : void {
		_processorFactories.push(factory);
	}

	/**
	 * @inheritDoc
	 */
	public function get processorFactories () : Array {
		return (_parent) ? _parent.processorFactories.concat(_processorFactories) : _processorFactories.concat();
	}

	/**
	 * @inheritDoc
	 */
	public function set instantiator (value:ObjectInstantiator) : void {
		checkState();
		if (instantiator != null && (instantiator is ContainerObjectInstantiator)) {
			throw new IllegalStateError("Instantiator has been set by the container and cannot be overwritten");
		}
		_instantiator = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get initMethod () : String {
		return (_initMethod) ? _initMethod : ((_parent) ? _parent.initMethod : null);
	}

	/**
	 * @inheritDoc
	 */
	public function set initMethod (name:String) : void {
		checkState();
		checkMethodName(name);
		_initMethod = name;
	}

	/**
	 * @inheritDoc
	 */
	public function get destroyMethod () : String {
		return (_destroyMethod) ? _destroyMethod : ((_parent) ? _parent.destroyMethod : null);
	}

	/**
	 * @inheritDoc
	 */
	public function set destroyMethod (name:String) : void {
		checkState();
		checkMethodName(name);
		_destroyMethod = name;
	}

	private function checkMethodName (name:String) : void {
		if (type.getMethod(name) == null) {
			throw new IllegalArgumentError("Class " + type.name 
					+ " does not contain a method with name " + name);
		}
	}
	
	private function checkState () : void {
		if (frozen) {
			throw new IllegalStateError(toString() + " is frozen");
		}
	}

	/**
	 * @inheritDoc
	 */
	public function freeze () : void {
		_frozen = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get frozen () : Boolean {
		return _frozen;
	}
	
	/**
	 * Populates this definition with all configuration artifacts from the specified source.
	 *
	 * @param source the definition to copy all configuration artifacts from
	 */
	public function populateFrom (source:ObjectDefinition) : void {
		if (source.initMethod != null) {
			initMethod = source.initMethod;
		}
		if (source.destroyMethod != null) {
			destroyMethod = source.destroyMethod;
		}
		instantiator = source.instantiator;
		for each (var factory:ObjectProcessorFactory in source.processorFactories) {
			addProcessorFactory(factory);
		}
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ObjectDefinition(type = " + _type.name + ", id = " + _id + ")]";
	}
	
	
}
}

