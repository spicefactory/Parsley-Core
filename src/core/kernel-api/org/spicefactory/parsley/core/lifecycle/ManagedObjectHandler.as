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

/**
 * The handler for a single managed obejct. Allows to control the lifecycle of the managed object,
 * creating, configuring and destroying the target object.
 * 
 * @author Jens Halm
 */
public interface ManagedObjectHandler {


	/**
	 * The target object controlled by this handler.
	 */
	function get target () : ManagedObject;
	
	/**
	 * The processors that configure the target object.
	 * The Array does not get populated until the <code>configureObject</code> method is called.
	 */
	function get processors () : Array;

	/**
	 * Instantiates a new instance based on its ObjectDefinition.
	 * This should not include processing its configuration, like performing dependency injection or message handler registration.
	 * To allow bidirectional associations this step is deferred until <code>configureObject</code> is invoked.
	 * 
	 * @return the new instance
	 */
	function createObject () : void;	

	/**
	 * Processes the configuration for the specified object and performs dependency injection, message handler registration
	 * or invocation of methods marked with <code>[Init]</code> and similar tasks.
	 * 
	 * @param object the object to configure
	 */
	function configureObject () : void;	

	/**
	 * Processes lifecycle listeners for the object before it will be removed from the Context.
	 * This includes invoking methods marked with <code>[Destroy]</code>.
	 * 
	 * @param object the object to process
	 */
	function destroyObject () : void;	
	
	
	
}
}
