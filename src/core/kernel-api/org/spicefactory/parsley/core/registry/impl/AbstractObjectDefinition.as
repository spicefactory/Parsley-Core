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

import flash.utils.Dictionary;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.ContainerObjectInstantiator;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

/** 
 * Abstract base class for all ObjectDefinition implementations.
 * 
 * @author Jens Halm
 */
public class AbstractObjectDefinition implements ObjectDefinition {

	
	private var _type:ClassInfo;
	private var _id:String;
	
	private var attributes:Dictionary = new Dictionary();
	
	private var _registry:ObjectDefinitionRegistry;
	private var _parent:ObjectDefinition;
	
	private var _instantiator:ObjectInstantiator;
    private var _processors:Array = new Array();	
	
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
	public function getAttribute (key: Object): Object {
		return attributes[key];
	}

	/**
	 * @inheritDoc
	 */
	public function setAttribute (key: Object, value: Object): void {
		attributes[key] = value;
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
	public function addProcessor (processor:ObjectProcessorConfig) : void {
		_processors.push(processor);
	}

	/**
	 * @inheritDoc
	 */
	public function get processors () : Array {
		return (_parent) ? _parent.processors.concat(_processors) : _processors.concat();
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
		instantiator = source.instantiator;
		for each (var config:ObjectProcessorConfig in source.processors) {
			addProcessor(config);
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

