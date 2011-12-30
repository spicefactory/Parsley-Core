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
 
package org.spicefactory.parsley.binding.processor {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.BindingManager;
import org.spicefactory.parsley.binding.Subscriber;
import org.spicefactory.parsley.binding.impl.PropertySubscriber;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulObjectProcessor;

/**
 * Processes a single property holding a a value that
 * that should be bound to the value of a matching publisher.
 * It makes sure that the subscriber is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class SubscriberProcessor implements PropertyProcessor, StatefulObjectProcessor {


	private var scope:String;
	private var id:String;

	private var subscriber:Subscriber;

	/**
	 * Creates a new instance.
	 * 
	 * @param scope the scope the binding listens to
	 * @param id the id the source is published with
	 */
	function SubscriberProcessor (scope:String, id:String = null) {
		this.scope = scope;
		this.id = id;
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
	public function init (target: ManagedObject): void {
		this.subscriber = new PropertySubscriber(target.instance, property, property.type, id);
		getManager(target).addSubscriber(subscriber);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject): void {
		getManager(target).removeSubscriber(subscriber);
	}
	
	private function getManager (target: ManagedObject): BindingManager {
		return target.context.scopeManager.getScope(scope)
			.extensions.forType(BindingManager) as BindingManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulObjectProcessor {
		return new SubscriberProcessor(scope, id);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return (subscriber as Object).toString();
	}
	

}
}
