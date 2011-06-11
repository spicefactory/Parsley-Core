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

package org.spicefactory.parsley.core.state.manager {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.state.GlobalObjectState;

/**
 * Keeps track of all managed objects of all the currently active Context instances.
 * Provides only status information without actuall managing the objects itself (which is the responsibility
 * of the kernel services of each individual Context).
 * 
 * <p>This manager is usually only exposed to the IOC kernel services and can be accessed through a <code>BootstrapInfo</code>
 * instance.</p>
 * 
 * @author Jens Halm
 */
public interface GlobalObjectManager {
	
	
	/**
	 * Adds the specified object to this manager
	 * 
	 * @param mo the managed object to add
	 */
	function addManagedObject (mo:ManagedObject) : void;
	
	/**
	 * Removes the specified object from this manager
	 * 
	 * @param mo the managed object to remove
	 */
	function removeManagedObject (mo:ManagedObject) : void;
	
	/**
	 * Returns the ManagedObject instance that holds the specified object or null if the
	 * object is not managed by any Context currently.
	 * 
	 * @param instance the object to return the corresponding ManagedObject instance for
	 * @return the ManagedObject instance that holds the specified object
	 */
	function getManagedObject (instance:Object) : ManagedObject;
	
	/**
	 * The state information for all mamnaged objects in a read-only format to be exposed to applications.
	 */
	function get publicState () : GlobalObjectState;
	
	 
}
}
