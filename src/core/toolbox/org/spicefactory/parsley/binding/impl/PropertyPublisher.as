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
 
package org.spicefactory.parsley.binding.impl {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.binding.PropertyWatcher;
import org.spicefactory.parsley.core.binding.Publisher;
import org.spicefactory.parsley.core.context.Context;

/**
 * A Publisher that observes the value of a single property and uses its value
 * as the published value.
 * 
 * @author Jens Halm
 */
public class PropertyPublisher extends AbstractPublisher implements Publisher {
	
	
	private var target:Object;
	private var property:Property;
	
	private var changeEvent:String;
	private var _currentValue:*;
	
	private var propertyWatcher: PropertyWatcher;
	
	
	private static var _propertyWatcherType: Class;
	
	/**
	 * The type of the property watcher implementation all PropertyPublishers should use.
	 * The specified class must implement the PropertyWatcher interface.
	 * The default implementation relies on the target dispatching change events.
	 * Parsley's Flex support will install an alternative that uses Flex Bindings
	 * instead when the application runs inside Flex.
	 */
	static public function get propertyWatcherType (): Class {
		return _propertyWatcherType || DefaultPropertyWatcher;
	}

	static public function set propertyWatcherType (value: Class): void {
		_propertyWatcherType = value;
	}
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param target the instance that holds the property to observe
	 * @param property the target property that holds the published value
	 * @param type the type of the published value
	 * @param id the id the value is published with
	 * @param context the corresponding Context in case the published object should be managed
	 * @param changeEvent the event type that signals that the property value has changed (has no effect in Flex applications)
	 */
	function PropertyPublisher (target:Object, property:Property, type:ClassInfo = null, id:String = null,
			context:Context = null, changeEvent:String = null) {
		super(type ? type : property.type, id, false, context);
		this.target = target;
		this.property = property;
		this.changeEvent = changeEvent;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function init () : void {
		propertyWatcher = new propertyWatcherType() as PropertyWatcher;
		if (!propertyWatcher) {
			throw new IllegalStateError("Registered property watcher type " + propertyWatcherType 
					+ " does not implement the PropertyWatcher interface");
		}
		
		propertyWatcher.watch(target, property, changeEvent, propertyChanged);
	}
	
	private function propertyChanged (value:*) : void {
		_currentValue = value;
		publish(value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispose () : void {
		propertyWatcher.unwatch();
		propertyWatcher = null;
		enabled = false;
		publish(null);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get currentValue () : * {
		return _currentValue;
	}
	
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return "[Publisher(property=" + property.name + ",type=" + type.name 
				+ ((id) ? ",id=" + id : "") + ")]";
	}

	
}
}
