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

import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.BindingManager;
import org.spicefactory.parsley.binding.PersistenceManager;
import org.spicefactory.parsley.binding.impl.PersistentPublisher;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.StatefulProcessor;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeName;

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
	
	private var publisher:PersistentPublisher;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the managed target object
	 * @param property the target property that holds the published value
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with
	 */
	function PersistentPublisherProcessor (scope:String, id:String = null) {
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
	public function init (target:ManagedObject) : void {
		var scopeRef:Scope = target.context.scopeManager.getScope(scope);
		this.publisher = new PersistentPublisher(getPersistenceManager(scopeRef), scopeRef.uuid, property.type, id); 
		getManager(target).addPublisher(publisher);
	}
	
	private function getPersistenceManager (scope:Scope) : PersistenceManager {
		if (scope.extensions.hasType(PersistenceManager)) {
			return scope.extensions.forType(PersistenceManager) as PersistenceManager;
		}
		else {
			return scope.rootContext.scopeManager.getScope(ScopeName.GLOBAL)
				.extensions.forType(PersistenceManager) as PersistenceManager;
		}
	}
	
	private function getManager (target: ManagedObject): BindingManager {
		return target.context.scopeManager.getScope(scope)
			.extensions.forType(BindingManager) as BindingManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target:ManagedObject) : void {
		publisher.disableSubscriber();
		getManager(target).removePublisher(publisher);
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulProcessor {
		return new PersistentPublisherProcessor(scope, id);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return publisher.toString();
	}
	
	
}
}
