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

package org.spicefactory.parsley.lifecycle.processor {

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserver;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.processor.MethodProcessor;
import org.spicefactory.parsley.core.processor.SingletonPreProcessor;
import org.spicefactory.parsley.core.processor.StatefulObjectProcessor;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.lifecycle.observer.DefaultLifecycleObserver;


/**
 * Processor that registers and unregisters observers for the lifecycle of other objects.
 * 
 * @author Jens Halm
 */
public class ObserveMethodProcessor implements MethodProcessor, StatefulObjectProcessor, SingletonPreProcessor {


	private var method:Method;
	private var phase:ObjectLifecycle;
	private var objectId:String;
	private var scopeName:String;
	
	private var observer:LifecycleObserver;
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param phase the object lifecycle phase to listen for
	 * @param objectId the id of the object to observe
	 * @param scopeName the name of the scope to observe
	 */
	function ObserveMethodProcessor (phase:ObjectLifecycle, objectId:String, scopeName:String) {
		this.phase = phase;
		this.objectId = objectId;
		this.scopeName = scopeName;
	}
	
	/**
	 * @inheritDoc
	 */
	public function targetMethod (method: Method): void {
		this.method = method;
	}
	
	/**
	 * @inheritDoc
	 */
	public function preProcess (definition: SingletonObjectDefinition): void {
		var provider:ObjectProvider = Provider.forDefinition(definition);
		addObserver(provider, definition.registry.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroyBeforeInit (definition: SingletonObjectDefinition): void {
		removeObserver(definition.registry.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		if (!observer) {
			var provider: ObjectProvider = Provider.forInstance(target.instance, target.definition.registry.domain);
			addObserver(provider, target.context);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		removeObserver(target.context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulObjectProcessor {
		return new ObserveMethodProcessor(phase, objectId, scopeName);
	}

	private function addObserver (provider: ObjectProvider, context: Context) : void {
		observer = new DefaultLifecycleObserver(provider, method.name, phase, objectId);
		var scope: Scope = context.scopeManager.getScope(scopeName);
		scope.lifecycleObservers.addObserver(observer);
	}
	
	private function removeObserver (context: Context) : void {
		if (!observer) return;
		var scope: Scope = context.scopeManager.getScope(scopeName);
		scope.lifecycleObservers.removeObserver(observer);
	}

	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ObserveMethod(method=" + method + ")]";
	}

	
}
}

