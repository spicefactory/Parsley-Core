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

package org.spicefactory.parsley.processor.messaging {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;

import flash.events.IEventDispatcher;

/**
 * Processor that registers and unregisters listeners to managed events 
 * that should be dispatched through Parsley's central message router.
 * 
 * @author Jens Halm
 */
public class ManagedEventsProcessor implements ObjectProcessor {
	
	
	private var target:IEventDispatcher;
	private var names:Array;
	private var dispatcher:Function;
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param target the target to listen to
	 * @param names the event names/types of all events dispatched by the annotated class that should be managed by Parsley
	 * @param dispatcher the function to invoke when a managed event gets dispatched
	 */
	function ManagedEventsProcessor (target:ManagedObject, names:Array, dispatcher:Function) {
		this.target = IEventDispatcher(target.instance);
		this.names = names;
		this.dispatcher = dispatcher;
	}

	
	/**
	 * @inheritDoc
	 */
	public function preInit () : void {
		for each (var name:String in names) {		
			target.addEventListener(name, dispatcher);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function postDestroy () : void {
		for each (var name:String in names) {		
			target.removeEventListener(name, dispatcher);
		}
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ManagedEvents(names=" + names.join(",") + ")]";
	}	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param names the event names/types of all events dispatched by the annotated class that should be managed by Parsley
	 * @param dispatcher the function to invoke when a managed event gets dispatched
	 * @return a new processor factory
	 */
	public static function newFactory (names:Array, dispatcher:Function) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(ManagedEventsProcessor, [names, dispatcher]);
	}
	
	
}
}

