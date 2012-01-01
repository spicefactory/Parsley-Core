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

package org.spicefactory.parsley.core.builder.support {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectInstantiator;

/**
 * Default ObjectInstantiator implementation that provides a new instance by invoking its constructor, potentially 
 * resolving references to other objects in the Context for the constructor arguments.
 * 
 * @author Jens Halm
 */
public class ConstructorInstantiator implements ObjectInstantiator {
	
	
	private var unresolvedParams:Array;	
	
	
	/**
	 * Creates a new instantiator instance.
	 * 
	 * @param unresolvedParams the unresolved constructor parameters
	 */
	function ConstructorInstantiator (unresolvedParams:Array) {
		this.unresolvedParams = unresolvedParams;
	}

	
	/**
	 * @inheritDoc
	 */
	public function instantiate (target:ManagedObject) : Object {
		var params:Array = new Array();
		for each (var param:* in unresolvedParams) {
			var value:* = target.resolveValue(param);
			params.push(value);
		}
		return target.definition.type.getConstructor().newInstance(params);
	}
	
	
}
}

