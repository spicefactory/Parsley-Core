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

package org.spicefactory.parsley.core.context {
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

/**
 * Represents a single dynamic object that belongs to a DynamicContext instance.
 * Such an object can be dynamically removed from the Context anytime before
 * the Context gets destroyed.
 * 
 * @author Jens Halm
 */
public interface DynamicObject {


	/**
	 * The definition the object was created from or the definition that
	 * was applied to an existing instance.
	 */
	function get definition () : DynamicObjectDefinition;
	
	/**
	 * The actual managed instance.
	 */
	function get instance () : Object;
	
	/**
	 * The Context that managed this object.
	 */
	function get context () : Context;
		
	/**
	 * Removes this object from the Context.
	 * This will lead to the regular lifecycle events for objects that
	 * are destroyed like calling the method marked with <code>[Destroy]</code>
	 * on the removed instance. After removal the instance does no longer take
	 * part in the messaging system of the Context.
	 */
	function remove () : void;
	
	
}
}
