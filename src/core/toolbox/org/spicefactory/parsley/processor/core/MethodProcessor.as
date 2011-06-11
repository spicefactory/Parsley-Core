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

package org.spicefactory.parsley.processor.core {
import org.spicefactory.parsley.processor.util.ObjectProcessorFactories;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.registry.ObjectProcessor;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;

/**
 * Processor that invokes a method in the target object, potentially 
 * resolving references to other objects in the Context for the parameter values.
 * 
 * @author Jens Halm
 */
public class MethodProcessor implements ObjectProcessor {
	
	
	private var target:ManagedObject;
	private var _method:Method;
	private var _unresolvedParams:Array;	
	
	
	/**
	 * Creates a new processor instance.
	 * 
	 * @param target the target to invoke the method on
	 * @param method the method to invoke
	 * @param unresolvedParams the unresolved method parameters
	 */
	function MethodProcessor (target:ManagedObject, method:Method, unresolvedParams:Array) {
		this.target = target;
		this._method = method;
		this._unresolvedParams = unresolvedParams;
	}

	/**
	 * The method invoked by this processor.
	 */
	public function get method () : Method {
		return _method;
	}
	
	/**
	 * The unresolved parameters for the method invocation.
	 * Unresolved means that for special objects like references to other
	 * objects in the Context, this will be an instance of <code>ResolvableValue</code>
	 * that merely represents the actual value.
	 */
	public function get unresolvedParams () : * {
		return _unresolvedParams;
	}
	/**
	 * @inheritDoc
	 */
	public function preInit () : void {
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
	public function postDestroy () : void {
		/* nothing to do */
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[MethodInvocation(method=" + method.name + ",parameters=" + unresolvedParams.join(",") + ")]";
	}	
	
	
	/**
	 * Creates a new processor factory.
	 * 
	 * @param method the method to invoke
	 * @param params the unresolved method parameters
	 * @return a new processor factory
	 */
	public static function newFactory (method:Method, params:Array) : ObjectProcessorFactory {
		return ObjectProcessorFactories.newFactory(MethodProcessor, [method, params]);
	}
	
	
}
}

