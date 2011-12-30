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
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulProcessor;

/**
 * Processes a single property holding a a value that
 * should be published to matching subscribers.
 * It makes sure that the publisher is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class PublisherProcessor implements PropertyProcessor, StatefulProcessor {


	private var scope: String;
	private var id: String;
	
	private var managed: Boolean;
	private var publisherType: Class;
	
	private var changeEvent: String;

	private var publisher: Publisher;


	/**
	 * Creates a new instance.
	 * 
	 * @param publisherType the Class to use as a publisher
	 * @param scope the scope the binding listens to
	 * @param id the id the source is published with
	 * @param managed whether the published object should be added to the Context while being published
	 * @param changeEvent the event type that signals that the property value has changed (has no effect in Flex applications)
	 */
	function PublisherProcessor (publisherType: Class, scope:String, id:String = null,
			managed:Boolean = false, changeEvent:String = null) {

		this.publisherType = publisherType;
		this.scope = scope;
		this.id = id;
		this.managed = managed;
		this.changeEvent = changeEvent;
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
		var context:Context = (managed) ? target.context : null;
		
		this.publisher = new publisherType(target.instance, property, property.type, id, context, changeEvent);
				
		getManager(target).addPublisher(publisher);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject): void {
		getManager(target).removePublisher(publisher);
	}
	
	private function getManager (target: ManagedObject): BindingManager {
		return target.context.scopeManager.getScope(scope)
			.extensions.forType(BindingManager) as BindingManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulProcessor {
		return new PublisherProcessor(publisherType, scope, id, managed, changeEvent);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return (publisher as Object).toString();
	}

	
}
}
