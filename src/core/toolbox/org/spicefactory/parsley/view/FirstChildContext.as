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
import org.spicefactory.parsley.core.events.ContextConfigurationEvent;
import org.spicefactory.parsley.core.events.ContextCreationEvent;
import org.spicefactory.parsley.util.ContextCallbacks;

import flash.display.DisplayObject;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * Waits for the first child Context that gets created somewhere in the view hieararchy at or below the specified
 * view instance. The various callbacks allow to either modify the configuration before the Context
 * gets built, or the receive the Context instance once it has either been just created or fully initialized.
 * 
 * @author Jens Halm
 */
public class FirstChildContext {
	
	
	private var _view: DisplayObject;
	
	private var bootstrapHandler: Function;
	private var createdHandler: Function;
	private var completeHandler: Function;
	private var errorHandler: Function;
	
	private var timer: Timer;
	private var contextCallbacks: ContextCallbacks;
	
	
	/**
	 * The view to use for waiting for the first child Context in the hierarchy below.
	 * 
	 * @param view the view to use for waiting for the first child Context in the hierarchy below
	 * @return a new ParentContext instance for specifying various callbacks
	 */
	public static function view (view: DisplayObject): FirstChildContext {
		return new FirstChildContext(view);
	}
	
	
	/**
	 * @private
	 */
	function FirstChildContext (view: DisplayObject) {
		_view = view;
	}
	
	
	/**
	 * The handler to invoke when the bootstrap of the child Context starts.
	 * This is a very early callback, the actual Context instance is not available yet.
	 * Instead the provided <code>BoostrapConfig</code> instance allows to transparently add configuration
	 * options and managed objects to the child Context without the child Context being aware of this.
	 * This is primarily useful for developing application shells where some aspects like navigation
	 * status might need to be provided to modules or tabs in a transparent way.
	 * 
	 * <p>The function must accept a parameter of type BootstrapConfig</p>.
	 * 
	 * @param handler the handler to invoke when the bootstrap of the child Context starts
	 * @return this instance for method chaining
	 */
	public function bootstrap (handler: Function): FirstChildContext {
		bootstrapHandler = handler;
		return this;
	}
	
	/**
	 * The handler to invoke when the child Context has been created.
	 * This is an early callback, invoked right after the Context instance has created,
	 * but potentially before it fired its configured or initialized events.
	 * 
	 * <p>The function must accept a parameter of type Context.</p>
	 * 
	 * @param handler the handler to invoke when the child Context has been created
	 * @return this instance for method chaining
	 */
	public function created (handler: Function): FirstChildContext {
		createdHandler = handler;
		return this;
	}
	
	/**
	 * The handler to invoke when the child Context has finished its initialization.
	 * At this point all non-lazy singletons have been created and configured and the
	 * Context had fired its initialized event.
	 * 
	 * <p>The function must accept a parameter of type Context.</p>
	 * 
	 * @param handler the handler to invoke when the child Context has finished its initialization
	 * @return this instance for method chaining
	 */
	public function complete (handler: Function): FirstChildContext {
		completeHandler = handler;
		return this;
	}
	
	/**
	 * The handler to invoke when the creation of the child Context aborts with an error.
	 * 
	 * <p>The function must accept a parameter of type Object. It will be the cause of the error,
	 * so usually an instance of <code>ErrorEvent</code> or <code>Error</code>.</p>
	 * 
	 * @param handler the handler to invoke when the creation of the child Context aborts with an error
	 * @return this instance for method chaining
	 */
	public function error (handler: Function): FirstChildContext {
		errorHandler = handler;
		return this;
	}
	
	/**
	 * Specifies the amount of time to wait until the final of the specified
	 * callbacks gets invoked. In case the operation times out, the error 
	 * handler will get invoked with a parameter of type <code>TimerEvent</code>.
	 * 
	 * @param milliseconds the number of milliseconds to wait until the final callback gets invoked
	 * @return this instance for method chaining
	 */
	public function timeout (milliseconds: uint): FirstChildContext {
		timer = new Timer(milliseconds, 1);
		return this;
	}
	
	
	/**
	 * Applies all handlers and configuration that have been specified
	 * and waits for the first child Context to be created in the view.
	 * 
	 * @return a lookup instance that allows to cancel the operation
	 */
	public function execute (): ContextLookup {
		
		if (hasBootstrapHandler) {
			_view.addEventListener(ContextConfigurationEvent.CONFIGURE_CONTEXT, handleBootstrap);
		}
		
		if (hasContextHandler) {
			_view.addEventListener(ContextCreationEvent.CREATE_CONTEXT, handleContext);
		}

		if (timer) {
			timer.addEventListener(TimerEvent.TIMER, timeoutHandler);
			timer.start();
		}
		
		return new ContextLookupImpl(cleanup);
	}
	
	private function get hasBootstrapHandler (): Boolean {
		return (bootstrapHandler != null);
	}
	
	private function get hasContextHandler (): Boolean {
		return (createdHandler != null || completeHandler != null || errorHandler != null);
	}
	
	private function handleBootstrap (event: ContextConfigurationEvent) : void {
		_view.removeEventListener(ContextConfigurationEvent.CONFIGURE_CONTEXT, handleBootstrap);
		
		bootstrapHandler(event.config);
		bootstrapHandler = null;
		
		if (!hasContextHandler) {
			cleanup();
		}
	}
	
	private function handleContext (event:ContextCreationEvent) : void {
		_view.removeEventListener(ContextCreationEvent.CREATE_CONTEXT, handleContext);
		
		if (createdHandler != null) {
			createdHandler(event.context);
			createdHandler = null;
		}
		
		if (completeHandler != null || errorHandler != null) {
			contextCallbacks = ContextCallbacks
				.forContext(event.context)
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
		if (timer) {
			timer.removeEventListener(TimerEvent.TIMER, timeoutHandler);
			timer.stop();
			timer = null;
		}
		if (hasBootstrapHandler) {
			_view.removeEventListener(ContextConfigurationEvent.CONFIGURE_CONTEXT, handleBootstrap);
		}
		if (hasContextHandler && !contextCallbacks) {
			_view.removeEventListener(ContextCreationEvent.CREATE_CONTEXT, handleContext);
		}
		if (contextCallbacks) {
			contextCallbacks.cancel();
		}
	}
	
	private function timeoutHandler (event: TimerEvent) : void {
		if (errorHandler != null) {
			errorHandler(event); 
		}
		cleanup();
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

