/*
 * Copyright 2011 the original author or authors.
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

/**
 * A status object that can be passed along to avoid duplicate paths in recursive lookups.
 * Primarily used for all APIs that need to consult all their parents to determine the return value.
 * As Parsley supports multiple Context inheritance since version 2.4, some APIs must take care
 * of not visiting the same parent twice when doing a lookup. 
 * 
 * @author Jens Halm
 */
public interface LookupStatus {
	
	/**
	 * Adds the specified instance to this lookup object.
	 * When the method returns true, the addition succeeded.
	 * Returning false means that the same instance was already added to this object.
	 * 
	 * @param instance the instance to add to this lookup object
	 * @return true, it the addition succeeded, false, if the same instance was already added to this object 
	 */
	function addInstance (instance:Object) : Boolean;
	
}
}
