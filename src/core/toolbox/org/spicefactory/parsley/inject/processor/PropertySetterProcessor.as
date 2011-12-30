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

package org.spicefactory.parsley.inject.processor {

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.PropertyProcessor;

/**
 * Processor that sets the value of a single property in the target object, potentially 
 * resolving references to other objects in the Context.
 * 
 * @author Jens Halm
 */
public class PropertySetterProcessor implements PropertyProcessor {
	
	
	private var unresolvedValue:*;	
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param unresolvedValue the unresolved property value
	 */
	function PropertySetterProcessor (unresolvedValue:*) {
		this.unresolvedValue = unresolvedValue;
	}


	private var property: Property;
	
	/**
	 * @inheritDoc
	 */
	public function targetProperty (property: Property): void {
		this.property = property;
	}

	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		var value:* = target.resolveValue(unresolvedValue);
		if (value != null || unresolvedValue == null) {
			// do not override default value when optional dependencies are missing
			property.setValue(target.instance, value);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject) : void {
		/* nothing to do */
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Property(name=" + property + ",value=" + unresolvedValue + ")]";
	}	
	
	
}
}

