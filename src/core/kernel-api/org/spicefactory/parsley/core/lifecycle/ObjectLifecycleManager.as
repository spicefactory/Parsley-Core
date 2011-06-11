/*
 * Copyright 2008-2009 the original author or authors.
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
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Responsible for managing the lifecycle of objects, creating and destroying their handlers.
 * It is used as a strategy in the builtin <code>Context</code> implementations.
 * 
 * @author Jens Halm
 */
public interface ObjectLifecycleManager {
	
	/**
	 * Creates a new handler for the specified ObjectDefinition. The handler instance can then 
	 * be used to control the lifecycle of a single target object.
	 * 
	 * @param definition the definition to create a new handler for
	 * @param context the Context the object belongs to
	 * @return a new handler for the specified ObjectDefinition
	 */
	function createHandler (definition:ObjectDefinition, context:Context) : ManagedObjectHandler;	

	/**
	 * Destroys all managed objects created by this instance. This means that
	 * implementations have to keep track of all handlers they create.
	 */
	function destroyAll () : void;
	
}

}
