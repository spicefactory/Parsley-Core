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
package org.spicefactory.parsley.core.processor {

import org.spicefactory.lib.reflect.Method;

/**
 * Object processor responsible for processing a single method of the target instance.
 * An example is a processor for registering a message handler. 
 * 
 * @author Jens Halm
 */
public interface MethodProcessor extends ObjectProcessor {
	
	
	/**
	 * Sets the target method for this processor.
	 * 
	 * @param property the target method for this processor
	 */
	function targetMethod (method: Method): void;
	
	
}
}
