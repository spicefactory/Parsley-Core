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

package org.spicefactory.parsley.processor.lifecycle {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.scope.Scope;

import flash.events.Event;

/**
 * Processor that registers and unregisters observers for the lifecycle of other objects.
 * This implementation adds synchronization features for singleton definitions to make sure
 * that they do not miss lifecycle events in case the observed object is initialized earlier.
 * To accomplish this the processor registers a proxy listener before the actual target 
 * object gets created.
 * 
 * @author Jens Halm
 */
public class ObserveMethodProcessorFactory implements ObjectProcessorFactory {


	private var definition:SingletonObjectDefinition;
	private var method:String;
	private var phase:ObjectLifecycle;
	private var objectId:String;
	private var context:Context;
	private var scope:Scope;
	
	private var processor:ObserveMethodProcessor;

	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param definition the definition for the target object receiving the message
	 * @param the name of the target observer method
	 * @param phase the object lifecycle phase to listen for
	 * @param objectId the id of the object to observe
	 * @param context the Context the receiving object belongs to
	 * @param scopeName the name of the scope to observe
	 */
	function ObserveMethodProcessorFactory (definition:ObjectDefinition, method:String, phase:ObjectLifecycle, objectId:String, 
			context:Context, scopeName:String) {
		this.method = method;
		this.phase = phase;
		this.objectId = objectId;
		this.scope = context.scopeManager.getScope(scopeName);
		this.context = context;
		if (definition is SingletonObjectDefinition) {
			this.definition = SingletonObjectDefinition(definition);
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
		}
	}
	
	private function contextConfigured (event:Event) : void {
		context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		processor = new ObserveMethodProcessor(Provider.forDefinition(definition, context), method, phase, objectId, scope);
		processor.addObserver();
	}
	
	private function contextDestroyed (event:Event) : void {
		context.removeEventListener(ContextEvent.DESTROYED, contextConfigured);
		processor.removeObserver();
	}

	/**
	 * @inheritDoc
	 */
	public function createInstance (target:ManagedObject) : ObjectProcessor {
		if (processor != null) {
			context.removeEventListener(ContextEvent.DESTROYED, contextConfigured);
			return processor;
		}
		else {
			var provider:ObjectProvider = Provider.forInstance(target.instance, target.definition.registry.domain);
			return new ObserveMethodProcessor(provider, method, phase, objectId, scope);
		}
	}
}
}

import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.processor.lifecycle.DefaultLifecycleObserver;

class ObserveMethodProcessor implements ObjectProcessor {


	private var provider:ObjectProvider;
	
	private var method:String;
	private var phase:ObjectLifecycle;
	private var objectId:String;
	private var scope:Scope;
	
	private var observer:LifecycleObserver;
	
	
	function ObserveMethodProcessor (provider:ObjectProvider, method:String, phase:ObjectLifecycle, objectId:String, scope:Scope) {
		this.provider = provider;
		this.method = method;
		this.phase = phase;
		this.objectId = objectId;
		this.scope = scope;
	}

	
	public function preInit () : void {
		if (!observer) addObserver();
	}
	
	public function postDestroy () : void {
		if (observer) removeObserver();
	}
	
	public function addObserver () : void {
		observer = new DefaultLifecycleObserver(provider, method, phase, objectId);
		scope.lifecycleObservers.addObserver(observer);
	}
	
	public function removeObserver () : void {
		scope.lifecycleObservers.removeObserver(observer);
	}

	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ObserveMethod(method=" + method + ")]";
	}	
	
	
}


