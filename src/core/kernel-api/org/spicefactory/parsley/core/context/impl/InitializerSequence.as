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
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * Responsible for processing all non-lazy singletons that need to be instantiated upon Context creation.
 * 
 * @author Jens Halm
 */
public class InitializerSequence {
	
	
	private static const log:Logger = LogContext.getLogger(InitializerSequence);
	

	private var queuedInits:Array = new Array();
	
	private var activeAsyncDefinition:SingletonObjectDefinition;
	private var activeAsyncInstance:IEventDispatcher;
	private var parallelInits:Dictionary = new Dictionary();
	private var parallelInitCount:int = 0;
	
	private var context:DefaultContext;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the associated Context
	 */
	function InitializerSequence (context:DefaultContext) {
		this.context = context;
	}


	/**
	 * Adds a definition to this sequence.
	 * 
	 * @param def the definition to add to this sequence
	 */	
	public function addDefinition (def:ObjectDefinition) : void {
		queuedInits.push(def);
	}
	
	/**
	 * Starts processing the definitons that were added to this sequence.
	 */
	public function start () : void {
		var sortFunc:Function = function (def1:SingletonObjectDefinition, def2:SingletonObjectDefinition) : int {
			return (def1.order > def2.order) ? 1 
			: (def1.order < def2.order) ? -1
			: (def1.asyncInitConfig && !def2.asyncInitConfig) ? -1
			: (def2.asyncInitConfig && !def1.asyncInitConfig) ? 1 
			: 0;
		};
		queuedInits.sort(sortFunc);
		createInstances();
	}
	
	/**
	 * Cancels the initialization sequence.
	 */
	public function cancel () : void {
		if (activeAsyncInstance != null) {
			removeListeners(activeAsyncInstance, activeAsyncDefinition, activeInstanceComplete, activeInstanceError);
			activeAsyncInstance = null;
			activeAsyncDefinition = null;
		}
		for (var instance:Object in parallelInits) {
			var def:SingletonObjectDefinition = parallelInits[instance];
			removeListeners(instance as IEventDispatcher, def, parallelInstanceComplete, parallelInstanceError);
		}
		parallelInits = new Dictionary();
		parallelInitCount = 0;
	}

	/**
	 * Indicates whether all definitions of this sequence have completed their initialization.
	 */
	public function get complete () : Boolean {
		return queuedInits.length == 0 && parallelInitCount == 0;
	}
	
	private function createInstances () : void {
		while (!activeAsyncDefinition) {
			if (complete) {
				context.finishInitialization();
			}
			if (queuedInits.length == 0) {
				return;
			}
			var def:SingletonObjectDefinition = queuedInits.shift() as SingletonObjectDefinition;
			activeAsyncDefinition = (def.asyncInitConfig != null) ? def : null;
			activeAsyncInstance = null;
			try {
				context.getInstance(def);
			}
			catch (e:Error) {
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
	public function addInstance (object:ManagedObject) : void {
		var asyncObj:IEventDispatcher = IEventDispatcher(object.instance);
		var def:SingletonObjectDefinition = SingletonObjectDefinition(object.definition);
		if (def == activeAsyncDefinition) {
			activeAsyncInstance = asyncObj;
			asyncObj.addEventListener(def.asyncInitConfig.completeEvent, activeInstanceComplete);
			asyncObj.addEventListener(def.asyncInitConfig.errorEvent, activeInstanceError);
		} 
		else {
			/*
			 * Must be an initialization that was not triggered by this class.
			 * Instead it was either tiggered by application code accessing the Context before the
			 * INITIALIZED event or by a dependency of an object that this class initialized.
			 * We remove it from the list of queued inits and let it run in parallel to our queue. 
			 */
			var index:int = queuedInits.indexOf(def);
			if (index != -1) {
				log.warn("Unexpected parallel trigger of async initialization of " + def);
				queuedInits.splice(index, 1);
				parallelInits[object.instance] = def;
				parallelInitCount++;
				asyncObj.addEventListener(def.asyncInitConfig.completeEvent, parallelInstanceComplete);
				asyncObj.addEventListener(def.asyncInitConfig.errorEvent, parallelInstanceError);
			}
			else {
				// should never happen
				log.error("Unexpected async initialization of " + def);
			}
		}
	}
	
	
	private function activeInstanceComplete (event:Event) : void {
		removeListeners(IEventDispatcher(event.target), activeAsyncDefinition, activeInstanceComplete, activeInstanceError);
		activeAsyncDefinition = null;
		activeAsyncInstance = null;
		createInstances();
	}
	
	private function activeInstanceError (event:ErrorEvent) : void {
		removeListeners(IEventDispatcher(event.target), activeAsyncDefinition, activeInstanceComplete, activeInstanceError);
		context.destroyWithError("Asynchronous initialization of " + activeAsyncDefinition + " failed", event);
	}
	
	private function parallelInstanceComplete (event:Event) : void {
		var def:SingletonObjectDefinition = removeParallelInit(event.target, false);
		removeListeners(IEventDispatcher(event.target), def, parallelInstanceComplete, parallelInstanceError);
		if (complete) context.finishInitialization();
	}
	
	private function parallelInstanceError (event:ErrorEvent) : void {
		var def:SingletonObjectDefinition = removeParallelInit(event.target, true);
		removeListeners(IEventDispatcher(event.target), def, parallelInstanceComplete, parallelInstanceError);
		context.destroyWithError("Asynchronous initialization of " + def + " failed", event);
	}
	
	private function removeParallelInit (instance:Object, error:Boolean) : SingletonObjectDefinition {
		var def:SingletonObjectDefinition = parallelInits[instance];
		if (def != null) {
			delete parallelInits[instance];
			parallelInitCount--;
		}
		else {
			// should never happen
			log.warn("Internal error: Unexpected event for async-init instance of type " + getQualifiedClassName(instance));
		}
		return def;
	}

	private function removeListeners (asyncObj:IEventDispatcher, def:SingletonObjectDefinition, 
			complete:Function, error:Function) : void {
		if (def == null) return;
		asyncObj.removeEventListener(def.asyncInitConfig.completeEvent, complete);
		asyncObj.removeEventListener(def.asyncInitConfig.errorEvent, error);			
	}
	
	
}
}
