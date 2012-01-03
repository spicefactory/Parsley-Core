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

package org.spicefactory.parsley.resources.processor {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.PropertyProcessor;
import org.spicefactory.parsley.core.processor.StatefulProcessor;

import flash.utils.getQualifiedClassName;


/**
 * Processes a resource binding for a single target property.
 * The resource value will be injected at the time the object is constructed and
 * then each time the corresponding ResourceManager updates.
 * 
 * @author Jens Halm
 */
public class ResourceBindingProcessor implements PropertyProcessor, StatefulProcessor {


	/**
	 * The type of the adapter to use. 
	 * The processor need to adapt to either the Flex ResourceManager or the Parsley Flash ResourceManager.
	 */
	public static var adapterClass:Class;

	private static var adapter:ResourceBindingAdapter;
	

	private static function initializeAdapter () : void {
		if (adapter == null) {
			if (adapterClass == null) {
				throw new ObjectDefinitionBuilderError("adapterClass property for ResourceBindingDecorator has not been set");
			}
			var adapterImpl:Object = new adapterClass();
			if (!(adapterImpl is ResourceBindingAdapter)) {
				throw new ObjectDefinitionBuilderError("Specified adapterClass " + getQualifiedClassName(adapterClass) 
					+ " does not implement the ResourceBindingAdapter interface");
			}
			adapter = adapterImpl as ResourceBindingAdapter;
		}
	}
	
	
	private var target:ManagedObject;

	private var key:String;
	private var bundle:String;


	/**
	 * Creates a new processor instance.
	 * 
	 * @param key the key for the resource
	 * @param bundle the bundle name 
	 */
	function ResourceBindingProcessor (bundle:String, key:String) {
		this.key = key;
		this.bundle = bundle;		
		initializeAdapter();
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
		this.target = target;
		updateTarget();
		adapter.addEventListener(ResourceBindingEvent.UPDATE, handleUpdate);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		adapter.removeEventListener(ResourceBindingEvent.UPDATE, handleUpdate);
	}

	private function handleUpdate (event:ResourceBindingEvent) : void {
		updateTarget();
	}
	
	private function updateTarget () : void {
		var resource:* = adapter.getResource(bundle, key);
		property.setValue(target.instance, resource);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function clone (): StatefulProcessor {
		return new ResourceBindingProcessor(key, bundle);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ResourceBinding(key=" + key + ",bundle=" + bundle + ")]";
	}
	
	
}

}
