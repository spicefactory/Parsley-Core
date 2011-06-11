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

package org.spicefactory.parsley.dsl.impl {
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * A part of an object definition builder that gets invoked when building the final definition.
 * This is primarily used internally and not considered part of the public API.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionBuilderPart {
	
	
	/**
	 * Applies this builder part to the final definition
	 * 
	 * @param target the final definition to apply this part to
	 */
	function apply (target:ObjectDefinition) : void;
	
	
}
}
