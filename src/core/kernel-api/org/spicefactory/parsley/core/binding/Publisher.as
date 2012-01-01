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
 
package org.spicefactory.parsley.core.binding {
import flash.events.IEventDispatcher;
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * Dispatched when the published value changes.
 * 
 * @eventType flash.events.Event.CHANGE
 */
[Event(name="change", type="flash.events.Event")]

/**
 * Publishes a single value to matching subscribers.
 * The published value may change anytime, in which case a change event
 * must be dispatched by the publisher.
 * 
 * @author Jens Halm
 */
public interface Publisher extends IEventDispatcher {
	
	
	/**
	 * Initializes this publisher. The publisher is only supposed
	 * to dispatch change events and provide a published value
	 * after this method has been called until the dispose method is called.
	 */
	function init () : void;
	
	/**
	 * Disposes this publisher. After this method was invoked
	 * the publisher does not need to continue to provide a
	 * published value or dispatch change events.
	 */
	function dispose () : void;
	
	/**
	 * The type of the published value.
	 * May be an interface or supertype of the actual published value.
	 */
	function get type () : ClassInfo;
	
	/**
	 * The optional id of the published value.
	 * If omitted the subscribers and publishers will solely be matched by type.
	 */
	function get id () : String;
	
	/**
	 * The current value of this publisher. If this value changes the publisher
	 * must dispatch a change event.
	 */
	function get currentValue () : *;
	
	/**
	 * Indicates whether there should only be one publisher with
	 * the same type and id values for one particular implementation of this interface.
	 */
	function get unique () : Boolean; 
	
	
}
}
