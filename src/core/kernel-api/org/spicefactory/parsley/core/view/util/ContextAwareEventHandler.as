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

package org.spicefactory.parsley.core.view.util {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;

import flash.events.Event;

/**
 * An event handler that caches events before invoking the target handler when the associated Parsley Context
 * is not fully initialized yet.  
 * 
 * @author Jens Halm
 */
public class ContextAwareEventHandler {
	
	
	private var context:Context;
	private var handler:Function;

	private var cachedEvents:Array = new Array();
	
	
	/**
	 * Creates a new instance. 
	 * 
	 * @param context the associated Context
	 * @param handler the handler to invoke for each event
	 */
	function ContextAwareEventHandler (context:Context, handler:Function) {
		this.context = context;
		this.handler = handler;
	}

	
	/**
	 * Handles the specified event, potentially deferring the target handler invocation in case the 
	 * associated Context is not fully initialized yet.
	 * 
	 * @param event the event to handle
	 */
	public function handleEvent (event:Event) : void {
		if (context.initialized) {
			handler(event);			
		}
		else {
			if (cachedEvents.length == 0) {
				context.addEventListener(ContextEvent.INITIALIZED, handleCachedEvents);
			}
			cachedEvents.push(event);
		}
	}
	
	private function handleCachedEvents (contextEvent:ContextEvent) : void {
		context.removeEventListener(ContextEvent.INITIALIZED, handleCachedEvents);
		for each (var event:Event in cachedEvents) {
			handler(event);
		}
		cachedEvents = new Array();
	}	
	
	/**
	 * Dispose this event handler, clearing its internal cache of events that needed deferral.
	 */
	public function dispose () : void {
		if (cachedEvents.length > 0) {
			context.removeEventListener(ContextEvent.INITIALIZED, handleCachedEvents);
			cachedEvents = new Array();
		}
	}
	
	
}
}
