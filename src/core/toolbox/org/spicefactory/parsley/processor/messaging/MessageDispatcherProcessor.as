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

package org.spicefactory.parsley.processor.messaging {
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.core.scope.ScopeManager;
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;

/**
 * Processor that injects a message dispatcher function into the target object for 
 * routing messages through the frameworks messaging system.
 * 
 * @author Jens Halm
 */
public class MessageDispatcherProcessor implements ObjectProcessor {
	
	
	private var target:ManagedObject;
	private var property:Property;
	private var dispatcher:MessageDispatcher;
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param target the target to listen to
	 * @param property the property to inject the dispatcher into
	 * @param dispatcherFactory the factory to create a new dispatcher for each target instance
	 */
	function MessageDispatcherProcessor (target:ManagedObject, property:Property, dispatcherFactory:MessageDispatcherFactory) {
		this.target = target;
		this.property = property;
		this.dispatcher = dispatcherFactory.createDispatcher();
	}

	
	/**
	 * @inheritDoc
	 */
	public function preInit () : void {
		property.setValue(target.instance, dispatcher.dispatchMessage);
	}
	
	/**
	 * @inheritDoc
	 */
	public function postDestroy () : void {
		dispatcher.disable();
		
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[MessageDispatcher(property=" + property.name + ")]";
	}	
	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param property the property to inject the dispatcher into
	 * @param scopeManager the scope manager the message should be dispatched through
	 * @param scope the scope the message should be dispatched to
	 * @return a new processor factory
	 */
	public static function newFactory (property:Property, scopeManager:ScopeManager, scope:String = null) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(MessageDispatcherProcessor, [property, new MessageDispatcherFactory(scopeManager, scope)]);
	}
	
	
}
}

import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.scope.ScopeManager;

class MessageDispatcherFactory {
	
	private var scopeManager:ScopeManager;
	private var scope:String;
	
	function MessageDispatcherFactory (scopeManager:ScopeManager, scope:String = null) {
		this.scopeManager = scopeManager;
		this.scope = scope;
	}

	public function createDispatcher () : MessageDispatcher {
		return new MessageDispatcher(scopeManager, scope);
	}
	
}


