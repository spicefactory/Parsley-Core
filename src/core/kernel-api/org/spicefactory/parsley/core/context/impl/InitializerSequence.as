/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.spicefactory.parsley.core.context.impl {

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.events.ErrorEvent;
import flash.events.Event;

/**
 * Responsible for processing all non-lazy singletons that need to be instantiated upon Context creation.
 *
 * @author Jens Halm
 */
public class InitializerSequence {


	private static const log: Logger = LogContext.getLogger(InitializerSequence);
	private var queuedInits: Array = new Array();
	private var queuedAsync: AsyncInitGroup;
	private var unqueuedAsync: AsyncInitGroup;
	private var context: DefaultContext;


	/**
	 * Creates a new instance.
	 *
	 * @param context the associated Context
	 */
	function InitializerSequence (context: DefaultContext) {
		this.context = context;
		this.queuedAsync = new AsyncInitGroup(context);
		this.unqueuedAsync = new AsyncInitGroup(context);
		queuedAsync.addEventListener(Event.COMPLETE, queuedAsyncComplete);
		unqueuedAsync.addEventListener(Event.COMPLETE, unqueuedAsyncComplete);
		queuedAsync.addEventListener(ErrorEvent.ERROR, asyncError);
		unqueuedAsync.addEventListener(ErrorEvent.ERROR, asyncError);
	}

	/**
	 * Adds a definition to this sequence.
	 *
	 * @param def the definition to add to this sequence
	 */
	public function addDefinition (def: ObjectDefinition): void {
		queuedInits.push(def);
	}

	/**
	 * Starts processing the definitons that were added to this sequence.
	 */
	public function start (): void {
		var sortFunc: Function = function (def1: SingletonObjectDefinition, def2: SingletonObjectDefinition): int {
			return (def1.order > def2.order) ? 1 : (def1.order < def2.order) ? -1 : (def1.asyncInitConfig && !def2.asyncInitConfig) ? -1 : (def2.asyncInitConfig && !def1.asyncInitConfig) ? 1 : 0;
		};
		queuedInits.sort(sortFunc);
		createInstances();
	}

	/**
	 * Cancels the initialization sequence.
	 */
	public function cancel (): void {
		queuedAsync.cancel();
		unqueuedAsync.cancel();
	}

	/**
	 * Indicates whether all definitions of this sequence have completed their initialization.
	 */
	public function get complete (): Boolean {
		return queuedInits.length == 0 && queuedAsync.empty && unqueuedAsync.empty;
	}

	private function createInstances (): void {
		var lastAsyncOrder: Number = NaN;

		while (true) {
			if (complete) {
				context.finishInitialization();
			}

			if (queuedInits.length == 0) {
				return;
			}
			var def: SingletonObjectDefinition = queuedInits[0] as SingletonObjectDefinition;

			if ((def.order == lastAsyncOrder && def.asyncInitConfig != null) || isNaN(lastAsyncOrder) || queuedAsync.empty) {
				lastAsyncOrder = def.order;
				queuedInits.shift();
			}
			else {
				return;
			}

			try {
				context.getInstance(def, def.asyncInitConfig != null);
			}
			catch (e: Error) {
				context.destroyWithError("Initialization of " + def + " failed", e);
				return;
			}
		}
	}

	/**
	 * Adds a new instance to be watched by this sequence for completion of its asynchronous initialization.
	 *
	 * @param object the object to watch
	 */
	public function handleAsyncInit (object: ManagedObject, isQueued: Boolean): void {
		if (isQueued) {
			queuedAsync.addObject(object);
		}
		else {
			/*
			 * Must be an initialization that was not triggered by this class.
			 * Instead it was either tiggered by application code accessing the Context before the
			 * INITIALIZED event or by a dependency of an object that this class initialized.
			 * We remove it from the list of queued inits and let it run in parallel to our queue.
			 */
			var index: int = queuedInits.indexOf(object.definition);

			if (index != -1) {
				queuedInits.splice(index, 1);
				log.warn("Unexpected parallel trigger of async initialization of " + object.definition);
				unqueuedAsync.addObject(object);
			}
			else {
				// we should never get here
				log.error("Unexpected async initialization of " + object.definition);
			}
		}
	}

	private function queuedAsyncComplete (event: Event): void {
		createInstances();
	}

	private function unqueuedAsyncComplete (event: Event): void {
		if (complete) {
			context.finishInitialization();
		}
	}

	private function asyncError (event: ErrorEvent): void {
		context.destroyWithError("Initialization of singletons failed", event);
	}
}
}

import org.spicefactory.lib.events.NestedErrorEvent;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

class AsyncInitGroup extends EventDispatcher {


	private var context: Context;
	private var objects: Dictionary = new Dictionary();
	private var cnt: int;


	function AsyncInitGroup (context: Context) {
		this.context = context;
	}

	public function get empty (): Boolean {
		return (cnt == 0);
	}

	public function addObject (object: ManagedObject): void {
		if (!objects[object.instance]) {
			objects[object.instance] = object;
			cnt++;
		}
		var asyncObj: IEventDispatcher = IEventDispatcher(object.instance);
		var def: SingletonObjectDefinition = SingletonObjectDefinition(object.definition);
		asyncObj.addEventListener(def.asyncInitConfig.completeEvent, asyncComplete);
		asyncObj.addEventListener(def.asyncInitConfig.errorEvent, asyncError);
	}

	private function asyncComplete (event: Event): void {
		removeObject(event.target);

		if (empty) {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	private function asyncError (event: Event): void {
		var object: ManagedObject = objects[event.target];

		if (removeObject(event.target)) {
			dispatchEvent(new NestedErrorEvent(ErrorEvent.ERROR, event, "Asynchronous initialization of " + object.definition + " failed"));
		}
	}

	private function removeObject (instance: Object): Boolean {
		var object: ManagedObject = objects[instance];

		if (object) {
			delete objects[instance];
			cnt--;
			removeListeners(object);
			return true;
		}
		return false;
	}

	public function cancel (): void {
		for each (var object:ManagedObject in objects) {
			removeListeners(object);
		}
		objects = null;
		cnt = 0;
	}

	private function removeListeners (object: ManagedObject): void {
		var asyncObj: IEventDispatcher = IEventDispatcher(object.instance);
		var def: SingletonObjectDefinition = SingletonObjectDefinition(object.definition);
		asyncObj.removeEventListener(def.asyncInitConfig.completeEvent, asyncComplete);
		asyncObj.removeEventListener(def.asyncInitConfig.errorEvent, asyncError);
	}
	
	
}
