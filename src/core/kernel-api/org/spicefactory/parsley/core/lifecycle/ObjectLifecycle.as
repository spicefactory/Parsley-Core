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

package org.spicefactory.parsley.core.lifecycle {

/**
 * Enumeration for all phases of an object lifecycle.
 * 
 * @author Jens Halm
 */
public class ObjectLifecycle {
	
	
	/**
	 * Lifecycle phase after all injections and other configuration tasks have been performed
	 * for an object, but immediately before the init method of that object (if existent) is invoked.
	 */
	public static const PRE_INIT:ObjectLifecycle = new ObjectLifecycle("preInit");

	/**
	 * Lifecycle phase after the init method of an object has been invoked.
	 */
	public static const POST_INIT:ObjectLifecycle = new ObjectLifecycle("postInit");

	/**
	 * Lifecycle phase when an object is about to be removed from the Context, but before
	 * the destroy method of that object (if existent) is invoked.
	 */
	public static const PRE_DESTROY:ObjectLifecycle = new ObjectLifecycle("preDestroy");

	/**
	 * Lifecycle phase after the destroy method of an object (if existent) has been invoked.
	 * This is the final phase before an object actually gets removed from a Context.
	 */
	public static const POST_DESTROY:ObjectLifecycle = new ObjectLifecycle("postDestroy");
	
	
	private var _key:String;
	
	/**
	 * @private
	 */
	function ObjectLifecycle (key:String) {
		_key = key;
	}
	
	/**
	 * The unique key representing this lifecycle phase.
	 */
	public function get key () : String {
		return _key;
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return _key;
	}
	
	
}
}
