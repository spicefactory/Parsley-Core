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

package org.spicefactory.parsley.dsl.core {
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Responsible for replacing the processed object definition with the final 
 * definition to be used for registering it in the container or use it as
 * a nested object. This is an advanced feature. From all the builtin tags only the Factory tag
 * uses this hook.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionReplacer {
	
	/**
	 * Replaces (or wraps) the final object definition.
	 * 
	 * @param definition the definition to be replaced
	 * @return the final definition to be used by the registry
	 */
	function replace (definition:ObjectDefinition) : ObjectDefinition;
	
	
}
}
