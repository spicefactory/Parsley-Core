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
import org.spicefactory.parsley.binding.Publisher;
import org.spicefactory.parsley.binding.impl.PropertyPublisher;
import org.spicefactory.parsley.binding.impl.SubscribingPropertyPublisher;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;

/**
 * Processes a single property holding a a value that
 * should be published to matching subscribers.
 * It makes sure that the publisher is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class PublisherProcessor implements ObjectProcessor {


	private var target:ManagedObject;
	private var publisher:Publisher;
	private var manager:BindingManager;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the managed target object
	 * @param property the target property that holds the published value
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with
	 * @param managed whether the published object should be added to the Context while being published
	 * @param subscribe whether the publisher should also act as a subscriber
	 * @param changeEvent the event type that signals that the property value has changed (has no effect in Flex applications)
	 */
	function PublisherProcessor (target:ManagedObject, property:Property, scope:String, id:String = null,
			managed:Boolean = false, subscribe:Boolean = false, changeEvent:String = null) {
		this.target = target;
		var context:Context = (managed) ? target.context : null;
		this.publisher = (subscribe)
				? new SubscribingPropertyPublisher(target.instance, property, property.type, id, context, changeEvent)
				: new PropertyPublisher(target.instance, property, property.type, id, context, changeEvent);
		this.manager = target.context.scopeManager.getScope(scope)
				.extensions.forType(BindingManager) as BindingManager;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function preInit () : void {
		manager.addPublisher(publisher);
	}
	
	/**
	 * @inheritDoc
	 */
	public function postDestroy () : void {
		manager.removePublisher(publisher);
	}
	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param property the target property that holds the published value
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with
	 * @param managed whether the published object should be added to the Context while being published
	 * @param subscribe whether the publisher should also act as a subscriber
	 * @param changeEvent the event that signals that the property value has changed (has no effect in Flex applications)
	 * @return a new processor factory 
	 */
	public static function newFactory (property:Property, scope:String, id:String = null, 
			managed:Boolean = false, subscribe:Boolean = false, changeEvent:String = null) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(PublisherProcessor, [property, scope, id, managed, subscribe, changeEvent]);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return (publisher as Object).toString();
	}
	
	
}
}
