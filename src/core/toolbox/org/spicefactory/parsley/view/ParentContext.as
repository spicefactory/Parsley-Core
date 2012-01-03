/*
 * Copyright 2012 the original author or authors.
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

package org.spicefactory.parsley.view {

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.events.ContextLookupEvent;
import org.spicefactory.parsley.util.ContextCallbacks;

import flash.display.DisplayObject;
import flash.events.Event;

/**
 * API for finding the nearest Context in the view hierarchy above the specified DisplayObject.
 * This is an asynchronous operation, hence a callbacks must be specified with one parameter
 * of type Context.
 * 
 * @author Jens Halm
 */
public class ParentContext {
	
	
	private var _view: DisplayObject;
	
	private var availableHandler: Function;
	private var completeHandler: Function;
	private var errorHandler: Function;
	
	private var contextCallbacks: ContextCallbacks;
	
	
	/**
	 * The view to use for looking up the nearest Context in the hierarchy above.
	 * 
	 * @param view the view to use for looking up the nearest Context in the hierarchy above
	 * @return a new ParentContext instance for specifying various callbacks
	 */
	public static function view (view: DisplayObject): ParentContext {
		return new ParentContext(view);
	}
	
	
	/**
	 * @private
	 */
	function ParentContext (view: DisplayObject) {
		_view = view;
	}
	
	/**
	 * The handler to invoke when the parent Context has been found in the view hieararchy.
	 * At this point the configured or initialized events may not have been dispatched yet.
	 * 
	 * <p>The function must accept a parameter of type Context.</p>
	 * 
	 * @param handler the handler to invoke when the parent Context has been found
	 * @return this instance for method chaining
	 */
	public function available (handler: Function): ParentContext {
		availableHandler = handler;
		return this;
	}
	
	/**
	 * The handler to invoke when the parent Context has finished its initialization.
	 * At this point all non-lazy singletons have been created and configured and the
	 * Context had fired its initialized event.
	 * 
	 * <p>The function must accept a parameter of type Context.</p>
	 * 
	 * @param handler the handler to invoke when the parent Context has finished its initialization
	 * @return this instance for method chaining
	 */
	public function complete (handler: Function): ParentContext {
		completeHandler = handler;
		return this;
	}
	
	/**
	 * The handler to invoke when the parent Context could not be found in the view hierarchy.
	 * 
	 * <p>The function must not accept any parameters.</p>
	 * 
	 * @param handler the handler to invoke when the parent Context could not be found in the view hierarchy
	 * @return this instance for method chaining
	 */
	public function error (handler: Function): ParentContext {
		errorHandler = handler;
		return this;
	}
	
	/**
	 * Applies all handlers and configuration that have been specified
	 * and waits for the first child Context to be created in the view.
	 * 
	 * @return a lookup instance that allows to cancel the operation
	 */
	public function execute (): ContextLookup {
		
		if (!_view.stage) {
			var stageListener:Function = function (stageEvent:Event) : void {
				_view.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				dispatchLookupEvent();
			};
			_view.addEventListener(Event.ADDED_TO_STAGE, stageListener);
		}
		else {
			dispatchLookupEvent();
		}

		return new ContextLookupImpl(cleanup);
	}
	
	private function dispatchLookupEvent () : void {
		var event: ContextLookupEvent = new ContextLookupEvent(handleContext);
		_view.dispatchEvent(event);
		
		if (!event.processed) {
			if (errorHandler != null) {
				errorHandler(new ContextError("Parent Context could not be found in the view hierarchy"));
			}
			cleanup();
		}
	}
	
	private function handleContext (context: Context): void {
		
		if (availableHandler != null) {
			availableHandler(context);
			availableHandler = null;
		}
		
		if (completeHandler != null) {
			contextCallbacks = ContextCallbacks
				.forContext(context)
				.initialized(contextComplete)
				.error(contextError);
		}
		else {
			cleanup();
		}
	}
	
	private function contextComplete (context: Context): void {
		if (completeHandler != null) {
			completeHandler(context);
		}
		cleanup();
	}
	
	private function contextError (cause: Object): void {
		if (errorHandler != null) {
			errorHandler(cause);
		}
		cleanup();
	}
	
	private function cleanup () : void {
		if (contextCallbacks) {
			contextCallbacks.cancel();
		}
	}
	
	
}
}

import org.spicefactory.parsley.view.ContextLookup;

class ContextLookupImpl implements ContextLookup {

	private var cancelCallback: Function;
	
	function ContextLookupImpl (cancelCallback: Function) {
		this.cancelCallback = cancelCallback;
	}
	
	public function cancel () : void {
		cancelCallback();
	}

}

