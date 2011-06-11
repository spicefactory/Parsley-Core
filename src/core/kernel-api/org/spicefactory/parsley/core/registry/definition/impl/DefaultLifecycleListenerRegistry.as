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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.SynchronizedObjectProvider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;

import flash.utils.Dictionary;

[Deprecated]
/**
 * @author Jens Halm
 */
public class DefaultLifecycleListenerRegistry extends AbstractRegistry implements LifecycleListenerRegistry {

	private var listeners:Dictionary = new Dictionary();
	private var providers:Dictionary = new Dictionary();
	private var providerHandlers:Array = new Array();

	function DefaultLifecycleListenerRegistry (def:ObjectDefinition) {
		super(def);
	}

	public function synchronizeProvider (handler:Function) : LifecycleListenerRegistry {
		checkState();
		if (providerHandlers.length == 0) {
			addListener(ObjectLifecycle.PRE_INIT, createProvider);
			addListener(ObjectLifecycle.POST_DESTROY, destroyProvider);
		}
		addProviderHandler(handler);
		return this;
	}
	
	private function createProvider (instance:Object, context:Context) : void {
		if (providerHandlers.length == 0) return;
		var provider:SynchronizedObjectProvider = wrapProvider(new Provider(instance, definition));
		providers[instance] = provider;
		invokeProviderHandlers(provider);
	}

	private function destroyProvider (instance:Object, context:Context) : void {
		if (providers[instance] != undefined) {
			var provider:SynchronizedProvider = SynchronizedProvider(providers[instance]);
			invokeDestroyHandlers(provider);
		}
		delete providers[instance];
	}
	
	protected function addProviderHandler (handler:Function) : void {
		providerHandlers.push(handler);
	}
	
	protected function invokeProviderHandlers (provider:SynchronizedObjectProvider) : void {
		for each (var handler:Function in providerHandlers) {
			handler(provider);
		}
	}
	
	protected function invokeDestroyHandlers (provider:SynchronizedObjectProvider) : void {
		SynchronizedProvider(provider).invokeDestroyHandlers();
	}
	
	protected function wrapProvider (provider:ObjectProvider) : SynchronizedObjectProvider {
		return new SynchronizedProvider(provider);
	}

	public function addListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry {
		checkState();
		var arr:Array = listeners[event.key];
		if (arr == null) {
			arr = new Array();
			listeners[event.key] = arr;
		}
		arr.push(listener);
		return this;
	}
	
	public function removeListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry {
		checkState();
		var arr:Array = listeners[event.key];
		if (arr == null) {
			return this;
		}
		ArrayUtil.remove(arr, listener);
		return this;
	}
	
	public function getListeners (event:ObjectLifecycle) : Array {
		var arr:Array = listeners[event.key];
		return (arr == null) ? [] : arr.concat();
	}
	

}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.util.Delegate;
import org.spicefactory.lib.util.DelegateChain;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.SynchronizedObjectProvider;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

class Provider implements ObjectProvider {

	private var _instance:Object;
	private var definition:ObjectDefinition;

	function Provider (instance:Object, definition:ObjectDefinition) {
		_instance = instance;
		this.definition = definition;
	}

	public function get instance ():Object {
		return _instance;
	}
	
	public function get type ():ClassInfo {
		return definition.type;
	}
	
}

class SynchronizedProvider implements SynchronizedObjectProvider {

	private var delegate:ObjectProvider;
	private var destroyHandlers:DelegateChain = new DelegateChain();

	function SynchronizedProvider (delegate:ObjectProvider) {
		this.delegate = delegate;
	}

	public function get instance ():Object {
		return delegate.instance;
	}
	
	public function get type ():ClassInfo {
		return delegate.type;
	}
	
	public function addDestroyHandler (handler:Function, ...params:*) : void {
		destroyHandlers.addDelegate(new Delegate(handler, params));
	}
	
	public function invokeDestroyHandlers () : void {
		destroyHandlers.invoke();
	}
}


