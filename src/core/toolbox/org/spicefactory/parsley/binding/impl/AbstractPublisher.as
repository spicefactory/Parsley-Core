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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicObject;

import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Abstract base class for all Publisher implementations.
 * 
 * @author Jens Halm
 */
public class AbstractPublisher extends EventDispatcher {
	
	
	private var _type:ClassInfo;
	private var _id:String;
	private var _unique:Boolean;

	private var currentObject:DynamicObject;
	private var context:Context;
	
	/**
	 * Indicates whether this publisher is currently enabled.
	 * When disabled changes to the current value should not cause
	 * a change event to be fired.
	 */
	protected var enabled:Boolean = true;
		
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the target property that holds the published value
	 * @param type the type of the published value
	 * @param id the id the value is published with
	 * @param context the corresponding Context in case the published object should be managed
	 */
	function AbstractPublisher (type:ClassInfo, id:String = null, 
			unique:Boolean = false, context:Context = null) {
		this.context = context;
		_type = type;
		_id = id;	
		_unique = unique;	
		this.context = context;
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher.type
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher.id
	 */
	public function get id () : String {
		return _id;
	}
	
	/**
	 * @copy org.spicefactory.parsley.binding.Publisher#unique
	 */
	public function get unique () : Boolean {
		return _unique;
	}
	
	/**
	 * Publishes a new value.
	 * 
	 * @param newValue the new value to publish
	 */
	protected function publish (newValue:*) : void {
		if (context) {
			if (currentObject) {
				 currentObject.remove();
				 currentObject = null;
			}
			if (newValue) {
				currentObject = context.addDynamicObject(newValue);
			}
		}
		if (enabled) dispatchEvent(new Event(Event.CHANGE));
	}
	
	
}
}
