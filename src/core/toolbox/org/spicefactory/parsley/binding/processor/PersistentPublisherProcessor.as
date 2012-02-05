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
import org.spicefactory.parsley.binding.impl.PersistentPublisher;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulProcessor;
import org.spicefactory.parsley.core.scope.Scope;

/**
 * Processes the persistence aspect of a published value.
 * It makes sure that the publisher is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class PersistentPublisherProcessor implements PropertyProcessor, StatefulProcessor {


	private var scope: String;
	private var id: String;
	private var persistentKey:Object;
	
	private var publisher:PersistentPublisher;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with to the BindingManager
	 * @param persistentKey the key the value is passed with to the PersistenceManager
	 */
	function PersistentPublisherProcessor (scope:String, id:String = null, persistentKey:Object = null) {
		this.scope = scope;
		this.id = id;		
		this.persistentKey = persistentKey;
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
	public function init (target:ManagedObject) : void {
		var scopeRef:Scope = getScope(target);
		this.publisher = new PersistentPublisher(scopeRef.persistenceManager, property.type, id, persistentKey); 
		scopeRef.bindingManager.addPublisher(publisher);
	}
	
	private function getScope (target: ManagedObject): Scope {
		return target.context.scopeManager.getScope(scope);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target:ManagedObject) : void {
		publisher.disableSubscriber();
		getScope(target).bindingManager.removePublisher(publisher);
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulProcessor {
		return new PersistentPublisherProcessor(scope, id, persistentKey);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[PersistentPublisher(property=" + property + ((id) ? ",id=" + id : "") + ")]";
	}

	
	
}
}
