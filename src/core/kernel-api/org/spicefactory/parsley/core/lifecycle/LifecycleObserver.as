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

package org.spicefactory.parsley.core.lifecycle {

import org.spicefactory.parsley.core.processor.Phase;
/**
 * Represents an observer that gets notified when matching objects reach a particular phase in their lifecycle.
 * 
 * @author Jens Halm
 */
public interface LifecycleObserver {
	
	
	/**
	 * The type of the objects the observer is interested in.
	 */
	function get observedType () : Class; 
	
	/**
	 * The phase of the object lifecycle that should trigger the observer.
	 */
	function get phase () : Phase;
	
	/**
	 * The optional id of the object as registered in the Context.
	 * If omitted all matching types will be observed.
	 */
	function get objectId () : String;
	
	/**
	 * Invoked when any matching object reaches the specified phase in its lifecycle.
	 * 
	 * @param observed the observerd instance
	 */
	function observe (observed:Object) : void;
	
	
}
}
