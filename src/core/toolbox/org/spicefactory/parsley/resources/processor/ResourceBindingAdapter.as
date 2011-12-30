/*
 * Copyright 2009 the original author or authors.
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
import flash.events.IEventDispatcher;

/**
 * Dispatched when the adapted ResourceManager changed the active locale or locale chain respectively.
 * 
 * @eventType org.spicefactory.parsley.resources.ResouceBindingEvent.UPDATE
 */
[Event(name="update", type="org.spicefactory.parsley.resources.processor.ResourceBindingEvent")]

/**
 * Adapts Parsleys ResourceBinding either to the Flex ResourceManager or the Parsley Flash ResourceManager.
 * 
 * @author Jens Halm
 */
public interface ResourceBindingAdapter extends IEventDispatcher {

	
	/**	
	 * Returns the resource for the specified bundle and key.
	 * 
	 * @param bundle the bundle name
	 * @param key the resource key
	 * @return the resource for the specified bundle and key
	 */
	function getResource (bundle:String, key:String) : *;
	
	
}
}
