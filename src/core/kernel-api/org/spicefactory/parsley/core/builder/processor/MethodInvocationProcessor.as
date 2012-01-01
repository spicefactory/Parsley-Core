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

package org.spicefactory.parsley.core.builder.processor {

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.MethodProcessor;

/**
 * Processor that invokes a method in the target object, potentially 
 * resolving references to other objects in the Context for the parameter values.
 * 
 * @author Jens Halm
 */
public class MethodInvocationProcessor implements MethodProcessor {
	
	
	private var unresolvedParams:Array;	
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param unresolvedParams the unresolved method parameters
	 */
	function MethodInvocationProcessor (unresolvedParams:Array) {
		this.unresolvedParams = unresolvedParams;
	}
	
	
	private var method: Method;
	
	/**
	 * @inheritDoc
	 */
	public function targetMethod (method: Method): void {
		this.method = method;
	}


	/**
	 * @inheritDoc
	 */
	public function init (target: ManagedObject) : void {
		var params:Array = new Array();
		for each (var param:* in unresolvedParams) {
			var value:* = target.resolveValue(param);
			params.push(value);
		}
		method.invoke(target.instance, params);
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
		return "[MethodInvocation(method=" + method + ",parameters=" + unresolvedParams.join(",") + ")]";
	}	
	
	
}
}

