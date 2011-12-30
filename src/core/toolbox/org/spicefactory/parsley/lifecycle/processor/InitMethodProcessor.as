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
package org.spicefactory.parsley.lifecycle.processor {

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.processor.MethodProcessor;

/**
 * Processor responsible for invoking a target method when the 
 * object gets initialized.
 * 
 * @author Jens Halm
 */
public class InitMethodProcessor implements MethodProcessor {


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
	public function init (target: ManagedObject): void {
		method.invoke(target.instance, []);
	}

	/**
	 * @inheritDoc
	 */
	public function destroy (target: ManagedObject): void {
		/* nothing to do */
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[InitMethod(method=" + method + ")]";
	}	
	
	
}
}
