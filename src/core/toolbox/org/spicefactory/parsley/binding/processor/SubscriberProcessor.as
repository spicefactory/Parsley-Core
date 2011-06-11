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
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;

/**
 * Processes a single property holding a a value that
 * that should be bound to the value of a matching publisher.
 * It makes sure that the subscriber is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class SubscriberProcessor implements ObjectProcessor {


	private var target:ManagedObject;
	private var subscriber:Subscriber;
	private var manager:BindingManager;

	/**
	 * Creates a new instance.
	 * 
	 * @param target the managed target object
	 * @param property the target property that binds to the source value
	 * @param scope the scope the binding listens to
	 * @param id the id the source is published with
	 */
	function SubscriberProcessor (target:ManagedObject, property:Property, scope:String, id:String = null) {
		this.target = target;
		this.subscriber = new PropertySubscriber(target.instance, property, property.type, id);
		this.manager = target.context.scopeManager.getScope(scope)
				.extensions.forType(BindingManager) as BindingManager;
	}

	/**
	 * @inheritDoc
	 */
	public function preInit () : void {
		manager.addSubscriber(subscriber);
	}
	
	/**
	 * @inheritDoc
	 */
	public function postDestroy () : void {
		manager.removeSubscriber(subscriber);
	}
	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param property the target property that binds to the source value
	 * @param scope the scope the binding listens to
	 * @param id the id the source is published with
	 * @return a new processor factory 
	 */
	public static function newFactory (property:Property, scope:String, id:String = null) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(SubscriberProcessor, [property, scope, id]);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return (subscriber as Object).toString();
	}
	
	
}
}
