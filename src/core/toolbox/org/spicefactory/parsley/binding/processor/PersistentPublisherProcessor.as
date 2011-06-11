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
import org.spicefactory.parsley.binding.PersistenceManager;
import org.spicefactory.parsley.binding.impl.PersistentPublisher;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;

/**
 * Processes the persistence aspect of a published value.
 * It makes sure that the publisher is registered with the corresponding
 * BindingManager of the target scope during the lifetime of a managed object.
 * 
 * @author Jens Halm
 */
public class PersistentPublisherProcessor implements ObjectProcessor {


	private var target:ManagedObject;
	private var publisher:PersistentPublisher;
	private var manager:BindingManager;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the managed target object
	 * @param property the target property that holds the published value
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with
	 */
	function PersistentPublisherProcessor (target:ManagedObject, property:Property, scope:Scope, id:String = null) {
		this.target = target;
		this.publisher = new PersistentPublisher(getPersistenceManager(scope), scope.uuid, property.type, id); 
		this.manager = scope.extensions.forType(BindingManager) as BindingManager;
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
		publisher.disableSubscriber();
		manager.removePublisher(publisher);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return publisher.toString();
	}
	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param property the target property that holds the published value
	 * @param scope the scope the property value is published to
	 * @param id the id the value is published with
	 * @return a new processor factory 
	 */
	public static function newFactory (property:Property, scope:Scope, id:String = null) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(PersistentPublisherProcessor, [property, scope, id]);
	}
	
	
}
}
