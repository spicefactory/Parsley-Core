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

package org.spicefactory.parsley.dsl.core {

/**
 * Builder for a single event type.
 * 
 * @author Jens Halm
 */
public interface EventBuilder {
	
	
	/**
	 * Instructs the container to manage the event for the specified scope.
	 * When omitted (which should be preferred in most cases) the event
	 * will be managed for all available scopes. Managing an event means
	 * that the container will route it through its messaging system
	 * whenever the source object dispatches such an event.
	 * 
	 * @param scope the scope the event should be managed for 
	 */
	function manage (scope:String = null) : void;
	
	
}
}
