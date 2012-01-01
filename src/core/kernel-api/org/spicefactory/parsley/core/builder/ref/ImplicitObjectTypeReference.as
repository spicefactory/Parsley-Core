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

package org.spicefactory.parsley.core.builder.ref {

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.builder.ImplicitTypeReference;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;

/**
 * A type reference that relies on the target type getting deduced
 * from the member (property, method, constructor) it gets injected into.
 * 
 * @author Jens Halm
 */
public class ImplicitObjectTypeReference extends ObjectTypeReference implements ImplicitTypeReference {


	/**
	 * Creates a new instance.
	 * 
	 * @param required whether this instance represents a required dependency
	 * @param defaultValue the value to inject when no matching type can be found
	 */
	function ImplicitObjectTypeReference (required: Boolean = true, defaultValue: Object = null) {
		super(null, required, defaultValue);
	}


	/**
	 * @inheritDoc
	 */
	public function expectedType (type: Class): void {
		setType(type);
	}
	
	
	/**
	 * @private
	 */
	public override function resolve (target:ManagedObject) : * {
		if (!type) {
			throw new IllegalStateError("Expected type for implicit type reference has not been set");
		}
		return super.resolve(target);
	}
	
	/**
	 * @private
	 */
	public override function toString () : String {
		return "{ImplicitTypeReference(type=" + (type ? type.name : "<not set>") + ")}";
	}

	
}

}
