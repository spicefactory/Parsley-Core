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
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;

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
			// TODO - 3.0.M2 - implicit injection by type in case of no-arg constructors
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
					target.definition, target.definition.processorFactories.length);
		}
		
		manager.globalObjectManager.addManagedObject(target);

	 	createProcessors();

		processLifecycle(ObjectLifecycle.PRE_CONFIGURE);
		
	 	invokePreInitMethods();
		processLifecycle(ObjectLifecycle.PRE_INIT);
		if (target.definition.initMethod != null) {
			target.definition.type.getMethod(target.definition.initMethod).invoke(target.instance, []);
		}
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
			if (target.definition.destroyMethod != null) {
				target.definition.type.getMethod(target.definition.destroyMethod).invoke(target.instance, []);
			}
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
		for each (var processor:ObjectProcessor in processors) {
			if (log.isDebugEnabled()) {
				log.debug("Applying {0} to managed object with {1}", processor, target.definition);
			}
			processor.preInit();
		}
	}
	
	/**
	 * Invokes the postDestroy methods on all processor for the specified target instance.
	 */
	protected function invokePostDestroyMethods () : void {
		for each (var processor:ObjectProcessor in processors) {
			processor.postDestroy();
		}
	}
	
	/**
	 * Processes all processor factories of the specified definition and creates new processors for 
	 * the target instance.
	 */
	protected function createProcessors () : void {
		for each (var factory:ObjectProcessorFactory in target.definition.processorFactories) {
			processors.push(factory.createInstance(target));
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

