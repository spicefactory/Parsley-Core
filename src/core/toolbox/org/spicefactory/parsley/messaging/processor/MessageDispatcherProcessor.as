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

package org.spicefactory.parsley.messaging.processor {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulProcessor;

/**
 * Processor that injects a message dispatcher function into the target object for 
 * routing messages through the frameworks messaging system.
 * 
 * @author Jens Halm
 */
public class MessageDispatcherProcessor implements PropertyProcessor, StatefulProcessor {
	
	
	private var scope:String;
	
	private var dispatcher:MessageDispatcher;
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param target the target to listen to
	 * @param property the property to inject the dispatcher into
	 * @param dispatcherFactory the factory to create a new dispatcher for each target instance
	 */
	function MessageDispatcherProcessor (scope:String = null) {
		this.scope = scope;
	}
	
	
	private var property: Property;
	
	/**
	 * @inheritDoc
	 */
	public function targetProperty (property: Property): void {
		this.property = property;
	}

	
	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		this.dispatcher = new MessageDispatcher(target.context.scopeManager, scope, this);
		property.setValue(target.instance, dispatcher.dispatchMessage);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		dispatcher.disable();
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone () : StatefulProcessor {
		return new MessageDispatcherProcessor(scope);
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[MessageDispatcher(" + property + ")]";
	}	
	
	
}
}
