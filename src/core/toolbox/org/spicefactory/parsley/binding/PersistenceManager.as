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
 
package org.spicefactory.parsley.binding {
import flash.events.IEventDispatcher;

/**
 * Dispatched when the persistent values changed.
 * 
 * @eventType flash.events.Event.CHANGE
 */
[Event(name="change", type="flash.events.Event")]

/**
 * Pluggable strategy that allows to persist published values. An implementation of this interface will be
 * invoked when a publisher with the persistent attribute set to true changes its value.
 * The framework comes with a default implementation based on Local SharedObjects, but it can easily
 * be replaced by mechanisms which are application-specific, like services that persist to the server.
 * 
 * @author Jens Halm
 */
public interface PersistenceManager extends IEventDispatcher {
	
	/**
	 * Saves the specified value.
	 * 
	 * @param key the key of the value to save
	 * @param value the value to save
	 */
	function saveValue (key:Object, value:Object) : void;
	
	/**
	 * Deletes the value mapping to the specified key.
	 * 
	 * @param key the key of the value to delete
	 */
	function deleteValue (key:Object) : void;
	
	/**
	 * Returns the value mapping to the specified type and id.
	 * 
	 * @param key the key of the value to retrieve
	 * @return the value mapping to the specified key
	 */
	function getValue (key:Object) : Object;
	
}
}
