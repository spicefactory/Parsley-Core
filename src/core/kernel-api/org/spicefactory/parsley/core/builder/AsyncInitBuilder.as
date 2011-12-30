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

package org.spicefactory.parsley.core.builder {

/**
 * Builder for asynchronous object initialization.
 * 
 * @author Jens Halm
 */
public interface AsyncInitBuilder {
	
	
	/**
	 * The event type that signals that object initialization has successfully completed.
	 * The default is <code>Event.COMPLETE</code>.
	 * 
	 * @param type the event type that signals that object initialization has successfully completed
	 * @return this builder for method chaining
	 */
	function completeEvent (type:String) : AsyncInitBuilder;

	/**
	 * The event type that signals that object initialization has failed.
	 * The default is <code>Event.COMPLETE</code>.
	 * 
	 * @param type the event type that signals that object initialization has failed
	 * @return this builder for method chaining
	 */
	function errorEvent (type:String) : AsyncInitBuilder;
	
	
}
}
