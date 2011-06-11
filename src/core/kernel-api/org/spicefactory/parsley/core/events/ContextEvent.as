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
 
package org.spicefactory.parsley.core.events {
import flash.events.Event;

/**
 * Event that fires when a Context changes its internal state.
 * 
 * @author Jens Halm
 */
public class ContextEvent extends Event {


	/**
	 * Constant for the type of event fired when a Context instance was configured.
	 * After this event has fired all configuration has been processed and all
	 * <code>ObjectDefinition</code> instances have been frozen and cannot be
	 * modified anymore. <code>Context.getObject</code> and other methods of
	 * the Context can now be called. But application code should be careful
	 * to fetch objects from the container before the <code>INITIALIZED</code>
	 * event because it could alter the sequence of asynchronously initializing
	 * objects. Nevertheless it is legal to fetch objects at this point because
	 * the asynchronously initializing objects might have dependencies themselves.
	 * 
	 * @eventType configured
	 */
	public static const CONFIGURED : String = "configured";
	
	/**
	 * Constant for the type of event fired when a Context instance was initialized.
	 * A Context is fully initialized if
	 * all asynchronous initializers for non-lazy singletons (if any) have completed and
	 * the parent Context (if set) is fully initialized too.
	 * 
	 * @eventType initialized
	 */
	public static const INITIALIZED : String = "initialized";
		
	/**
	 * Constant for the type of event fired when a Context instance was destroyed.
	 * 
	 * @eventType destroyed
	 */
	public static const DESTROYED : String = "destroyed";
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param type the type of this event
	 */
	public function ContextEvent (type:String) {
		super(type);
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new ContextEvent(type);
	}			
		
}
	
}