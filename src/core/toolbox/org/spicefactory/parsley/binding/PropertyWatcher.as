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
package org.spicefactory.parsley.binding {

import org.spicefactory.lib.reflect.Property;
/**
 * Responsible for watching changes of a single property of one target instance.
 *
 * <p>This interface helps abstracting away the fact that while it is convenient
 * to use the Flex Binding architecture for this purpose in Flex applications,
 * these are not available in Flash applications.</p>
 * 
 * @author Jens Halm
 */
public interface PropertyWatcher {
	
	
	/**
	 * Watches the property of the specified target object for change events
	 * and invokes the specified callback on each change, passing the new value.
	 * 
	 * @param target the instance that holds the property to observe
	 * @param property the target property that holds the published value
	 * @param changeEvent the event type that signals that the property value has changed (has no effect in Flex applications)
	 * @param callback the callback to invoke on each property change
	 */
	function watch (target: Object, property: Property, changeEvent: String, callback: Function): void;
	
	/**
	 * Stops watching the property.
	 */
	function unwatch (): void;
	
	
}
}
