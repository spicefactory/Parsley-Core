/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.lifecycle.impl {

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.lifecycle.ManagedObjectHandler;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Default implementation of the ManagedObjectHandler interface.
 * 
 * @author Jens Halm
 */
public class DefaultManagedObjectHandler implements ManagedObjectHandler {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultManagedObjectHandler);
	
	private static const PREPARED:String = "prepared";
	private static const CREATED:String = "created";
	private static const CONFIGURED:String = "configured";
	private static const DESTROYED:String = "destroyed";
	
	
	private var _processors:Array = new Array();

	private var _target:ManagedObjectImpl;
	
	private var manager:DefaultObjectLifecycleManager;
	
	private var state:String = PREPARED;


	/**
	 * Creates a new instance.
	 * 
	 * @param definition the definition this handler will manage
	 * @param context the Context the definition belongs to
	 * @param manager the manager responsible for this handler
	 */
	function DefaultManagedObjectHandler (definition:ObjectDefinition, context:Context, manager:DefaultObjectLifecycleManager) {
		_target = new ManagedObjectImpl(definition, context);
		this.manager = manager;	
	}
	
	/**
	 * @inheritDoc
	 */
	public function get target () : ManagedObject {
		if (state == PREPARED) {
			throw new ContextError("Target object has not been created yet");
		}
		return _target;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get processors () : Array {
		return _processors;
	}

	/**
	 * @inheritDoc
	 */
	public function createObject () : void {
		checkState(PREPARED);
		state = CREATED;
		if (target.definition.instantiator != null) {
			 _target.instance = target.definition.instantiator.instantiate(target);
		}
		else {
			_target.instance = target.definition.type.newInstance([]);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function configureObject () : void {
		checkState(CREATED);
		state = CONFIGURED;
		
		if (log.isInfoEnabled()) {
			log.info("Configure managed object with {0} and {1} processor(s)", 
					target.definition, target.definition.processors.length);
		}
		
		manager.globalObjectManager.addManagedObject(target);

	 	createProcessors();

		processLifecycle(ObjectLifecycle.PRE_INIT);
	 	invokePreInitMethods();
		processLifecycle(ObjectLifecycle.POST_INIT);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroyObject () : void {
		if (state != CONFIGURED) return;
		state = DESTROYED;
		
		if (log.isInfoEnabled()) {
			log.info("Destroy managed object with {0}", target.definition);
		}
		
		manager.globalObjectManager.removeManagedObject(target);
		
		try {
			processLifecycle(ObjectLifecycle.PRE_DESTROY);
		 	invokePostDestroyMethods();
			processLifecycle(ObjectLifecycle.POST_DESTROY);
		}
		finally {
			_target.removeSynchronizedObjects();
			manager.removeHandler(this);
		}
	}
	
	/**
	 * Invokes the preInit methods on all processor for the specified target instance.
	 */
	protected function invokePreInitMethods () : void {
		
		var sort:Function = function (config1: ObjectProcessorConfig, config2: ObjectProcessorConfig): int {
			return config1.initPhase.compareTo(config2.initPhase);
		};
		processors.sort(sort);
		
		for each (var config:ObjectProcessorConfig in processors) {
			if (log.isDebugEnabled()) {
				log.debug("Applying {0} to managed object with {1}", config.processor, target.definition);
			}
			config.processor.init(target);
		}
	}
	
	/**
	 * Invokes the postDestroy methods on all processor for the specified target instance.
	 */
	protected function invokePostDestroyMethods () : void {
		
		var sort:Function = function (config1: ObjectProcessorConfig, config2: ObjectProcessorConfig): int {
			return config1.destroyPhase.compareTo(config2.destroyPhase);
		};
		processors.sort(sort);

		for each (var config:ObjectProcessorConfig in processors) {
			config.processor.destroy(target);
		}
	}
	
	/**
	 * Processes all processor factories of the specified definition and creates new processors for 
	 * the target instance.
	 */
	protected function createProcessors () : void {
		for each (var config:ObjectProcessorConfig in target.definition.processors) {
			processors.push(config.prepareForNextTarget());
		}
	}
	
	/**
	 * Processes the lifecycle listeners for the specified instance.
	 * 
	 * @param event the lifecycle event type
	 */
	protected function processLifecycle (event:ObjectLifecycle) : void {
		manager.processObservers(target, event);
	}
	
	private function checkState (expected:String) : void {
		if (state != expected) {
			throw new ContextError("Method called in unexpected state: " + state
					+ " - expected state: " + expected);
		}
	}

	
}
}

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ResolvableValue;

class ManagedObjectImpl implements ManagedObject {
	
	
	private var _instance:Object;
	private var _definition:ObjectDefinition;
	private var _context:Context;
	private var synchronizedObjects:Array = new Array();
	
	
	function ManagedObjectImpl (definition:ObjectDefinition, context:Context) {
		_definition = definition;
		_context = context;
	}
	
	public function get instance () : Object {
		return _instance;
	}
	
	public function get definition () : ObjectDefinition {
		return _definition;
	}
	
	public function get context () : Context {
		return _context;
	}
	
	public function set instance (value:Object) : void {
		_instance = value;
	}
	
	public function resolveValue (value:*) : * {
		if (value is ResolvableValue) {
			return ResolvableValue(value).resolve(this);
		}
		else {
			return value;
		}
	}
	
	public function resolveObjectReference (definition:ObjectDefinition) : Object {
		if (definition is DynamicObjectDefinition) {
			var dynObject:DynamicObject = context.addDynamicDefinition(definition as DynamicObjectDefinition);
			synchronizeLifecycle(dynObject);
			return dynObject.instance;
		}
		else {
			return definition.registry.context.getObject(definition.id);
		}
	}
	
	public function synchronizeLifecycle (object:DynamicObject) : void {
		synchronizedObjects.push(object);
	}
	
	internal function removeSynchronizedObjects () : void {
		for each (var object:DynamicObject in synchronizedObjects) {
			object.remove();
		}
	}
	
}

