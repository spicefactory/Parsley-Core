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

package org.spicefactory.parsley.inject.model {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ResolvableValue;

/**
 * Represents an Array that might contain special configuration values like object references or
 * inline object definitions alongside simple values.
 * 
 * @author Jens Halm
 */
public dynamic class ManagedArray extends Array implements ResolvableValue {

	
	public function resolve (target:ManagedObject) : * {
		var source:Array = this;
		var result:Array = new Array();
		for each (var element:* in source) {
			result.push(target.resolveValue(element));			
		}
		return result;
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "{ManagedArray(length=" + this.length + ")}";
	}	
	
	
}
}
