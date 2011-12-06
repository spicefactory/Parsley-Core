/*
 * Copyright 2011 the original author or authors.
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
package org.spicefactory.parsley.binding.impl {

import flash.events.Event;
import flash.events.IEventDispatcher;
import org.spicefactory.parsley.binding.PropertyWatcher;
import org.spicefactory.lib.reflect.Property;

/**
 * Default implementation of the PropertyWatcher interface.
 * This class relies on Flash Events that the target instance needs to dispatch
 * to signal that the property value has changed.
 * 
 * @author Jens Halm
 */
public class DefaultPropertyWatcher implements PropertyWatcher {


	private var target: IEventDispatcher;
	private var property: Property;
	private var changeEvent: String;
	private var callback: Function;


	/**
	 * @inheritDoc
	 */
	public function watch (target: Object, property: Property, changeEvent: String, callback: Function): void {
		this.target = IEventDispatcher(target);
		this.property = property;
		this.changeEvent = changeEvent;
		this.callback = callback;
		
		target.addEventListener(changeEvent, propertyChanged);
	}
	
	private function propertyChanged (event: Event): void {
		callback(property.getValue(target));
	}

	/**
	 * @inheritDoc
	 */
	public function unwatch (): void {
		target.removeEventListener(changeEvent, propertyChanged);
	}
	
	
}
}
