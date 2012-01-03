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
 
package org.spicefactory.parsley.util {

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;

import flash.events.ErrorEvent;
	
/**
 * Utility class providing callbacks for various Context initialization states
 * without the need to check whether the Context already initialized synchronously.
 * 
 * @author Jens Halm
 */
public class ContextCallbacks {
	
	
	public static function forContext (context: Context): ContextCallbacks {
		return new ContextCallbacks(context);
	}
	
	private var context: Context;
	
	private var configuredHandler: Function;
	private var initializedHandler: Function;
	private var errorHandler: Function;
	
	/**
	 * @private
	 */
	function ContextCallbacks (context: Context) {
		this.context = context;
		if (!context.initialized && !context.destroyed) {
			context.addEventListener(ContextEvent.INITIALIZED, contextInitialized);
			context.addEventListener(ErrorEvent.ERROR, contextError);
		}
	}
	
	/**
	 * The handler to invoke when the Context fires its configured event
	 * or immediately in case the Context is already configured.
	 * 
	 * @param handler the handler to invoke when the Context is configured
	 * @return this instance for method chaining
	 */
	public function configured (handler: Function): ContextCallbacks {
		if (context.configured) {
			handler(context);
		}
		else {
			configuredHandler = handler;
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
		}
		return this;
	}
	
	/**
	 * The handler to invoke when the Context fires its initialized event
	 * or immediately in case the Context is already initialized.
	 * 
	 * @param handler the handler to invoke when the Context is initialized
	 * @return this instance for method chaining
	 */
	public function initialized (handler: Function): ContextCallbacks {
		if (context.initialized) {
			handler(context);
		}
		else {
			initializedHandler = handler;
		}
		return this;
	}
	
	/**
	 * The handler to invoke when the Context creation aborts with an error.
	 * 
	 * @param handler the handler to invoke when the Context creation aborts with an error
	 * @return this instance for method chaining
	 */
	public function error (handler: Function): ContextCallbacks {
		if (!context.initialized) {
			errorHandler = handler;
		}
		return this;
	}
	
	private function contextConfigured (event: ContextEvent): void {
		configuredHandler(event.target);
	}
	
	private function contextInitialized (event: ContextEvent): void {
		if (initializedHandler != null) initializedHandler(event.target);
		cancel();	
	}
	
	private function contextError (event: ErrorEvent): void {
		if (errorHandler != null) errorHandler(event);
		cancel();	
	}
	
	/**
	 * Discards all callbacks registered with this instance.
	 */
	public function cancel (): void {
		context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		context.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		context.removeEventListener(ErrorEvent.ERROR, contextError);
	}
	
	
}
}
