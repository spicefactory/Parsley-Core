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

package org.spicefactory.parsley.core.registry {
import flash.events.ErrorEvent;
import flash.events.Event;

/**
 * The configuration for an asynchronously initializing object.
 * 
 * @author Jens Halm
 */
public class AsyncInitConfig {
	
	
	/**
	 * The event type that signals that object initialization has successfully completed.
	 */
	public var completeEvent:String = Event.COMPLETE;

	/**
	 * The event type that signals that object initialization has failed.
	 */
	public var errorEvent:String = ErrorEvent.ERROR;

	
	
}
}
