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

package org.spicefactory.parsley.core.scope.impl {
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.scope.ObjectLifecycleScope;

import flash.utils.Dictionary;

[Deprecated(replacement="org.spicefactory.parsley.core.lifecycle.impl.DefaultLifecycleObserverRegistry")]
public class DefaultObjectLifecycleScope implements ObjectLifecycleScope {

	private var listeners:Dictionary = new Dictionary();
	private var providers:Dictionary = new Dictionary();
	private var receiverRegistry:MessageReceiverRegistry;
	
	function DefaultObjectLifecycleScope (receiverRegistry:MessageReceiverRegistry) {
		this.receiverRegistry = receiverRegistry;
	}

	public function addListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void {
		var selector:String = getSelector(event, id);
		var target:MessageTarget = new ObjectLifecycleListener(type, selector, listener);
		var targets:Array = listeners[listener];
		if (targets == null) {
			targets = new Array();
			listeners[listener] = targets;
		}
		targets.push(target);
		receiverRegistry.addTarget(target);
	}
	
	public function removeListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void {
		var targets:Array = listeners[listener];
		if (targets == null) {
			return;
		}
		var selector:String = getSelector(event, id);
		for each (var target:MessageTarget in targets) {
			if (target.messageType == type && target.selector == selector) {
				ArrayUtil.remove(targets, target);
				receiverRegistry.removeTarget(target);
				if (targets.length == 0) {
					delete listeners[listener];
				}
				break;
			}
		}
	}
	
	public function addProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void {
		var selector:String = getSelector(event, id);
		var target:MessageTarget = new ObjectLifecycleHandler(provider, methodName, selector);
		var targets:Array = providers[provider];
		if (targets == null) {
			targets = new Array();
			providers[provider] = targets;
		}
		targets.push(target);
		receiverRegistry.addTarget(target);
	}
	
	public function removeProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void {
		var targets:Array = providers[provider];
		if (targets == null) {
			return;
		}
		var selector:String = getSelector(event, id);
		for each (var target:ObjectLifecycleHandler in targets) {
			if (target.methodName == methodName && target.selector == selector) {
				ArrayUtil.remove(targets, target);
				receiverRegistry.removeTarget(target);
				if (targets.length == 0) {
					delete providers[provider];
				}
				break;
			}
		}
	}
	
	private function getSelector (event:ObjectLifecycle, id:String = null) : String {
		return (id == null) ? event.key : event.key + ":" + id;
	}
	
	
}
}

import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.processor.messaging.receiver.AbstractMessageReceiver;
import org.spicefactory.parsley.processor.messaging.receiver.MessageHandler;

class ObjectLifecycleListener extends AbstractMessageReceiver implements MessageTarget {
	
	private var listener:Function;
	
	function ObjectLifecycleListener (type:Class, selector:String, listener:Function) {
		super(type, selector);
		this.listener = listener;
	}
	
	public function handleMessage (processor:MessageProcessor) : void {
		listener(processor.message);
	}
	
}

class ObjectLifecycleHandler extends MessageHandler {
	
	private var listener:Function;
	
	function ObjectLifecycleHandler (provider:ObjectProvider, methodName:String, selector:String) {
		super(provider, methodName, selector);
	}
	
	public function get methodName () : String {
		return targetMethod.name;
	}
	
}
