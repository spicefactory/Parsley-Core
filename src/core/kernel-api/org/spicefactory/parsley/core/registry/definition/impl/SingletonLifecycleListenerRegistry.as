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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.SynchronizedObjectProvider;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.events.ObjectDefinitionRegistryEvent;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.SingletonObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;

import flash.events.Event;

[Deprecated]
/** 
 * @author Jens Halm
 */
public class SingletonLifecycleListenerRegistry extends DefaultLifecycleListenerRegistry {
	
	private var registry:ObjectDefinitionRegistry;
	private var provider:SynchronizedObjectProvider;
	
	function SingletonLifecycleListenerRegistry (definition:SingletonObjectDefinition, registry:ObjectDefinitionRegistry) {
		super(definition);
		this.registry = registry;
	}

	public override function synchronizeProvider (handler:Function) : LifecycleListenerRegistry {
		checkState();
		if (provider == null) {
			var id:String = definition.id;
			var providerDelegate:ObjectProvider = registry.createObjectProvider(definition.type.getClass(), id);
			provider = wrapProvider(providerDelegate);
			addListener(ObjectLifecycle.POST_INIT, postInit);
			addListener(ObjectLifecycle.POST_DESTROY, postDestroy);
			registry.addEventListener(ObjectDefinitionRegistryEvent.FROZEN, registryFrozen, false, 1);
		}
		addProviderHandler(handler);
		return this;
	}
	
	private function registryFrozen (event:Event) : void {
		registry.removeEventListener(ObjectDefinitionRegistryEvent.FROZEN, registryFrozen);
		registry.context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		invokeProviderHandlers(provider);
	}
	
	private function contextDestroyed (event:Event) : void {
		registry.context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		destroyProvider();
	}
	
	private function postInit (instance:Object, context:Context) : void {
		registry.context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}

	private function postDestroy (instance:Object, context:Context) : void {
		destroyProvider();
	}
	
	private function destroyProvider () : void {
		invokeDestroyHandlers(provider);
		provider = null;
	}
	
}
}

