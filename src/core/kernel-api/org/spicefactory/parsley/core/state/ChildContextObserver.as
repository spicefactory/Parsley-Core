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

package org.spicefactory.parsley.core.state {
import flash.display.DisplayObject;

/**
 * Represents a single observer that waits for the configuration or initialization
 * of the first child Context in a view.
 * 
 * @author Jens Halm
 */
public interface ChildContextObserver {
	
	/**
	 * The view where this observer waits for the first child Context.
	 * The child Context may get created anywhere in the view hierarchy below, not necessarily immediately in 
	 * this specified view. 
	 */
	function get view () : DisplayObject;
	
	/**
	 * Cancels the observers, discarding any callbacks added previously.
	 */
	function cancel () : void;
	
	/**
	 * Sets a timeout and an optional callback for this observer.
	 * The callback function must accept a single parameter of type DisplayObject (or a concrete subclass
	 * that was used when creating this observer).
	 * 
	 * @param timeout the timeout in milliseconds after which observing the first child Context in the view should
	 * be aborted
	 * @param callback the callback to invoke once a timeout occurs
	 */
	function timeout (timeout:uint, callback:Function = null) : void;
	
	
}
}
