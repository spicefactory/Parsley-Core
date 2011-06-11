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

package org.spicefactory.parsley.core.context.impl {
import org.spicefactory.parsley.core.context.LookupStatus;

import flash.utils.Dictionary;

/**
 * Default implementation of the LookupStatus interface.
 * 
 * @author Jens Halm
 */
public class DefaultLookupStatus implements LookupStatus {
	
	private var instances:Dictionary = new Dictionary();
	
	/**
	 * Creates a new instance, adding the specified object.
	 * 
	 * @param instance the first instance this lookup object should remember
	 */
	function DefaultLookupStatus (instance:Object = null) {
		instances[instance] = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addInstance (instance:Object) : Boolean {
		if (instances[instance] != undefined) {
			return false;
		}
		instances[instance] = true;
		return true;
	}
	
}
}
