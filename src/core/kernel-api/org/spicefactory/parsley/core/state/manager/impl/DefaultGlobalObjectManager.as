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

package org.spicefactory.parsley.core.state.manager.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.state.GlobalObjectState;
import org.spicefactory.parsley.core.state.manager.GlobalObjectManager;

import flash.utils.Dictionary;

/**
 * Default implementation of the GlobalObjectManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultGlobalObjectManager implements GlobalObjectManager {
	
	
	private const map:Dictionary = new Dictionary();


	/**
	 * @inheritDoc
	 */
	public function addManagedObject (mo:ManagedObject) : void {
		if (map[mo.instance]) {
			throw new IllegalArgumentError("Object of type " + mo.definition.type.name + " is already managed");	
		}
		map[mo.instance] = mo;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeManagedObject (mo:ManagedObject) : void {
		delete map[mo.instance];
	}
	
	/**
	 * @inheritDoc
	 */
	public function getManagedObject (instance:Object) : ManagedObject {
		return map[instance] as ManagedObject;
	}
	
	private var _publicState:GlobalObjectState;
	
	/**
	 * @inheritDoc
	 */
	public function get publicState () : GlobalObjectState {
		if (!_publicState) {
			_publicState = new DefaultGlobalObjectState(this);
		}
		return _publicState;
	}
	
	
}
}

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.state.GlobalObjectState;
import org.spicefactory.parsley.core.state.manager.GlobalObjectManager;

class DefaultGlobalObjectState implements GlobalObjectState {
	
	private var manager:GlobalObjectManager;
	
	function DefaultGlobalObjectState (manager:GlobalObjectManager) {
		this.manager = manager;
	}
	
	public function isManaged (instance:Object) : Boolean {
		return (manager.getManagedObject(instance) != null);
	}

	public function getContext (instance:Object) : Context {
		var mo:ManagedObject = manager.getManagedObject(instance);
		return (mo) ? mo.context : null;
	}
	
}
