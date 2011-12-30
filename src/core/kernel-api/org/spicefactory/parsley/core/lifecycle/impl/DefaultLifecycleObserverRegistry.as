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

package org.spicefactory.parsley.core.lifecycle.impl {

import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

import flash.utils.Dictionary;

/**
 * Default implementation of the LifecycleObserverRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultLifecycleObserverRegistry implements LifecycleObserverRegistry {


	private var targets:Dictionary = new Dictionary();
	private var receiverRegistry:MessageReceiverRegistry;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param receiverRegistry the registry for the object lifecycle listeners
	 */
	function DefaultLifecycleObserverRegistry (receiverRegistry:MessageReceiverRegistry) {
		this.receiverRegistry = receiverRegistry;
	}


	/**
	 * @inheritDoc
	 */
	public function addObserver (observer:LifecycleObserver) : void {
		if (targets[observer]) return;
		var selector:String = (observer.objectId == null) ? observer.phase.key : observer.phase.key + ":" + observer.objectId;
		var target:MessageTarget = new ObserverTarget(observer, selector);
		targets[observer] = target;
		receiverRegistry.addTarget(target);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeObserver (observer:LifecycleObserver) : void {
		var target:MessageTarget = targets[observer];
		if (!target) return;
		delete targets[observer];
		receiverRegistry.removeTarget(target);
	}
	
	
}
}

import org.spicefactory.lib.reflect.Member;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.processor.DestroyPhase;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.ObjectProcessor;
import org.spicefactory.parsley.core.processor.ObjectProcessorConfig;

import flash.errors.IllegalOperationError;

class ObserverTarget implements MessageTarget, ObjectProcessorConfig, ObjectProcessor {
	
	private var observer:LifecycleObserver;
	private var _selector:String;
	private var phase:Object;
	
	function ObserverTarget (observer:LifecycleObserver, selector:String) {
		this.observer = observer;
		_selector = selector;
		
		if (observer.phase == ObjectLifecycle.PRE_INIT) {
			phase = InitPhase.preInit(int.MAX_VALUE);
		}
		else if (observer.phase == ObjectLifecycle.POST_INIT) {
			phase = InitPhase.postInit(int.MIN_VALUE);
		}
		else if (observer.phase == ObjectLifecycle.PRE_DESTROY) {
			phase = DestroyPhase.preDestroy(int.MAX_VALUE);
		}
		else if (observer.phase == ObjectLifecycle.POST_DESTROY) {
			phase = DestroyPhase.postDestroy(int.MIN_VALUE);
		}
	}

	public function get type (): Class {
		return observer.observedType;
	}

	public function get selector (): * {
		return _selector;
	}

	public function get order (): int {
		return int.MAX_VALUE;
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		throw new IllegalOperationError("This message target is only used for registration purposes");
	}

	public function get processor (): ObjectProcessor {
		return this;
	}

	public function get initPhase (): InitPhase {
		return (phase is InitPhase) ? phase as InitPhase : InitPhase.init();
	}

	public function get destroyPhase (): DestroyPhase {
		return (phase is DestroyPhase) ? phase as DestroyPhase : DestroyPhase.destroy();
	}

	public function get target (): Member {
		return null;
	}

	public function prepareForNextTarget (): ObjectProcessorConfig {
		return this;
	}

	public function init (target: ManagedObject): void {
		if (phase is InitPhase) invokeObserver(target.instance);
	}

	public function destroy (target: ManagedObject): void {
		if (phase is DestroyPhase) invokeObserver(target.instance);
	}
	
	private function invokeObserver (observed:Object): void {
		observer.observe(observed);
	}
	
}

