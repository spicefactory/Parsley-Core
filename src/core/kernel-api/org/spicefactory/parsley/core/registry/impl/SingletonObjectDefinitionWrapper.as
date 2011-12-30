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

package org.spicefactory.parsley.core.registry.impl {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.AsyncInitConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

/**
 * A simple wrapper around an existing root object definition.
 * 
 * @author Jens Halm
 */
public class SingletonObjectDefinitionWrapper implements SingletonObjectDefinition {


	private var _id:String;
	private var _lazy:Boolean;
	private var _order:int;
	private var _asyncInit:AsyncInitConfig;
	private var wrappedDefinition:ObjectDefinition;


	/**
	 * Creates a new instance.
	 * 
	 * @param wrappedDefinition the definition to wrap
	 * @param id the id the object should be registered with
	 * @param lazy whether the object is lazy initializing
	 * @param singleton whether the object should be treated as a singleton
	 * @param order the initialization order for non-lazy singletons
	 * @param asyncInit the configuration for an asynchronously initializing object
	 */
	function SingletonObjectDefinitionWrapper (wrappedDefinition:ObjectDefinition, id:String = null, 
			lazy:Boolean = false, order:int = int.MAX_VALUE, asyncInit:AsyncInitConfig = null) : void {
		this.wrappedDefinition = wrappedDefinition;
		_id = (id != null) ? id : IdGenerator.nextObjectId;
		_lazy = lazy;
		_order = order;
		_asyncInit = asyncInit;
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
	public function get lazy () : Boolean {
		return _lazy;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get registry () : ObjectDefinitionRegistry {
		return wrappedDefinition.registry;
	}

	/**
	 * @inheritDoc
	 */
	public function get order () : int {
		return _order;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getAttribute (key: Object): Object {
		return wrappedDefinition.getAttribute(key);
	}

	/**
	 * @inheritDoc
	 */
	public function setAttribute (key: Object, value: Object): void {
		wrappedDefinition.setAttribute(key, value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function freeze () : void {
		wrappedDefinition.freeze();
	}

	/**
	 * @inheritDoc
	 */
	public function get type () : ClassInfo {
		return wrappedDefinition.type;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get instantiator () : ObjectInstantiator {
		return wrappedDefinition.instantiator;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get asyncInitConfig () : AsyncInitConfig {
		return _asyncInit;
	}

	/**
	 * @inheritDoc
	 */
	public function get frozen () : Boolean {
		return wrappedDefinition.frozen;
	}

	/**
	 * @inheritDoc
	 */
	public function set instantiator (value:ObjectInstantiator) : void {
		wrappedDefinition.instantiator = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addProcessor (processor:ObjectProcessorConfig) : void {
		wrappedDefinition.addProcessor(processor);
	}

	/**
	 * @inheritDoc
	 */
	public function get processors () : Array {
		return wrappedDefinition.processors;
	}

	/**
	 * @inheritDoc
	 */
	public function set asyncInitConfig (config:AsyncInitConfig) : void {
		_asyncInit = config;
	}


}
}
