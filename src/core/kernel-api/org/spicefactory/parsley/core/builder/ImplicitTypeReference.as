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
package org.spicefactory.parsley.core.builder {

import org.spicefactory.parsley.core.registry.ResolvableValue;
	
/**
 * A type reference that relies on the target type getting deduced
 * from the member (property, method, constructor) it gets injected into.
 * 
 * @author Jens Halm
 */
public interface ImplicitTypeReference extends ResolvableValue {
	
	
	/**
	 * Invoked by the container to pass the target type deduced
	 * by reflecting on the member.
	 * 
	 * @param type the target type as determined by the container
	 */
	function expectedType (type: Class): void;
	
	
}
}
