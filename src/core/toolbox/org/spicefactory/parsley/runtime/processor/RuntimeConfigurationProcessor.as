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

package org.spicefactory.parsley.runtime.processor {

import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

/**
 * ConfigurationProcessor implementation that adds existing instances or simple class references 
 * to the Context.
 * 
 * @author Jens Halm
 */
public class RuntimeConfigurationProcessor implements ConfigurationProcessor {
	
	
	private var instances:Array = new Array();
	private var classes:Array = new Array();
	
	/**
	 * Creates a new instance.
	 * 
	 * @param instances the instances to add to the Context
	 */
	function RuntimeConfigurationProcessor (instances:Array = null) {
		if (instances != null) {
			for each (var instance:Object in instances) {
				addInstance(instance);
			}
		}
	}

	/**
	 * Adds the specified instance to the Context.
	 * 
	 * @param instance the instance to add to the Context
	 * @param id the optional id to register the instance with
	 */	
	public function addInstance (instance:Object, id:String = null) : void {
		instances.push(new InstanceDefinition(instance, id));
	}
	
	/**
	 * Adds the specified type to the Context.
	 * Specifying a type instead of an actual instance allows parameters
	 * like <code>lazy</code> or <code>singleton</code> to be set.
	 * 
	 * @param type the Class to add to the Context
	 * @param id the optional id to register the instance with
	 * @param singleton whether the Context should only create one instance of that type
	 * @param lazy whether the object should be lazily initialized 
	 * @param order the intialization order for the specified Class
	 */	
	public function addClass (type:Class, id:String = null, 
			singleton:Boolean = true, lazy:Boolean = false, order:int = int.MAX_VALUE) : void {
		classes.push(new ClassDefinition(type, id, singleton, lazy, order));		
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function processConfiguration (registry:ObjectDefinitionRegistry) : void {
		processInstances(registry);
		processClasses(registry);
	}
	
	private function processInstances (registry:ObjectDefinitionRegistry) : void {
		for each (var instanceDef:InstanceDefinition in instances) {
			registry.builders
				.forInstance(instanceDef.instance)
					.asSingleton()
						.id(instanceDef.id)
						.register();
		}
	}
	
	private function processClasses (registry:ObjectDefinitionRegistry) : void {
		for each (var classDef:ClassDefinition in classes) {
			if (classDef.singleton) {
				registry.builders
					.forClass(classDef.type)
						.asSingleton()
							.id(classDef.id)
							.lazy(classDef.lazy)
							.order(classDef.order)
							.register();
			}
			else {
				registry.builders
					.forClass(classDef.type)
						.asDynamicObject()
							.id(classDef.id)
							.register();
			}
		}
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "RuntimeConfig{" + (instances.length + classes.length) + " instance(s)}";
	}
}
}

class InstanceDefinition {

	internal var instance:Object;
	internal var id:String;
	
	function InstanceDefinition (instance:Object, id:String) {
		this.instance = instance;
		this.id = id;
	}
}

class ClassDefinition {
	
	internal var type:Class;
	internal var id:String;
	internal var singleton:Boolean;
	internal var lazy:Boolean;
	internal var order:int;
	
	function ClassDefinition (type:Class, id:String, singleton:Boolean, lazy:Boolean, order:int) {
		this.type = type;
		this.id = id;
		this.singleton = singleton;
		this.lazy = lazy;
		this.order = order;
	}
}
