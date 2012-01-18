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

package org.spicefactory.parsley.messaging.processor {

import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.processor.StatefulProcessor;

import flash.events.IEventDispatcher;


/**
 * Processor that registers and unregisters listeners to managed events 
 * that should be dispatched through Parsley's central message router.
 * 
 * @author Jens Halm
 */
public class ManagedEventsProcessor implements StatefulProcessor {
	
	
	private var names:Array;
	private var scope:String;

	private var dispatcher:MessageDispatcher;
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param target the target to listen to
	 * @param names the event names/types of all events dispatched by the annotated class that should be managed by Parsley
	 * @param dispatcher the function to invoke when a managed event gets dispatched
	 */
	function ManagedEventsProcessor (names:Array, scope:String = null) {
		this.names = names;
		this.scope = scope;
	}

	
	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		this.dispatcher = new MessageDispatcher(target.context.scopeManager, scope, this);
		
		for each (var name:String in names) {		
			IEventDispatcher(target.instance).addEventListener(name, dispatcher.dispatchMessage);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		dispatcher.disable();
		
		for each (var name:String in names) {		
			IEventDispatcher(target.instance).removeEventListener(name, dispatcher.dispatchMessage);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function clone () : StatefulProcessor {
		return new ManagedEventsProcessor(names, scope);
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ManagedEvents(names=" + names.join(",") + ")]";
	}	
	
	
}
}

