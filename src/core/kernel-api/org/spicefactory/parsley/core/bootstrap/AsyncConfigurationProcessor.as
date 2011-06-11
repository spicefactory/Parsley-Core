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

package org.spicefactory.parsley.core.bootstrap {
import flash.events.IEventDispatcher;

/**
 * Dispatched when the processor successfully finished.
 * 
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Dispatched when processing the configuration failed. 
 * 
 * @eventType flash.events.ErrorEvent.ERROR
 */
[Event(name="error", type="flash.events.ErrorEvent")]

/**
 * Interface to be implemented by ConfigurationProcessors that operate asynchronously.
 * 
 * @author Jens Halm
 */
public interface AsyncConfigurationProcessor extends ConfigurationProcessor, IEventDispatcher {
	
	/**	
	 * Invoked when the configuration process gets cancelled, usually due to an associated Context
	 * having been destroyed.
	 */
	function cancel () : void;
	
}
}
