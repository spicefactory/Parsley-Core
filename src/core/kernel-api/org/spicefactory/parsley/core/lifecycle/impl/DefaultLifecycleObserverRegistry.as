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
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;

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
		var target:MessageTarget = new ObjectLifecycleTarget(observer, selector);
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

import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.processor.messaging.receiver.AbstractMessageReceiver;

class ObjectLifecycleTarget extends AbstractMessageReceiver implements MessageTarget {
	
	private var observer:LifecycleObserver;
	
	function ObjectLifecycleTarget (observer:LifecycleObserver, selector:String) {
		super(observer.observedType, selector);
		this.observer = observer;
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		observer.observe(processor.message.instance);
	}
	
}

