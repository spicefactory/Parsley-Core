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

package org.spicefactory.parsley.core.registry {
import org.spicefactory.parsley.core.lifecycle.ManagedObject;

/**
 * Responsible for creating object processors for target objects.
 * 
 * @author Jens Halm
 */
public interface ObjectProcessorFactory {
	
	
	/**
	 * Creates a new object processor for the specified target instance.
	 * 
	 * @param target the target object to pass to the processor
	 * @return a new object processor for the specified target instance
	 */
	function createInstance (target:ManagedObject) : ObjectProcessor;
	
	
}
}
