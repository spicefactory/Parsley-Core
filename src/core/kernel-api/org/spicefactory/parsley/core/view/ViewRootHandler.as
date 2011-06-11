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

package org.spicefactory.parsley.core.view {
import org.spicefactory.parsley.core.context.Context;


import flash.display.DisplayObject;

/**
 * A ViewRootHandler is responsible for dealing with one particular aspect of a ViewManager.
 * There are four default ViewRootHandler implementations automatically added to each ViewManager
 * that deal with several builtin features like view autowiring. But applications can easily
 * add their own functionality through <code>ViewSettings.addViewRootHandler</code> or the
 * viewRootHandler attribute of the <code>&lt;ViewSettings&gt;</code> tag.
 * 
 * @author Jens Halm
 */
public interface ViewRootHandler {

	/**
	 * Initializes the handler and passes some collaborators.
	 * Invoked once in the lifecycle of each handler instance.
	 * 
	 * @param context the Context this handler belongs to
	 * @param settings the settings to use
	 */
	function init (context:Context, settings:ViewSettings) : void;
	
	/**
	 * Invoked when the associated Context gets destroyed.
	 */
	function destroy () : void;
	
	/**
	 * Adds a view root to this handler.
	 * A handler often has to listen to bubbling events
	 * from view components that wish to be wired to the Context or
	 * from a ContextBuilder that wishes to know the parent Context
	 * and the ApplicationDomain.
	 * 
	 * @param view the view root to add to the handler
	 */
	function addViewRoot (view:DisplayObject) : void;

	/**
	 * Removes a view root from this handler.
	 * The handler should immediately stop to listen to bubbling events
	 * from children of the specified view root.
	 * 
	 * @param view the view root to remove from the handler
	 */
	function removeViewRoot (view:DisplayObject) : void;
	
	
}
}
