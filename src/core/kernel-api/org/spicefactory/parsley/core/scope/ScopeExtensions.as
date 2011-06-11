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

package org.spicefactory.parsley.core.scope {

/**
 * Registry for custom extensions added to a scope.
 * This is primarily useful for custom configuration tags that may want to interact with a
 * manager-type instance. Often this manager wants to operate scope-wide like some of the
 * builtin services (e.g. MessageRouter).
 * 
 * <p>Extensions can be registered globally or for a single Context only with
 * <code>FactoryRegistry.scopeExtensions</code>.</p>
 * 
 * @author Jens Halm
 */
public interface ScopeExtensions {
	
	/**
	 * Obtains the extension of the specified type.
	 * When using this method the scope must contain exactly one instance of a matching type, 
	 * otherwise an Error will be thrown.
	 * 
	 * @param type the type of extenstion to obtain
	 * @return the extension with a matching type
	 */
	function forType (type:Class) : Object;
	
	/**
	 * Indicates whether this object contains an extension of the specified type.
	 * 
	 * @param type the type of extension to check
	 * @return true if this object contains an extension of the specified type
	 */
	function hasType (type:Class) : Boolean;

	
}
}
