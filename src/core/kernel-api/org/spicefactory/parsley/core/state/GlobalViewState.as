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
 * Global status information about the view hierarchy.
 * Offers utility function to either find the nearest Context in the view hierarchy above a view instance
 * or allows to configure or wait for a Context to be created in the view hierarchy below a particular view instance.
 * 
 * @author Jens Halm
 */
public interface GlobalViewState {
	
	
	/**
	 * Finds the nearest Context in the view hierarchy above the specified DisplayObject.
	 * This is an asynchronous operation, hence a callback must be specified with one parameter
	 * of type Context. It may be invoked with a null value in case no Context is found in the view
	 * hierarchy. The third parameter allows to specify an Event (any of the constants of <code>ContextEvent</code>).
	 * If specified the callback will not be invoked before that event has fired. If omitted the callback will
	 * be invoked as soon as the Context is found.
	 * 
	 * @param view the view to use as a starting point for the Context lookup
	 * @param callback the callback to invoke as soon as the Context is found and in the required state
	 * @param requiredEvent the event that needs to have been fired before the callback gets invoked
	 */
	function findContextInHierarchy (view:DisplayObject, callback:Function, requiredEvent:String = null) : void;
	
	/**
	 * Waits for the first child Context that gets created somewhere in the view hieararchy at or below the specified
	 * view instance. When the first Context gets created it will invoke the specified callback, passing an instance
	 * of type <code>BootstrapConfig</code> to the function. This allows to modify the configuration before the Context
	 * gets built, like adding a custom scope, specifying setting or adding objects to the Context. At the time the
	 * callback gets invoked the actual Context does not exist yet. To get access to the Context the 
	 * <code>waitForFirstChildContext</code> may be used instead. The returned observer instance allows
	 * to specify a timeout or cancel the observer.
	 * 
	 * @param view the view where to wait for the first child Context
	 * @param callback the callback to invoke, passing an instance of BootstrapConfig
	 * @return an observer instance that allows to set a timeout or cancel the operation
	 */
	function configureFirstChildContext (view:DisplayObject, callback:Function) : ChildContextObserver;
	
	/**
	 * Waits for the first child Context that gets created somewhere in the view hieararchy at or below the specified
	 * view instance. When the first Context gets created it will invoke the specified callback, passing the Context instance 
	 * to the function.  The third parameter allows to specify an Event (any of the constants of <code>ContextEvent</code>).
	 * If specified the callback will not be invoked before that event has fired. If omitted the callback will
	 * be invoked as soon as the Context is found, most likely passing a Context instance that is not fully initialized yet.
	 * 
	 * @param view the view where to wait for the first child Context
	 * @param callback the callback to invoke, passing the Context instance that was created
	 * @param requiredEvent the event that needs to have been fired before the callback gets invoked
	 * @return an observer instance that allows to set a timeout or cancel the operation
	 */
	function waitForFirstChildContext (view:DisplayObject, callback:Function, requiredEvent:String = null) : ChildContextObserver;
	
	
}
}
