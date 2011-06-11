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
 
package org.spicefactory.parsley.binding {

/**
 * The central manager of the decoupled binding facility.
 * Each scope will get its own instance.
 * 
 * <p>The publishers and subscribers added to this manager may
 * optionally implement both the Publisher and Subscriber interface.
 * You only have to invoke <code>addSubscriber</code> or <code>addPublisher</code>
 * once in this case, the other interface will automatically be detected.</p>
 * 
 * @author Jens Halm
 */
public interface BindingManager {
	
	
	/**
	 * Adds a publisher to this manager.
	 * 
	 * @param publisher the publisher to add 
	 */
	function addPublisher (publisher:Publisher) : void;
	
	/**
	 * Adds a subscriber to this manager.
	 * 
	 * @param subscriber the subscriber to add 
	 */
	function addSubscriber (subscriber:Subscriber) : void;
	
	/**
	 * Removes a publisher from this manager.
	 * 
	 * @param publisher the publisher to remove 
	 */
	function removePublisher (publisher:Publisher) : void;
	
	/**
	 * Removes a subscriber from this manager.
	 * 
	 * @param subscriber the subscriber to remove 
	 */
	function removeSubscriber (subscriber:Subscriber) : void;
	
	
}
}
