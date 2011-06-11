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

package org.spicefactory.parsley.core.view {
import flash.display.DisplayObject;

/**
 * A ViewManager is responsible for dynamically wiring views to a Context and other view related tasks.
 * One or more view roots (any kind of DisplayObject) can be associated with a ViewManager.
 * The manager then listens for bubbling events dispatched by children of any of the view
 * roots to signal that they want to be added to a Context.
 * 
 * <p>In a simple application there is often just one view root associated with each Context.
 * But in some use cases, in particular when using Flex Popups or Native AIR Windows, additional
 * view roots must be connected to a Context, since these popups and windows build a disconnected
 * view hierarchy.</p>
 * 
 * @author Jens Halm
 */
public interface ViewManager {
	
	
	/**
	 * Adds a view root to this manager.
	 * The manager is then responsible to listen to bubbling events
	 * from view components that wish to be wired to the Context or
	 * from a ContextBuilder that wishes to know the parent Context
	 * and the ApplicationDomain.
	 * 
	 * @param view the view root to add to the manager
	 */
	function addViewRoot (view:DisplayObject) : void;

	/**
	 * Removes a view root from this manager.
	 * The manager should immediately stop to listen to bubbling events
	 * from children of the specified view root.
	 * 
	 * @param view the view root to remove from the manager
	 */
	function removeViewRoot (view:DisplayObject) : void;
	
	
}
}
